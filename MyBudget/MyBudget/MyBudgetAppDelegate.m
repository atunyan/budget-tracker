/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 10.01.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "MyBudgetAppDelegate.h"
#import "MyBudgetViewController.h"
#import "Constants.h"
#import "MOUser.h"
#import "MOPayment.h"
#import "MOIncome.h"
#import "MORecurrence.h"
#import "CoreDataManager.h"
#import "MyBudgetViewController.h"
#import "LoginViewController.h"
#import "TransferViewController.h"
#import "MyBudgetHelper.h"
#import "TestInfo.h"

/// The notification string to show that the banner view action started.
NSString * const BannerViewActionWillBegin = @"BannerViewActionWillBegin";


/// The notification string to show that the banner view action finished.
NSString * const BannerViewActionDidFinish = @"BannerViewActionDidFinish";


@implementation MyBudgetAppDelegate {
    UIViewController<BannerViewContainer> *_currentController;
    ADBannerView *_bannerView;
}

@synthesize window = _window;
@synthesize viewController;
@synthesize receivedTransfer;
@synthesize receivedDate;
@synthesize rootNavigationController;

- (void)dealloc
{
    [_window release];
    [viewController release];
    if (receivedTransfer) {
        [receivedTransfer release];
    }
    [super dealloc];
}

//- (void)initializeiCloudAccess {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if ([[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] != nil)
//            NSLog(@"iCloud is available\n");
//        else
//            NSLog(@"This tutorial requires iCloud, but it is not available.\n");
//    });
//}

-(BOOL) startBackgroundLogin {
    [MOUser setLastLoggedUserName:[[NSUserDefaults standardUserDefaults] objectForKey:LAST_LOGGED_USER_NAME]];
    
    BOOL keepMeLoggedIn = [[[NSUserDefaults standardUserDefaults] objectForKey:KEEP_ME_LOGGED_IN] boolValue];
    if (keepMeLoggedIn) {
        NSString* nickname = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:USER_NICKNAME];
        NSString* password = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:USER_PASSWORD];
        if(nickname && password) {
            MOUser* newUser = (MOUser*)[[CoreDataManager instance] userByNickname:nickname andPassword:password];
            if (newUser) {
                [MOUser setInstance:newUser];
                [MOUser setKeepMeLoggedIn:keepMeLoggedIn];
                [MOUser instance].isLogged = [NSNumber numberWithBool:YES];
                
                // Delete old data by delete after months value
                [[CoreDataManager instance] deleteOldData];
                return YES;
            }
        }
    }
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        /// redirect to the corresponding payment page.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TransferReminderArrives" object:nil];
    }
}



-(void) showAlert:(NSString *) title {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"My Budget", nil) 
                                                        message:title 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
                                              otherButtonTitles: NSLocalizedString(@"View Details", nil), nil];
    [alertView show];
    [alertView release];
}

- (void)stop:(UILocalNotification *)localNotif ifLastDate:(NSDate *)lastDate {    
    NSCalendar *calendar = localNotif.repeatCalendar;
    if (calendar) {
        NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
        components.day = localNotif.repeatInterval;
        NSDate *nextFireDate = [calendar dateByAddingComponents:components toDate:localNotif.fireDate options:0];
        
        if ([nextFireDate compare:lastDate] == NSOrderedDescending) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
        }
    }
}

-(void)transferObjectFromNotification:(UILocalNotification*)localNotif {
    if (localNotif) {
        NSString* stringID = [localNotif.userInfo objectForKey:LOCAL_NOTIF_OBJECT_ID];
        if (stringID) {
            NSURL *url = [NSURL URLWithString:stringID];
            NSManagedObjectID *moID = nil;
            @try {
                moID = [[[CoreDataManager instance].managedObjectContext persistentStoreCoordinator] managedObjectIDForURIRepresentation:url];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
                return;
            }
            @finally {
                NSLog(@"finally");
            }
            
            NSError* error = nil;
            MOTransfer *myOldMo = nil;
            if (moID) {
                myOldMo = (MOTransfer *)[[CoreDataManager instance].managedObjectContext existingObjectWithID:moID error:&error];
            }

            if (error) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) 
                                                                    message:NSLocalizedString(@"Item was not found", nil) 
                                                                   delegate:nil 
                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                          otherButtonTitles:nil, nil];
//                [alertView show];
                [alertView release];
                return;
            }
            
            if (myOldMo) {
                self.receivedDate = [NSDate date];
                
                receivedTransfer = nil;
                
                NSArray* recurrings = nil;
                recurrings = [CoreDataManager sortSet:myOldMo.recurrings byProperty:SORT_BY_DATE_TIME ascending:YES];
                
                for (MORecurrence* recurrence in recurrings) {
                    if ([[MyBudgetHelper dayFromDate:recurrence.dateTime] compare:[MyBudgetHelper dayFromDate:self.receivedDate]] == NSOrderedSame) {
                        receivedTransfer = (MOTransfer*)myOldMo;
                        break;
                    }
                }
                
                [self stop:localNotif ifLastDate:receivedTransfer.endDate];
            }
        }
    }
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    if ([self startBackgroundLogin]) {
        [self transferObjectFromNotification:notif];
        if (notif.applicationIconBadgeNumber > 0) {
            app.applicationIconBadgeNumber = notif.applicationIconBadgeNumber - 1;
        }
        if (receivedTransfer && receivedTransfer.name) {
            [self showAlert:[NSLocalizedString(@"Please take care of ", nil) stringByAppendingFormat:@"%@", receivedTransfer.name]];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil) 
                                                                message:NSLocalizedString(@"Recurrence not found", nil) 
                                                               delegate:nil 
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                      otherButtonTitles:nil, nil];
//            [alertView show];
            [alertView release];
            return;
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([self startBackgroundLogin]) {
        UILocalNotification *localNotif =
        [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        [self transferObjectFromNotification:localNotif];
    }

   // [self initializeiCloudAccess];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    CGRect bounds = [[UIScreen mainScreen] bounds];

    // The ADBannerView will fix up the given size, we just want to ensure it is created at a location off the bottom of the screen.
    // This ensures that the first animation doesn't come in from the top of the screen.
    _bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0, bounds.size.height, 0.0, 0.0)];
    _bannerView.delegate = self;
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {

        viewController = [[MyBudgetViewController alloc] init];   //Create the first view
        rootNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        rootNavigationController.delegate = self;
        [rootNavigationController.view setBackgroundColor:[UIColor whiteColor]];
        viewController.navigationController.navigationBar.tintColor = [UIColor colorWithRed:189.0/255.0 green:19.0/255.0 blue:45.0/255.0 alpha:1.0];

        [self.window addSubview:rootNavigationController.view];
        // for temporary data
        [TestInfo saveTemporaryData];
    } else {
//        self.viewController = [[[MyBudgetViewController alloc] initWithNibName:@"MyBudgetViewController_iPad" bundle:nil] autorelease];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    NSLog(@"Application entered background state.");
    if ([MOUser instance] && [MOUser instance].isLogged && ![MOUser keepMeLoggedIn]) {
        NSArray* viewControllers = rootNavigationController.viewControllers;
        NSArray* reversedViewControllers = [[viewControllers reverseObjectEnumerator] allObjects];
        int count = [reversedViewControllers count];
        for (int i = 0; i < count - 1; ++i) {
            UIViewController* v = [reversedViewControllers objectAtIndex:i];
            [v.navigationController popViewControllerAnimated:NO];
        }
        
        [MOUser resetUserData];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    if (![MOUser instance]) {
        [viewController openLoginPage];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [_currentController showBannerView:banner animated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [_currentController hideBannerView:_bannerView animated:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionWillBegin object:self];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionDidFinish object:self];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)vController animated:(BOOL)animated
{
    _currentController = [vController respondsToSelector:@selector(showBannerView:animated:)] ? (UIViewController<BannerViewContainer> *)viewController : nil;
    if (_bannerView.bannerLoaded && (_currentController != nil)) {
        [(UIViewController<BannerViewContainer> *)vController showBannerView:_bannerView animated:NO];
    }
}


@end
