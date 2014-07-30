/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 10.01.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "MyBudgetViewController.h"
#import "LoginViewController.h"
#import "AccountsListTableViewController.h"
#import "IncomesListTableViewController.h"
#import "PaymentsListViewController.h"
#import "IncomesListTableViewController.h"
#import "ReportViewTypes.h"
#import "AboutViewController.h"
#import "MOPayment.h"
#import "MOIncome.h"
#import "PaymentViewController.h"
#import "IncomeViewController.h"
#import "CoreDataManager.h"
#import "QuickSummaryTableViewController.h"
#import "SearchTableViewController.h"

#import "MOUser.h"
#import "Constants.h"

/// The tag for the imageview to be inserted when transparent button is selected.
#define TRANSPARENT_BUTTON_IMAGEVIEW_TAG 99

/// The custom page control tag
#define CUSTOM_PAGE_CONTROL_TAG 11


@implementation MyBudgetViewController {
    ADBannerView *_bannerView;
}

-(id) init {
    self  = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBeginBannerViewActionNotification:) name:BannerViewActionWillBegin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishBannerViewActionNotification:) name:BannerViewActionDidFinish object:nil];
    }
    return self;
}


-(void) openLoginPage:(UIButton *)sender {
    if (sender) {
        pageName = [[buttonNameTagDictionary valueForKey:[NSString stringWithFormat:@"%i", sender.tag]] retain];
    }
    LoginViewController* registerViewController = [[LoginViewController alloc] initWithBackButtonHidden:NO];
    registerViewController.title = pageName;
    [self.navigationController pushViewController:registerViewController animated:YES];
    [registerViewController release];
}

-(void) openIncomes:(UIButton *) sender {
    [_bannerView removeFromSuperview];
    if ([MOUser instance].isLogged) {
        IncomesListTableViewController *incomesTableViewController = [[IncomesListTableViewController alloc] init];
        incomesTableViewController.title = sender.titleLabel.text;
        [self.navigationController pushViewController:incomesTableViewController animated:YES];
        [incomesTableViewController release];        
    } else {
        [self openLoginPage:sender];
    }
}

-(void) openSearchPage:(UIButton *)sender {
    [_bannerView removeFromSuperview]; 
    if ([MOUser instance].isLogged) {
        SearchTableViewController* searchViewController = [[SearchTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:searchViewController animated:YES];
        [searchViewController release];
    } else {
        [self openLoginPage:sender];
    }
}

-(void) openSettingsPage:(UIButton *)sender {
    [_bannerView removeFromSuperview];
    if ([MOUser instance].isLogged) {
        SettingsTableViewController* settingsTableViewController = [[SettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        settingsTableViewController.delegate = self;
        [self.navigationController pushViewController:settingsTableViewController animated:YES];
        [settingsTableViewController release];
    } else {
        [self openLoginPage:sender];
    }
}

-(void) openPaymentsPage:(UIButton *)sender {
    [_bannerView removeFromSuperview];
    if ([MOUser instance].isLogged) {
        PaymentsListViewController* paymentsTableViewController = [[PaymentsListViewController alloc] init];
        [self.navigationController pushViewController:paymentsTableViewController animated:YES];
        [paymentsTableViewController release];
    } else {
        [self openLoginPage:sender];
    }
}

-(void) openAccountPage:(UIButton *)sender {
    if ([MOUser instance].isLogged) {
        AccountsListTableViewController *accoutsListTableViewController = [[AccountsListTableViewController alloc] init];
        [self.navigationController pushViewController:accoutsListTableViewController animated:YES];
        [accoutsListTableViewController release];
    } else {
        [self openLoginPage:sender];
    }
}

-(void) openReports:(UIButton *)sender {
    if ([MOUser instance].isLogged) {
        ReportViewTypes * viewController= [[ReportViewTypes alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];            
    } else {
        [self openLoginPage:sender];
    }
}

-(void) openAboutPage :(UIButton *) sender {
    AboutViewController* aboutViewController = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutViewController animated:YES];
    [aboutViewController release];
}

-(void) openQuickSummary:(UIButton *)sender {
    [_bannerView removeFromSuperview];
    if ([MOUser instance].isLogged) {
        QuickSummaryTableViewController* qsTableViewController = [[QuickSummaryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:qsTableViewController animated:YES];
        [qsTableViewController release];
    } else {
        [self openLoginPage:sender];
    }
}

-(void)redirectToPage:(NSString *) paymentName {
    if ([MOUser instance].isLogged) {
        MyBudgetAppDelegate* appDelegate = (MyBudgetAppDelegate *) [[UIApplication sharedApplication] delegate];
        if (appDelegate.receivedTransfer) {            
            [self.navigationController popToRootViewControllerAnimated:NO];

            if ([appDelegate.receivedTransfer isKindOfClass:[MOPayment class]]) {
                PaymentsListViewController* paymentsTableViewController = [[PaymentsListViewController alloc] init];
                PaymentViewController * paymentViewController = [[PaymentViewController alloc] initWithTransfer:appDelegate.receivedTransfer isOpenedFromCalendar:NO];
                paymentViewController.selectedDate = appDelegate.receivedDate;
                paymentViewController.title = BILL_PAGE_TITLE;
                [self.navigationController pushViewController:paymentViewController animated:YES];
                [paymentViewController release];
                [paymentsTableViewController release];
            } else {
                IncomesListTableViewController* incomesTableViewController = [[IncomesListTableViewController alloc] init];
                IncomeViewController * incomeViewController = [[IncomeViewController alloc] initWithTransfer:appDelegate.receivedTransfer isOpenedFromCalendar:NO];
                incomeViewController.selectedDate = appDelegate.receivedDate;
                incomeViewController.title = INCOME_PAGE_TITLE;
                [self.navigationController pushViewController:incomeViewController animated:YES];
                [incomeViewController release];
                [incomesTableViewController release];
            }
        }
    } else {
        [self openLoginPage:nil];
    }
}

-(void)openLoginPage {    
    LoginViewController* registerViewController = [[LoginViewController alloc] initWithBackButtonHidden:YES];
    registerViewController.delegate = self;
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:registerViewController];
    [self presentViewController:navController animated:YES completion:nil];
    [registerViewController release];
    [navController release];
}

#pragma mark - LoginViewControllerDelegate methods

-(void)didUserLoggedIn {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self openStartScreen];
}

-(void)didUserLoggedOut {
    [self openLoginPage];
}

-(void)openStartScreen {
    if ([[MOUser instance].isLogged boolValue]) {
        NSString* startScreen = [MOUser instance].setting.startScreen;
        if ([startScreen isEqualToString:NSLocalizedString(@"Home", nil)]) {
            // Do nothing...
        } else if ([startScreen isEqualToString:NSLocalizedString(@"Login", nil)]) {
            [self openLoginPage:nil];
        } else if ([startScreen isEqualToString:NSLocalizedString(@"Income", nil)]) {
            [self openIncomes:nil];
        } else if ([startScreen isEqualToString:NSLocalizedString(@"Payments", nil)]) {
            [self openPaymentsPage:nil];
        } else if ([startScreen isEqualToString:NSLocalizedString(@"Account", nil)]) {
            [self openAccountPage:nil];
        } else if ([startScreen isEqualToString:NSLocalizedString(@"Report", nil)]) {
            [self openReports:nil];
        } else if ([startScreen isEqualToString:NSLocalizedString(@"Search", nil)]) {
            [self openSearchPage:nil];
        } else if ([startScreen isEqualToString:NSLocalizedString(@"Settings", nil)]) {
            [self openSettingsPage:nil];
        } else if ([startScreen isEqualToString:NSLocalizedString(@"Summary", nil)]) {
            [self openQuickSummary:nil];
        }
    }
}

-(void)openPageByName:(NSString*)startScreen {
    if ([startScreen isEqualToString:NSLocalizedString(@"Income", nil)]) {
        [self openIncomes:nil];
    } else if ([startScreen isEqualToString:NSLocalizedString(@"Payments", nil)]) {
        [self openPaymentsPage:nil];
    } else if ([startScreen isEqualToString:NSLocalizedString(@"Account", nil)]) {
        [self openAccountPage:nil];
    } else if ([startScreen isEqualToString:NSLocalizedString(@"Report", nil)]) {
        [self openReports:nil];
    } else if ([startScreen isEqualToString:NSLocalizedString(@"Search", nil)]) {
        [self openSearchPage:nil];
    } else if ([startScreen isEqualToString:NSLocalizedString(@"Settings", nil)]) {
        [self openSettingsPage:nil];
    }
    pageName = nil;
}

-(void)createElements {
    [self changeButton:(LOGIN_BUTTON_TAG + 7)];
    
    self.title = [[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleName"];
    if ([MOUser instance].firstName ) {
        self.title = [NSLocalizedString(@"Welcome", nil) stringByAppendingFormat:@"%@!", 
                 [MOUser instance].firstName ? [NSString stringWithFormat:@" %@", [MOUser instance].firstName] : @""];
    }
}

- (void)viewDidLoad
{    
    [super viewDidLoad];  
    
    [self openStartScreen];
    
    [self layoutAnimated:NO];
}

- (void)layoutAnimated:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        _bannerView.frame = CGRectMake(0, self.view.frame.size.height - bannerFrame.size.height, bannerFrame.size.width, bannerFrame.size.height);
        [UIView commitAnimations];
        
        
    }else {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        _bannerView.frame = CGRectMake(0, self.view.frame.size.height + bannerFrame.size.height, bannerFrame.size.width, bannerFrame.size.height); 
        [UIView commitAnimations];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![[MOUser instance].isLogged boolValue]){
        [self openLoginPage];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createElements];
}

- (void)showBannerView:(ADBannerView *)bannerView animated:(BOOL)animated
{
    _bannerView = bannerView;
    [self layoutAnimated:animated];
    [self.view addSubview:_bannerView];
}

- (void)hideBannerView:(ADBannerView *)bannerView animated:(BOOL)animated
{
    _bannerView = nil;
    [self layoutAnimated:animated];
}

- (void)willBeginBannerViewActionNotification:(NSNotification *)notification
{
}

- (void)didFinishBannerViewActionNotification:(NSNotification *)notification
{

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end

