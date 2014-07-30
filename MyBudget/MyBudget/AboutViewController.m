/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 06.04.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "AboutViewController.h"
#import "MOUser.h"
#import "CoreDataManager.h"
#import "Constants.h"
#import "ContactUsViewController.h"
#import "ImpressumViewController.h"


#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

/// The left margin 
#define LEFT_MARGIN 17 + BUTTON_WIDTH

/// The top margin
#define TOP_MARGIN BUTTON_HEIGHT + 20

/// The tag for Login button
#define BUTTON_TAG 77



@implementation AboutViewController

-(id) init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


-(void) openContactPage :(UIButton *) button {
    ContactUsViewController* contactUsViewController = [[ContactUsViewController alloc] init];
    [self.navigationController pushViewController:contactUsViewController animated:YES];
    [contactUsViewController release];
}

-(void) openImpressumPage :(UIButton *) button {
    ImpressumViewController* impressumViewController = [[ImpressumViewController alloc] init];
    [self.navigationController pushViewController:impressumViewController animated:YES];
    [impressumViewController release];
}

-(void) openFeedbackPage :(UIButton *) button {
    [MailManager instance].delegate = self;
    NSString* subject = @"Feedback on MyBudget iphone app";
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *mainConfigPath = [path stringByAppendingPathComponent:@"Config.plist"];
    NSDictionary *mainConfigDictionary = [NSDictionary dictionaryWithContentsOfFile:mainConfigPath];
    NSArray* toRecipients = [mainConfigDictionary valueForKey:@"feedback"];
    
    // Fill out the email body text
    NSString * appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString * systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *emailBody = [NSString stringWithFormat:@"iPhone app Version : %@\n iPhone system version : %@",appVersion, systemVersion];
    [[MailManager instance] feedbackAction:subject recipients:toRecipients
                                    emailBody:emailBody];
}

/**
 * @todo the functionality should be implemented later as the app is uploaded to 
 * appStore.
 */
-(void) openReviewPage :(UIButton *) button {
    NSURL* url = [NSURL URLWithString:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=350212768&pageNumber=0& sortOrdering=1&type=Purple+Software&mt=8"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - View lifecycle

/**
 * @brief Creates the button with the specified parameters.
 * @param title - the button title
 * @param selector - the action which should be done when the button is selected
 * @param tag - the tag for the current button
 */
-(void) createButton:(NSString *) title 
               frame:(CGPoint)frame 
           selector :(SEL) selector 
                tag : (NSUInteger) tag {   
    
    UIButton* button = (UIButton *)[self.view viewWithTag:tag];
    [button removeFromSuperview];
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:(SEL)selector forControlEvents:UIControlEventTouchUpInside];

        UIImage* image = [UIImage imageNamed:[title stringByAppendingString:@".png"]];
        [button setFrame:CGRectMake(frame.x, frame.y,
                                    image.size.width, image.size.height)];
        [button setImage:image forState:UIControlStateNormal]; 
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];

        button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        button.titleLabel.textAlignment = UITextAlignmentCenter;
        button.tag = tag;
        
        button.layer.cornerRadius = 8.0f;
        button.clipsToBounds = YES;

        [self.view addSubview:button];
    }
}

-(void)createButtons {
    NSUInteger topMargin = 20;
    NSUInteger firstLeftMargin = 17;
    NSUInteger leftMargin = firstLeftMargin;

    NSArray* arrayOfButtonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Contact", nil), NSLocalizedString(@"Impressum", nil), NSLocalizedString(@"Feedback", nil), NSLocalizedString(@"Review", nil), nil];
    
    NSArray* arrayOfSelectors = [NSArray arrayWithObjects:@"openContactPage:", @"openImpressumPage:", @"openFeedbackPage:", @"openReviewPage:", nil];
         
    NSUInteger length = ceil([arrayOfButtonTitles count] / (float)numberOfColumns);
    for (NSUInteger i = 0; i < length; ++i) {
        if (i >= 3) {
            leftMargin += 17;
        } 
        topMargin = 20;
        for (NSUInteger j = 0; j < numberOfColumns; ++j) {
            NSUInteger index = i*numberOfColumns + j;
            if (index < [arrayOfButtonTitles count]) {
                SEL selector = NSSelectorFromString([arrayOfSelectors objectAtIndex:index]);
                NSString* title = ([arrayOfButtonTitles objectAtIndex:index]);
                [self createButton:title frame:CGPointMake(leftMargin, topMargin) selector:selector tag:(BUTTON_TAG + index)];
                topMargin += TOP_MARGIN;
            }
        }
        leftMargin += LEFT_MARGIN;
    }    
}

// // Implement loadView to create a view hierarchy programmatically, without using a nib.
// - (void)loadView
// {
// }

- (void)viewDidLoad
{    
    [super viewDidLoad];
    self.title = NSLocalizedString(@"About", nil);
    numberOfColumns = 3;
    [self createButtons];
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
    [super dealloc];
}

@end

