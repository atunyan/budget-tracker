/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 10.01.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "HomeButtonsViewController.h"
#import "MOUser.h"
#import "CoreDataManager.h"
#import "Constants.h"


#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

/// The left margin 
#define LEFT_MARGIN 20 + BUTTON_WIDTH

/// The top margin
#define TOP_MARGIN BUTTON_HEIGHT + 20

@implementation HomeButtonsViewController

-(void)redirectToPage:(NSString *) paymentName {
    NSAssert(false, @"Should be implemented in derived classes.");
}

-(id) init {
    self = [super init];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(redirectToPage:) 
                                                     name: @"TransferReminderArrives"
                                                   object:nil];
        buttonNameTagDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void) showAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Start Screen changed", nil) 
                                                        message:NSLocalizedString(@"Please restart the application in order to see the changes.", nil) 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

-(void) saveChosenScreen:(NSString *)title {
    [self.navigationController popViewControllerAnimated:YES];
    [MOUser instance].setting.startScreen = title;
    [[CoreDataManager instance] saveContext];
    [self showAlert];
}

-(void) openIncomes:(UIButton *) sender {
    [self saveChosenScreen:NSLocalizedString(@"Income", nil)];
}

-(void) openSearchPage:(UIButton *) sender {
    [self saveChosenScreen:NSLocalizedString(@"Search", nil)];
}

-(void) openSettingsPage:(UIButton *) sender {
    [self saveChosenScreen:NSLocalizedString(@"Settings", nil)];
}

-(void) openPaymentsPage:(UIButton *) sender {
    [self saveChosenScreen:NSLocalizedString(@"Payments", nil)];
}

-(void) openAccountPage:(UIButton *) sender {
    [self saveChosenScreen:NSLocalizedString(@"Account", nil)];
}

-(void) openReports:(UIButton *) sender {
    [self saveChosenScreen:NSLocalizedString(@"Report", nil)];
}

-(void) openQuickSummary :(UIButton *) button {
    [self saveChosenScreen:NSLocalizedString(@"Summary", nil)];
}

-(void) openHomePage :(UIButton *) button {
    [self saveChosenScreen:NSLocalizedString(@"Home", nil)];
}

#pragma mark - View lifecycle

/**
 * @brief Creates the button with the specified parameters.
 * @param title - the button title
 * @param selector - the action which should be done when the button is selected
 * @param tag - the tag for the current button
 */
-(void) createButton:(NSString *) title 
          imageTitle:(NSString *) imageTitle
               frame:(CGPoint)frame 
           selector :(SEL) selector 
                tag : (NSUInteger) tag {   
    
    UIButton* button = (UIButton *)[self.view viewWithTag:tag];
    [button removeFromSuperview];
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:(SEL)selector forControlEvents:UIControlEventTouchUpInside];

        UIImage* image = [UIImage imageNamed:[imageTitle stringByAppendingString:@".png"]];
        [button setFrame:CGRectMake(frame.x, frame.y, 96, 96)];
        
        [button setImage:image forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:189.0/255.0 green:19.0/255.0 blue:45.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height + 15, (title.length > 9)? -82 :-90, 0, 0)];

        button.contentMode = UIViewContentModeScaleAspectFit;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [button setTitle:title forState:UIControlStateNormal];
        
        button.tag = tag;
        [buttonNameTagDictionary setValue:imageTitle forKey:[NSString stringWithFormat:@"%i", tag]];
        
        button.layer.cornerRadius = 8.0f;
        button.clipsToBounds = YES;

        [self.view addSubview:button];
    }
}

-(void) changeButton:(NSUInteger) tag {
    UIButton* button = (UIButton *)[self.view viewWithTag:tag];
    [button removeFromSuperview]; 
}

-(void)createButtons {
    NSUInteger topMargin = 20;
    NSUInteger leftMargin = 20;


    NSArray* arrayOfButtonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Account", nil),NSLocalizedString(@"Income", nil), NSLocalizedString(@"Payment", nil), NSLocalizedString(@"Summary", nil), NSLocalizedString(@"Report", nil),  NSLocalizedString(@"Search", nil), NSLocalizedString(@"Settings", nil), NSLocalizedString(@"Home", nil), nil];
    
    NSArray* arrayOfImageTitles = [NSArray arrayWithObjects:@"Account", @"Income", @"Payment", @"Summary", @"Report", @"Search", @"Settings", @"Home", nil];
    
    NSArray* arrayOfSelectors = [NSArray arrayWithObjects: @"openAccountPage:", @"openIncomes:", @"openPaymentsPage:", @"openQuickSummary:", @"openReports:", @"openSearchPage:", @"openSettingsPage:", @"openHomePage:",  nil];
         
    topMargin = 0;
    NSInteger numberOfColumns = 3;
    for (NSUInteger j = 0; j < numberOfRows; ++j) {
        leftMargin = 20;
        for (NSUInteger i = 0; i < numberOfColumns; ++i) {
            NSUInteger index = j*numberOfColumns + i;
            if (index < [arrayOfButtonTitles count]) {
                SEL selector = NSSelectorFromString([arrayOfSelectors objectAtIndex:index]);
                NSString* title = ([arrayOfButtonTitles objectAtIndex:index]);
                NSString* imageTitle = ([arrayOfImageTitles objectAtIndex:index]);
                [self createButton:title imageTitle:imageTitle frame:CGPointMake(leftMargin, topMargin) selector:selector tag:(LOGIN_BUTTON_TAG+index)];
                leftMargin += LEFT_MARGIN;
            }
        }
        topMargin += TOP_MARGIN;
    }    
}

// // Implement loadView to create a view hierarchy programmatically, without using a nib.
// - (void)loadView
// {
// }



-(void) createMainView {
    numberOfRows = 3;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self createButtons];
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"budget_bg.png"]];
    [self createMainView];
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
    self.title = NSLocalizedString(@"Choose Start Screen", nil);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"TransferReminderArrives" 
                                                  object:nil];

    [super dealloc];
}

@end

