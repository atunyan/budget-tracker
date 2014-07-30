/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/17/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "LoginViewController.h"
#import "Constants.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import "SearchData.h"
#import "MyBudgetHelper.h"

#import <QuartzCore/QuartzCore.h>

/// the tag for unsername textfield
#define USERNAME_TAG 111

/// the tag for password textfield
#define PASSWORD_TAG USERNAME_TAG + 1

/// the tag for keep me logged in
#define KEEP_ME_LOGGED_IN_TAG 33

/// the tag for login button
#define LOGIN_BUTTON_TAG 44

/// height for the buttons
#define LOGIN_BUTTON_HEIGHT 35

/// the width of lavel
#define LABEL_WIDTH 90

/// the vertical coordinate of the first view 
#define VERTICAL_Y 80


@implementation LoginViewController {
    ADBannerView *_bannerView;
}

@synthesize nickname;
@synthesize password;
@synthesize delegate;

- (id)initWithBackButtonHidden:(BOOL)isBackHidden
{
    self = [super init];
    if (self) {
        // Custom initialization
        keepMeLoggedIn = NO;
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBeginBannerViewActionNotification:) name:BannerViewActionWillBegin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishBannerViewActionNotification:) name:BannerViewActionDidFinish object:nil];
        
        isBackButtonHidden = isBackHidden;
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

-(void) redirectLoginPage {
    [self createNewUserBarButton];
}

-(void) createNewUser {
    registerViewController.title = NSLocalizedString(@"New User", nil);
    [self.navigationController pushViewController:registerViewController animated:YES];
}

/// creates New user bar button
-(void) createNewUserBarButton {
    UIBarButtonItem* newUserButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"New User", nil) style:UIBarButtonItemStyleDone target:self action:@selector(createNewUser)];
    self.navigationItem.rightBarButtonItem = newUserButtonItem;
    [newUserButtonItem release];
}

-(void) dismissRegisterPage {
    if ([delegate respondsToSelector:@selector(didUserLoggedIn)]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [delegate didUserLoggedIn];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:isBackButtonHidden];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:189.0/255.0 green:19.0/255.0 blue:45.0/255.0 alpha:1.0];
    self.title = NSLocalizedString(@"Login", nil);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Login_bg.png"]];
    
    [self createLabel:NSLocalizedString(@"Username", nil) tag:11 frame:CGRectMake(10, VERTICAL_Y, LABEL_WIDTH, LOGIN_BUTTON_HEIGHT)];
    NSString* title = [MOUser instance].nickname ? [MOUser instance].nickname : [MOUser lastLoggedUserName];
    [self createTextField:NO tag:USERNAME_TAG title:title frame:CGRectMake(LABEL_WIDTH + 10, VERTICAL_Y, 300 - LABEL_WIDTH, 35)];
    
    [self createLabel:NSLocalizedString(@"Password", nil) tag:12 frame:CGRectMake(10, VERTICAL_Y + LOGIN_BUTTON_HEIGHT + 10, LABEL_WIDTH, LOGIN_BUTTON_HEIGHT)];

    title = [MOUser instance].password;
    [self createTextField:YES tag:PASSWORD_TAG title:title frame:CGRectMake(LABEL_WIDTH + 10, VERTICAL_Y + LOGIN_BUTTON_HEIGHT + 10, 300 - LABEL_WIDTH, LOGIN_BUTTON_HEIGHT)];
    
    [self createLabel:NSLocalizedString(@"Keep me logged in", nil) tag:13 frame:CGRectMake(10, VERTICAL_Y + 2 *(LOGIN_BUTTON_HEIGHT + 10), LABEL_WIDTH  + 50, LOGIN_BUTTON_HEIGHT)];
    
    [self createKeepMeLoggedInButton:CGPointMake(285, VERTICAL_Y + 2 *(LOGIN_BUTTON_HEIGHT + 10))];
    
    [self createLoginButton:CGRectMake(10, VERTICAL_Y + 3 *(LOGIN_BUTTON_HEIGHT + 10), 300, LOGIN_BUTTON_HEIGHT)];
 
    self.nickname = [MOUser lastLoggedUserName];

    [self createNewUserBarButton];
    
    registerViewController = [[RegisterViewController alloc] initWithStyle:UITableViewStyleGrouped];
    registerViewController.delegate = self;
    registerViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 20, self.view.frame.size.width, self.view.frame.size.height - 95);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self layoutAnimated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [registerViewController release];
    registerViewController = nil;
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

#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void) createLabel:(NSString *) title tag :(NSInteger) tag frame :(CGRect) frame {
    UILabel* label = (UILabel*)[self.view viewWithTag:tag];
    if (!label) {
        label = [[[UILabel alloc] initWithFrame:frame] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentLeft;
        label.tag = tag;
        label.font = [UIFont boldSystemFontOfSize:14.0f];
        label.textColor = [UIColor whiteColor];
        [self.view addSubview:label];
    }
    label.text = title;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (PASSWORD_TAG == textField.tag) {
        self.password = textField.text;
    } else if (USERNAME_TAG == textField.tag) {
        self.nickname = textField.text;
    }
    return YES;   
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (PASSWORD_TAG == textField.tag) {
        if (textField.text.length >= MAX_PASSWORD_LENGTH && range.length == 0) {  
            return NO; // return NO to not change text
        } 
    }
    return  YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES; 
}

-(void) createTextField:(BOOL)isPassword 
                   tag : (NSInteger) tag 
                 title :(NSString *) title 
                 frame :(CGRect) frame {
    UITextField* textField = (UITextField *)[self.view viewWithTag:tag];
    if (!textField) {
        textField = [[[UITextField alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)] autorelease];
        textField.backgroundColor = [UIColor whiteColor];
        
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.tag = tag;
        textField.font = [UIFont boldSystemFontOfSize:14];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.delegate = self;     
        textField.borderStyle = UITextBorderStyleRoundedRect;
        if (isPassword) {
            textField.secureTextEntry = YES;
        }
        [self.view addSubview:textField];
    }
    if ([MOUser instance].isLogged) {
        [textField setEnabled:NO];
    } else {
        [textField setEnabled:YES];
    }
    if (title && ![title isEqualToString:@""]) {
        textField.text = title;
        textField.placeholder = @"";
    } else {
        textField.text = @"";
        textField.placeholder = NSLocalizedString(@"Please fill in field", nil);
    }
}

-(void) resignFirstResponders {
    if ([[self.view viewWithTag:USERNAME_TAG] isFirstResponder]) {
        [[self.view viewWithTag:USERNAME_TAG]  resignFirstResponder];
    } else if ([[self.view viewWithTag:PASSWORD_TAG]  isFirstResponder]) {
        [[self.view viewWithTag:PASSWORD_TAG]  resignFirstResponder];
    }
}

-(void) updateKeepMeLoggedinState:(UIButton *) button {
    [MOUser setKeepMeLoggedIn:![MOUser keepMeLoggedIn]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[MOUser keepMeLoggedIn]] forKey:KEEP_ME_LOGGED_IN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([MOUser keepMeLoggedIn]) {
        [button setBackgroundImage:[UIImage imageNamed:@"checkboxCheckedBig.png"] forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"checkboxUncheckedBig.png"] forState:UIControlStateNormal];
    }
    [self resignFirstResponders];
}

-(void)createKeepMeLoggedInButton:(CGPoint) point {
    UIButton* button = (UIButton *)[self.view viewWithTag:KEEP_ME_LOGGED_IN_TAG];
    UIImage* image = [UIImage imageNamed:@"checkboxCheckedBig.png"];
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(point.x, point.y, image.size.width, image.size.height);
        button.tag = KEEP_ME_LOGGED_IN_TAG;
        [button addTarget:self action:@selector(updateKeepMeLoggedinState:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    if ([MOUser keepMeLoggedIn]) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"checkboxUncheckedBig.png"] forState:UIControlStateNormal];
    }
}

-(void) loginOrLogoutUser:(UIButton *) button {
    if ([button.titleLabel.text isEqualToString:NSLocalizedString(@"Logout", nil)]) {
        [button setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
        /// Logout User
        [MOUser resetUserData];
        ((UITextField *)[self.view viewWithTag:USERNAME_TAG]).text = [MOUser lastLoggedUserName];
         ((UITextField *)[self.view viewWithTag:PASSWORD_TAG]).text = @"";
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_NICKNAME];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_PASSWORD];
        [MOUser setKeepMeLoggedIn:NO];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[MOUser keepMeLoggedIn]] forKey:KEEP_ME_LOGGED_IN];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // call delegate function
        if ([delegate respondsToSelector:@selector(didUserLoggedOut)]) {
            [delegate didUserLoggedOut];
        }
    } else {
        /// Login user
        [self resignFirstResponders];
        self.nickname = [MyBudgetHelper trimString:nickname];
        self.password = [MyBudgetHelper trimString:password];
        
        MOUser* newUser = [[CoreDataManager instance] userByNickname:nickname andPassword:password];
        if (newUser) {
            [MOUser setInstance:newUser];
            
            [MOUser instance].isLogged = [NSNumber numberWithBool:YES];
            [[NSUserDefaults standardUserDefaults] setObject:[MOUser instance].nickname forKey:USER_NICKNAME];
            [[NSUserDefaults standardUserDefaults] setObject:[MOUser instance].password forKey:USER_PASSWORD];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [MOUser setLastLoggedUserName:[MOUser instance].nickname];
            [[NSUserDefaults standardUserDefaults] setObject:[MOUser lastLoggedUserName] forKey:LAST_LOGGED_USER_NAME];
            
            [button setTitle:NSLocalizedString(@"Logout", nil) forState:UIControlStateNormal];
            
            // Delete old data by delete after months value
            [[CoreDataManager instance] deleteOldData];
            [[SearchData instance] initializeSearchLists];
            [[SearchData instance] initializeSearchParameters];
            
            [self dismissRegisterPage];
            
        } else {
            ((UITextField *)[self.view viewWithTag:USERNAME_TAG]).text = [MOUser lastLoggedUserName];
            ((UITextField *)[self.view viewWithTag:PASSWORD_TAG]).text = @"";
            [MOUser setKeepMeLoggedIn:NO];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[MOUser keepMeLoggedIn]] forKey:KEEP_ME_LOGGED_IN];
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"The entered username and/or password is incorrect. Please try again.", nil) delegate:self
                                                  cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            [alert show];
            [alert release];
        }
    }
}

-(void) createLoginButton:(CGRect) frame {
    UIButton* loginButton = (UIButton *)[self.view viewWithTag:LOGIN_BUTTON_TAG];
    if (!loginButton) {
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(frame.origin.x,
                                       frame.origin.y,
                                       frame.size.width, frame.size.height);
        loginButton.tag = LOGIN_BUTTON_TAG;
        [loginButton addTarget:self action:@selector(loginOrLogoutUser:) forControlEvents:UIControlEventTouchUpInside];
        //[loginButton setBackgroundImage:image forState:UIControlStateNormal];
        UIImage* image = [MyBudgetHelper imageWithColor:[UIColor colorWithRed:195.0/255.0 green:189.0/255.0 blue:180.0/255.0 alpha:1.0f]];
        [loginButton setBackgroundImage:image forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        loginButton.clipsToBounds = YES;
        loginButton.layer.cornerRadius = 5;
        if ([MOUser instance].nickname && ![[MOUser instance].nickname isEqualToString:@""]) {
            [loginButton setTitle:NSLocalizedString(@"Logout", nil) forState:UIControlStateNormal];
        } else {
            [loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
        }
        [self.view addSubview:loginButton];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (registerViewController) {
        [registerViewController release];
        registerViewController = nil;
    }
    [super dealloc];
}


@end


