/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 23/01/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "ContactUsViewController.h"
#import "MapViewController.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import "LocationInfo.h"

#import <QuartzCore/QuartzCore.h>

/// Munich view tag
#define INFO_MUNICH_VIEW_TAG            101

/// Press view tag
#define INFO_PRESS_VIEW_TAG             102

/// Munich map button tag
#define INFO_MUNICH_MAP_BUTTON_TAG      111

@implementation ContactUsViewController {
    ADBannerView *_bannerView;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBeginBannerViewActionNotification:) name:BannerViewActionWillBegin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishBannerViewActionNotification:) name:BannerViewActionDidFinish object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/// the target method, which calls at selecting location
-(void)openMunichMapView {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *mainConfigPath = [path stringByAppendingPathComponent:@"Config.plist"];
    NSDictionary *mainConfigDictionary = [NSDictionary dictionaryWithContentsOfFile:mainConfigPath];
    NSDictionary* contactsDictionary = [mainConfigDictionary valueForKey:@"Contact Us Munich"];
    
    CLLocationCoordinate2D myLocation;
    myLocation.latitude = [((NSNumber*)[contactsDictionary valueForKey:@"latitude"]) doubleValue];
    myLocation.longitude = [((NSNumber*)[contactsDictionary valueForKey:@"longitude"]) doubleValue];
    
    LocationInfo* locationInfo = [[LocationInfo alloc] init];
    locationInfo.coordinate = myLocation;
    locationInfo.title = NSLocalizedString(@"contact.us.munich.city", nil);
    locationInfo.subtitle = NSLocalizedString(@"contact.us.munich.street", nil);
    
    MapViewController* mapViewController = [[MapViewController alloc] initWithLocationInfo:locationInfo];
    [locationInfo release];
    
    mapViewController.view.frame = self.view.frame;
    mapViewController.navigationItem.rightBarButtonItem = nil;
    mapViewController.isTapAllowed = NO;
    [self.navigationController pushViewController:mapViewController animated:YES];
    [mapViewController release];
}


/**
 * @brief Creates the button with the specified parameters.
 * @param title - the button title
 * @param selector - the action which should be done when the button is selected
 * @param tag - the tag for the current button
 */
-(void) createButton:(NSString *)title 
               frame:(CGPoint)frame 
            selector:(SEL)selector 
                 tag:(NSUInteger)tag {
    
    UIButton* button = (UIButton *)[self.view viewWithTag:tag];
    [button removeFromSuperview];
    
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:(SEL)selector
         forControlEvents:UIControlEventTouchUpInside];
        
        UIImage* image = [UIImage imageNamed:[title stringByAppendingString:@".png"]];
        [button setFrame:CGRectMake(frame.x, frame.y,
                                    image.size.width, image.size.height)];
        [button setImage:image forState:UIControlStateNormal]; 
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];        
        button.tag = tag;
        [self.view addSubview:button];
    }
}

-(UILabel*)createLabelWithFrame:(CGRect)frame withText:(NSString*)text {
    UIFont* addressFont = [UIFont systemFontOfSize:14];
    UIColor* textColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc] init];
    label.frame = frame;
    label.backgroundColor = [UIColor clearColor];
    label.font = addressFont;
    label.text = text;
    label.textColor = textColor;
    
    return [label autorelease];
}

-(UIButton*)createButtonWithFrame:(CGRect)frame title:(NSString*)title selector:(SEL)selector {

    UIColor* color = [UIColor colorWithRed:189.0/255.0 green:19.0/255.0 blue:45.0/255.0 alpha:1.0];

    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:self action:(SEL)selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)addMunichInfoViewWithFrame:(CGRect)frame {
    // info view
    UIView* infoView = [self.view viewWithTag:INFO_MUNICH_VIEW_TAG];
    if (!infoView) {
        infoView = [[UIView alloc] initWithFrame:frame];
        infoView.tag = INFO_MUNICH_VIEW_TAG;
        
        int leftMargin = 5;
        int width = frame.size.width - leftMargin * 2;
        int titleHeight = 20;
        int top = 0;
        UIColor* textColor = [UIColor whiteColor];
        // place label
        UILabel* placeLabel = [[UILabel alloc] init];
        placeLabel.frame = CGRectMake(leftMargin, top, width, titleHeight);
        placeLabel.text = NSLocalizedString(@"contact.us.munich", nil);
        placeLabel.font = [UIFont boldSystemFontOfSize:15];
        placeLabel.backgroundColor = [UIColor clearColor];
        placeLabel.textColor = textColor;
        [infoView addSubview:placeLabel];
        [placeLabel release];
        
        // title label
        top += titleHeight;
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(leftMargin, top, width, titleHeight);
        titleLabel.text = NSLocalizedString(@"contact.us.munich.title", nil);
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = textColor;
        [infoView addSubview:titleLabel];
        [titleLabel release];
        
        int height = 18;
        // street label
        top += (titleHeight + 5);
        [infoView addSubview:[self createLabelWithFrame:CGRectMake(leftMargin, top, width, height) withText:NSLocalizedString(@"contact.us.munich.street", nil)]];
        
        // city label
        top += height;
        [infoView addSubview:[self createLabelWithFrame:CGRectMake(leftMargin, top, width, height) withText:NSLocalizedString(@"contact.us.munich.city", nil)]];
        
        // telephone label
        top += (height + 5);
        [infoView addSubview:[self createLabelWithFrame:CGRectMake(leftMargin, top, width, height) withText:NSLocalizedString(@"contact.us.munich.tel", nil)]];
        
        // fax label
        top += height;
        [infoView addSubview:[self createLabelWithFrame:CGRectMake(leftMargin, top, width, height) withText:NSLocalizedString(@"contact.us.munich.fax", nil)]];
        
        // email label
        top += height;
        UILabel* emailTitleLabel = [self createLabelWithFrame:CGRectMake(leftMargin, top, width, height) withText:NSLocalizedString(@"contact.us.munich.email.title", nil)];
        [infoView addSubview:emailTitleLabel];
        
        // email button
        CGSize emailTitleSize = [emailTitleLabel.text sizeWithFont:emailTitleLabel.font forWidth:width lineBreakMode:UILineBreakModeWordWrap];
        
        int left = emailTitleSize.width + 5;
        [infoView addSubview:[self createButtonWithFrame:CGRectMake(left, top, width - left, height) title:NSLocalizedString(@"contact.us.munich.email.address", nil) selector:@selector(emailButtonClicked:)]];
        
        // link
        top += height;
        [infoView addSubview:[self createButtonWithFrame:CGRectMake(0, top, width - left, height) title:NSLocalizedString(@"contact.us.munich.link", nil) selector:@selector(linkButtonClicked:)]];
        
        [self.view addSubview:infoView];
        [infoView release];
    }
}

-(void)addPressInfoViewWithFrame:(CGRect)frame {
    // info view
    UIView* infoView = [self.view viewWithTag:INFO_PRESS_VIEW_TAG];
    if (!infoView) {
        infoView = [[UIView alloc] initWithFrame:frame];
        infoView.tag = INFO_PRESS_VIEW_TAG;
        
        int leftMargin = 5;
        int width = frame.size.width - leftMargin * 2;
        int titleHeight = 20;
        int top = 0;
        UIColor* textColor = [UIColor whiteColor];
        // press label
        UILabel* nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(leftMargin, top, width, titleHeight);
        nameLabel.text = NSLocalizedString(@"contact.us.press", nil);
        nameLabel.font = [UIFont boldSystemFontOfSize:15];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = textColor;
        [infoView addSubview:nameLabel];
        [nameLabel release];
        
        int height = 18;
        // name label
        top += (titleHeight + 5);
        [infoView addSubview:[self createLabelWithFrame:CGRectMake(leftMargin, top, width, height) withText:NSLocalizedString(@"contact.us.press.name", nil)]];
        
        // press name label
        top += height;
        [infoView addSubview:[self createLabelWithFrame:CGRectMake(leftMargin, top, width, height) withText:NSLocalizedString(@"contact.us.press.press.name", nil)]];
        
        // telephone label
        top += (height + 5);
        [infoView addSubview:[self createLabelWithFrame:CGRectMake(leftMargin, top, width, height) withText:NSLocalizedString(@"contact.us.press.tel", nil)]];
        
        // fax label
        top += height;
        [infoView addSubview:[self createLabelWithFrame:CGRectMake(leftMargin, top, width, height) withText:NSLocalizedString(@"contact.us.press.fax", nil)]];
        
        // email label
        top += height;
        UILabel* emailTitleLabel = [self createLabelWithFrame:CGRectMake(leftMargin, top, width, height) withText:NSLocalizedString(@"contact.us.press.email.title", nil)];
        [infoView addSubview:emailTitleLabel];
        
        // email button
        CGSize emailTitleSize = [emailTitleLabel.text sizeWithFont:emailTitleLabel.font forWidth:width lineBreakMode:UILineBreakModeWordWrap];
        
        int left = emailTitleSize.width + 5;
        [infoView addSubview:[self createButtonWithFrame:CGRectMake(left, top, width - left, height) title:NSLocalizedString(@"contact.us.press.email.address", nil) selector:@selector(emailButtonClicked:)]];
        
        // link
        top += height;
        [infoView addSubview:[self createButtonWithFrame:CGRectMake(0, top, width - left, height) title:NSLocalizedString(@"contact.us.press.link", nil) selector:@selector(linkButtonClicked:)]];
        
        [self.view addSubview:infoView];
        [infoView release];
    }
}

-(void)sendEmailTo:(NSString*)address {
    [MailManager instance].delegate = self;
    NSString* subject = @"";
    
    NSArray* toRecipients = [NSArray arrayWithObjects:address, nil];
    
    // Fill out the email body text
    NSString * appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@""];
    NSString * systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *emailBody = [NSString stringWithFormat:@"",appVersion, systemVersion];
    [[MailManager instance] feedbackAction:subject recipients:toRecipients
                                    emailBody:emailBody];
}

-(void)emailButtonClicked:(UIButton*)sender {
    [self sendEmailTo:sender.titleLabel.text];
}

-(void)linkButtonClicked:(UIButton*)sender {
    NSURL *url = [[NSURL alloc] initWithString:sender.titleLabel.text];
    [[UIApplication sharedApplication] openURL:url];
    [url release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"budget_bg.png"]];
    self.title = NSLocalizedString(@"contact.us", nil);

    // Munich
    [self addMunichInfoViewWithFrame:CGRectMake(15, 10, 290, 160)];
//    [self createButton:@"Map" frame:CGPointMake(170, 45) selector:@selector(openMunichMapView) tag:INFO_MUNICH_MAP_BUTTON_TAG];
    
    // Press
    [self addPressInfoViewWithFrame:CGRectMake(15, 190, 270, 160)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self layoutAnimated:NO];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
