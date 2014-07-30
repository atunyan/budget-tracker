/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/19/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */


#import "RegisterViewController.h"
#import "UserInfo.h"
#import "Constants.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import <QuartzCore/QuartzCore.h>
#import "MyBudgetHelper.h"

/// the tag for unsername textfield
#define UNSERNAME_TAG 11

/// the tag for password textfield
#define PASSWORD_TAG 22

/// the tag for keep me logged in
#define KEEP_ME_LOGGED_IN_TAG 33

/// the tag for login button
#define REGISTER_BUTTON_TAG 44

/// The tag for displaying first name textField 
#define FIRSTNAME_TAG 55

/// The tag for displaying last name textField 
#define LASTNAME_TAG 66

/// The tag for displaying the user's phone number textField
#define PHONE_NUMBER_TAG 77

/// The tag for displaying the user's email textField
#define EMAIL_TAG 88

/// The tag for displaying the confirm password textField
#define CONFIRM_PASSWORD_TAG 99

/// The tag for displaying the accountNumber textField
#define ACCOUNT_NUMBER_TAG 111

@implementation RegisterViewController
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        userInfo = [[UserInfo alloc] init];
        arrayOfTextFields = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections. @todo the last section, "account number"
    // is commented out at this point.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 3;
        case 1: case 2:
            return 2;
        case 3:
            return 1;
        default:
            break;
    }
    return 0;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;   
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (PASSWORD_TAG == textField.tag || CONFIRM_PASSWORD_TAG == textField.tag) {
        if (textField.text.length >= MAX_PASSWORD_LENGTH && range.length == 0) {
            return NO; // return NO to not change text
        } 
    }
    switch (textField.tag) {
        case PASSWORD_TAG:
            userInfo.password = textField.text;
            break;
        case CONFIRM_PASSWORD_TAG:
            userInfo.confirmPassword = textField.text;
            break;
        case UNSERNAME_TAG:
            userInfo.nickname = textField.text;
            break;
        case FIRSTNAME_TAG:
            userInfo.firstName = textField.text;
            break;
        case LASTNAME_TAG:
            userInfo.lastName = textField.text;
            break;
        case PHONE_NUMBER_TAG:
            userInfo.phoneNumber = textField.text;
            break;
        case EMAIL_TAG:
            userInfo.eMail = textField.text;
            break;
        case ACCOUNT_NUMBER_TAG:
            userInfo.accountNumber = textField.text;
            break;
        default:
            break;
    }
    return  YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case PASSWORD_TAG:
            userInfo.password = textField.text;
            break;
        case CONFIRM_PASSWORD_TAG:
            userInfo.confirmPassword = textField.text;
            break;
        case UNSERNAME_TAG:
            userInfo.nickname = textField.text;
            break;
        case FIRSTNAME_TAG:
            userInfo.firstName = textField.text;
            break;
        case LASTNAME_TAG:
            userInfo.lastName = textField.text;
            break;
        case PHONE_NUMBER_TAG:
            userInfo.phoneNumber = textField.text;
            break;
        case EMAIL_TAG:
            userInfo.eMail = textField.text;
            break;
        case ACCOUNT_NUMBER_TAG:
            userInfo.accountNumber = textField.text;
            break;
        default:
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void) createTextField:(UITableViewCell *) cell 
                isPassword:(BOOL)isPassword 
                   tag : (NSInteger) tag
          keyboardType :(UIKeyboardType) keyboardType
           placeHolder : (NSString *)  placeHolder 
                   text:(NSString *)text {
    UITextField* textField = (UITextField *) [cell viewWithTag:tag];
    if (!textField) {
        textField = [[[UITextField alloc] initWithFrame:CGRectMake(170, cell.frame.origin.y, cell.frame.size.width - 170, cell.frame.size.height)] autorelease];
        textField.backgroundColor = [UIColor clearColor];
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.borderStyle = UITextBorderStyleNone;
        textField.tag = tag;
        if (tag == FIRSTNAME_TAG || tag == LASTNAME_TAG) {
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        }
        textField.font = [UIFont boldSystemFontOfSize:14];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.delegate = self;
        textField.keyboardType = keyboardType;
        [textField setReturnKeyType:UIReturnKeyDone];
        if (isPassword) {
            textField.secureTextEntry = YES;
        }
        [arrayOfTextFields addObject:textField];
        cell.accessoryView = textField;
    }
    if ([text length] > 0) {
        textField.text = text;   
    } else {
        textField.placeholder = placeHolder;
    }
}

-(BOOL) arePasswordsMatching {
    return ([userInfo.confirmPassword isEqualToString:userInfo.password]);    
}

-(BOOL) isPasswordValid {
    if ([userInfo.password length] < 6) {
        return NO;
    }
    return YES;
}

-(BOOL) isEnteredPhoneNumberValid {
    if ([userInfo.phoneNumber isEqualToString:@""]) {
        return YES;
    }
    NSError* error = NULL;
    NSDataDetector* detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
                                                               error:&error];
    NSArray *matches = [detector  matchesInString:userInfo.phoneNumber
                                         options:0
                                           range:NSMakeRange(0, [userInfo.phoneNumber length])];
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypePhoneNumber) {
            //NSString *phoneNumber = [match phoneNumber];
            return  YES;
        }
    }
    return NO;
}


-(BOOL) isEnteredEmailValid {
    if (![userInfo.eMail isEqualToString:@""] ) {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
        return [emailTest evaluateWithObject:userInfo.eMail];
    }
    return YES;
}

-(BOOL) checkMandatoryFields {
    if ([userInfo.firstName isEqualToString:@""] || [userInfo.lastName isEqualToString:@""] || 
        [userInfo.nickname isEqualToString:@""] || [userInfo.password isEqualToString:@""]  || 
        [userInfo.confirmPassword isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Please fill in required field.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    return YES;
}

-(void) resignFirstResponders {
    for (UITextField* textField in arrayOfTextFields) {
        if ([textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
    }
}

-(void)resetPasswordFields {
    for (UITextField* textField in arrayOfTextFields) {
        if (textField.tag == PASSWORD_TAG || textField.tag == CONFIRM_PASSWORD_TAG) {
            textField.text = @"";
        }
    }
}

-(void)trimSpaces {
    userInfo.nickname = [MyBudgetHelper trimString:userInfo.nickname];
    userInfo.password = [MyBudgetHelper trimString:userInfo.password];
    userInfo.confirmPassword = [MyBudgetHelper trimString:userInfo.confirmPassword];
    userInfo.firstName = [MyBudgetHelper trimString:userInfo.firstName];
    userInfo.lastName = [MyBudgetHelper trimString:userInfo.lastName];
}

-(void) registerUser:(UIButton *) button {
    [self resignFirstResponders];
    
    [self trimSpaces];
    
    if (![self checkMandatoryFields]) {
        return;
    }
    
    if ([[CoreDataManager instance] isNicknameBusy:userInfo.nickname]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Nickname is already used. Please try another nickname.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (![self isPasswordValid]) {
        [self resetPasswordFields];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Short passwords are easy to guess. Try one with at least 6 characters.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (![self arePasswordsMatching]) {
        [self resetPasswordFields];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Passwords do not match. Please try again.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
   
    if (![self isEnteredPhoneNumberValid]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"The entered phone number is invalid. Please try again.", nil) delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (![self isEnteredEmailValid]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"The entered email is invalid. Please try again.", nil) delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }

    // Logout old user
    [MOUser resetUserData];
    
    if ([[CoreDataManager instance] saveUserData:userInfo]) {
        [MOUser setKeepMeLoggedIn:YES];
        [MOUser instance].isLogged = [NSNumber numberWithBool:YES];
        [[NSUserDefaults standardUserDefaults] setObject:[MOUser instance].nickname forKey:USER_NICKNAME];
        [[NSUserDefaults standardUserDefaults] setObject:[MOUser instance].password forKey:USER_PASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [MOUser setLastLoggedUserName:[MOUser instance].nickname];
        [[NSUserDefaults standardUserDefaults] setObject:[MOUser lastLoggedUserName] forKey:LAST_LOGGED_USER_NAME];
        
        if([delegate respondsToSelector:@selector(dismissRegisterPage)]){
            [delegate dismissRegisterPage];
        }
    }
}

-(void) createRegisterButton:(UIView *) footerView {
    UIButton* button = (UIButton *)[footerView viewWithTag:REGISTER_BUTTON_TAG];
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* image =  [MyBudgetHelper imageWithColor:[UIColor colorWithRed:195.0/255.0 green:189.0/255.0 blue:180.0/255.0 alpha:1.0f]];
        button.frame = CGRectMake(footerView.frame.origin.x + 10,
                                  footerView.frame.origin.y + 10, 
                                  300, 35);
        button.tag = REGISTER_BUTTON_TAG;
        [button addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 5;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        
        [button setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
        [footerView addSubview:button];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (2 == section) {
        return 100;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (2 == section) {
        UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 110)] autorelease];
        [self createRegisterButton:view];
        return view;
    }
    return  nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.textColor = [UIColor colorWithRed:189.0/255.0 green:19.0/255.0 blue:45.0/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (0 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = NSLocalizedString(USER_NICKNAME, nil);
                [self createTextField:cell isPassword:NO 
                                  tag:UNSERNAME_TAG 
                         keyboardType:UIKeyboardTypeDefault
                          placeHolder:NSLocalizedString(USER_NICKNAME, nil) text:userInfo.nickname];
                break;
            case 1:
                cell.textLabel.text = NSLocalizedString(@"Password", nil);
                [self createTextField:cell isPassword:YES tag:PASSWORD_TAG 
                         keyboardType:UIKeyboardTypeDefault 
                          placeHolder:NSLocalizedString(@"at least 6 characters", nil) text:userInfo.password];
                break;
            case 2:
                cell.textLabel.text = NSLocalizedString(@"Confirm Password", nil);
                [self createTextField:cell isPassword:YES tag:CONFIRM_PASSWORD_TAG 
                         keyboardType:UIKeyboardTypeDefault 
                          placeHolder:NSLocalizedString(@"at least 6 characters", nil) text:userInfo.confirmPassword];
                break;
            default:
                break;
        }
    } else if (1 == indexPath.section) { 
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = NSLocalizedString(@"Firstname", nil);
                [self createTextField:cell isPassword:NO 
                                  tag:FIRSTNAME_TAG 
                         keyboardType:UIKeyboardTypeDefault 
                          placeHolder:NSLocalizedString(@"Firstname", nil) text:userInfo.firstName];
                break;
            case 1:
                cell.textLabel.text = NSLocalizedString(@"Lastname", nil);
                [self createTextField:cell isPassword:NO 
                                  tag:LASTNAME_TAG 
                         keyboardType:UIKeyboardTypeDefault 
                          placeHolder:NSLocalizedString(@"Lastname", nil) text:userInfo.lastName];
                break;
            default:
                break;
        }
    } else if (2 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = NSLocalizedString(@"Phone number", nil);
                [self createTextField:cell isPassword:NO tag:PHONE_NUMBER_TAG 
                         keyboardType:UIKeyboardTypePhonePad 
                          placeHolder:NSLocalizedString(@"Not mandatory", nil) text:userInfo.phoneNumber];
                break;
                
            case 1:
                cell.textLabel.text = NSLocalizedString(@"Email", nil);
                [self createTextField:cell isPassword:NO tag:EMAIL_TAG
                         keyboardType:UIKeyboardTypeEmailAddress
                          placeHolder:NSLocalizedString(@"Not mandatory", nil) text:userInfo.eMail];
                break; 
            default:
                break;
        }
    }

    // Configure the cell...
    return cell;
}

-(void) dealloc {
    [arrayOfTextFields release];
    [super dealloc];
}

@end
