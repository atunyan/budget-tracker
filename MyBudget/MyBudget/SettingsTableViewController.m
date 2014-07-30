/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/6/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "SettingsTableViewController.h"
#import "ConfigManager.h"
#import "CurrencyTableViewController.h"
#import "CurrencyInfo.h"
#import "MOUser.h"
#import "CoreDataManager.h"
#import "ColorPickerViewController.h"
#import "HomeButtonsViewController.h"
#import "Constants.h"
#import "ICloudDocument.h"
#import "LanguageTableViewController.h"
#import "ImpressumViewController.h"
#import "ContactUsViewController.h"

#import <QuartzCore/QuartzCore.h>

/// Reset alert view's tag
#define ALERT_VIEW_RESET_TAG                50

/// Backup alert view's tag
#define ALERT_VIEW_BACKUP_TAG               51

/// Restore alert view's tag
#define ALERT_VIEW_RESTORE_TAG              52

/// App exit alert view's tag
#define ALERT_VIEW_EXIT_APP                 53


/// Month start date text field tag
#define TEXT_FIELD_MONTH_START_DATE_TAG     110

/// Delete after months text field tag
#define TEXT_FIELD_DELETE_AFTER_MONTHS_TAG  111

/// The tag for color view
#define COLOR_VIEW_TAG 112

/// max date of all months
#define MAX_DATE_OF_MONTH                   28

/// The tag for label of applications' version
#define APP_VERSION_LABEL_TAG 55

/// The animation enable/disable switch tag
#define ANIMATION_SWITCH_TAG 56

@implementation SettingsTableViewController

@synthesize metadataQuery;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    self.title = NSLocalizedString(@"Settings", nil);
    [self.tableView reloadData];
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
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 1;
        case 2:
            return 2;
        case 3:
            return 1; // set 3 to open the Backup and Restore rows.
        case 4:
            return 4;
        default:
            break;
    }
    return 0;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"General", nil);
        case 1:
            return NSLocalizedString(@"Account", nil);
        case 2:
            return NSLocalizedString(@"Income and Expense entries", nil);
        case 3:
            return NSLocalizedString(@"Maintenance", nil);
        case 4:
            return NSLocalizedString(@"About", nil);
        default:
            break;
    }
    return @"";
}

-(UITextField*)createTextFieldByTag:(int)tag byText:(NSString*)text cell:(UITableViewCell *) cell{
    UITextField* textField = (UITextField*)[cell.contentView viewWithTag:tag];
    [textField removeFromSuperview];
    if (!textField) {
        textField = [[[UITextField alloc] init] autorelease];
        textField.frame = CGRectMake(250, 13, 30, 25);
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.delegate = self;
        textField.tag = tag;
        textField.text = text;
        textField.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
        cell.accessoryView = textField;
    }
    return textField;
}

-(void) createColorView:(UITableViewCell*) cell {
    UIView* view = [cell viewWithTag:COLOR_VIEW_TAG];
    [view removeFromSuperview];
    if (!view) {
        view = [[[UIView alloc] initWithFrame:CGRectMake(230, 5, 50, cell.contentView.frame.size.height - 10)] autorelease];
        view.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
        view.tag = COLOR_VIEW_TAG;
        view.layer.borderWidth = .0f;
        view.layer.cornerRadius = 8.0f;
        view.layer.borderColor = [[UIColor grayColor] CGColor];
        [cell addSubview:view];
    }
}

/**
 * @brief dont' delete. will be used when there will be need to add animation.
 */
/// this method creates enable/disable animation switch
//-(void)createAnimationSwitch:(UITableViewCell*)cell {
//    UISwitch* animationSwitch = (UISwitch*)[cell viewWithTag:ANIMATION_SWITCH_TAG];
//    if(!animationSwitch){
//        animationSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - 100, 8, 0, 0)] autorelease];
//        animationSwitch.on = [[MOUser instance].setting animation];
//        [animationSwitch addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
//        [cell addSubview:animationSwitch];
//    }
//}
//-(void)changeSwitchValue:(UISwitch*)sender {
//    MOSetting* settings = [[CoreDataManager instance] setting];
//    if(sender.on){
//        settings.animation = YES;
//    }else {
//        settings.animation = NO;
//    }
//    [MOUser instance].setting = settings;
//    [[CoreDataManager instance] saveContext];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.detailTextLabel.text = @"";
    cell.detailTextLabel.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
    [[cell viewWithTag:COLOR_VIEW_TAG] removeFromSuperview];
    cell.accessoryView = nil;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    // Start screen
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = NSLocalizedString(@"Start screen", nil);
                    cell.detailTextLabel.text = NSLocalizedString([MOUser instance].setting.startScreen, nil);
                    break;
                case 1:
					// @todo the code below is for choosing colour theme may be used in the future
					//                    cell.textLabel.text = NSLocalizedString(@"Theme", nil);
					//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					//                    [self createColorView:cell];
					//                    break;
					//                case 2:
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = NSLocalizedString(@"Home currency", nil);
                    cell.detailTextLabel.text = [MOUser instance].setting.currency;
                    break;
                case 2:
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = NSLocalizedString(@"Language", nil);
                    cell.detailTextLabel.text = [MOUser instance].setting.language;
                    break;
                case 3:
                    // App version
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = NSLocalizedString(@"App version", nil);
                    NSString* versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                    cell.detailTextLabel.text = versionNumber;
                    break;
                    /// @brief don't delete.will be used when there will be need to add animation.
					//                case 6:
					//                    // enable/disable animtaion
					//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
					//                    cell.accessoryType = UITableViewCellAccessoryNone;
					//                    cell.textLabel.text = NSLocalizedString(@"Animation", nil);
					//                    [self createAnimationSwitch:cell];
					//                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    // User info
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = NSLocalizedString(@"User Info", nil);
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    // Month start date (1 - 28)
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Month start date (1-%i)", nil), MAX_DATE_OF_MONTH];
                    [self createTextFieldByTag:TEXT_FIELD_MONTH_START_DATE_TAG byText:[MOUser instance].setting.monthStartDate cell:cell];
                    break;
                case 1:
                    // Delete after (months)
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = NSLocalizedString(@"Delete after (months)", nil);
                    [self createTextFieldByTag:TEXT_FIELD_DELETE_AFTER_MONTHS_TAG byText:[MOUser instance].setting.deleteAfterMonths cell:cell];
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
					//                case 0:
					//                    // Backup
					//                    cell.accessoryType = UITableViewCellAccessoryNone;
					//                    cell.textLabel.text = NSLocalizedString(@"Backup", nil);
					//                    break;
					//                case 1:
					//                    // Restore
					//                    cell.accessoryType = UITableViewCellAccessoryNone;
					//                    cell.textLabel.text = NSLocalizedString(@"Restore", nil);
					//                    break;
                case 0:
                    // Full reset
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = NSLocalizedString(@"Full reset", nil);
                    break;
                default:
                    break;
            }
            break;
		default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: {
                    // Start screen
                    HomeButtonsViewController* homeButtonsViewController =
                    [[HomeButtonsViewController alloc] init];
                    [self.navigationController pushViewController:homeButtonsViewController animated:YES];
                    [homeButtonsViewController release];
                    break;
                }
					//                case 1:
					// @todo the code below is for choosing colour theme may be used in the future
					//                {
					//                    ColorPickerViewController* colorChooserView = [[ColorPickerViewController alloc] init];
					//                    [self.navigationController pushViewController:colorChooserView animated:YES];
					//                    [colorChooserView release];
					//                }
					//                    break;
					//                case 2:
                    // Month start date (1 - 28)
					//                    break;
                case 1: {
                    // Home currency
                    CurrencyInfo* currencyInfo = [[CurrencyInfo alloc] init];
                    currencyInfo.elementArray = [[ConfigManager instance] arrayFromPlistFile:@"Config.plist" byKey:@"Currency"];
                    currencyInfo.currentElement = [MOUser instance].setting.currency;
                    CurrencyTableViewController* currencyTableViewController = [[CurrencyTableViewController alloc] initWithStyle:UITableViewStylePlain andWithInfo:currencyInfo andWithTitle:NSLocalizedString(@"Select Currency", nil)];
                    [currencyInfo release];
                    [self.navigationController pushViewController:currencyTableViewController animated:YES];
                    [currencyTableViewController scrollToSelectedRow];
                    [currencyTableViewController release];
                    break;
                }
                case 2:{
                    // Language
                    SelectingInfo* languageInfo = [[SelectingInfo alloc] init];
                    languageInfo.elementArray = [[ConfigManager instance] arrayFromPlistFile:@"Config.plist" byKey:@"Language"];
                    languageInfo.currentElement = [MOUser instance].setting.language;
                    LanguageTableViewController* languageTableViewController = [[LanguageTableViewController alloc] initWithStyle:UITableViewStyleGrouped andWithInfo:languageInfo andWithTitle:NSLocalizedString(@"Select Language", nil)];
                    [languageInfo release];
                    [self.navigationController pushViewController:languageTableViewController animated:YES];
                    [languageTableViewController release];
                    break;
                }
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0: {
                    // Open login page
                    LoginViewController* loginViewController = [[LoginViewController alloc] initWithBackButtonHidden:NO];
                    loginViewController.delegate = self;
                    [self.navigationController pushViewController:loginViewController animated:YES];
                    [loginViewController release];
                    break;
                }
                default:
                    break;
            }
            break;
        case 2:
            break;
        case 3:
            switch (indexPath.row) {
					//                case 0: {
					//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", nil)
					//                                                                        message:NSLocalizedString(@"The Backup functionality will be available in the next version.", nil)
					//                                                                       delegate:self
					//                                                              cancelButtonTitle:nil
					//                                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
					//                    alertView.tag = ALERT_VIEW_BACKUP_TAG;
					//                    [alertView show];
					//                    [alertView release];
					//
					////                    // Backup
					////                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Create Backup for MyBudget?", nil)
					////                                                                        message:NSLocalizedString(@"Create Backup for MyBudget?", nil)
					////                                                                       delegate:self
					////                                                              cancelButtonTitle:NSLocalizedString(@"NO", nil)
					////                                                              otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
					////                    alertView.tag = ALERT_VIEW_BACKUP_TAG;
					////                    [alertView show];
					////                    [alertView release];
					//                    break;
					//                }
					//                case 1: {
					//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", nil)
					//                                                                        message:NSLocalizedString(@"The Restore functionality will be available in the next version.", nil)
					//                                                                       delegate:self
					//                                                              cancelButtonTitle:nil
					//                                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
					//                    alertView.tag = ALERT_VIEW_RESTORE_TAG;
					//                    [alertView show];
					//                    [alertView release];
					////                    // Restore
					////                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Restore MyBudget?", nil)
					////                                                                        message:NSLocalizedString(@"Restore MyBudget?", nil)
					////                                                                       delegate:self
					////                                                              cancelButtonTitle:NSLocalizedString(@"NO", nil)
					////                                                              otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
					////                    alertView.tag = ALERT_VIEW_RESTORE_TAG;
					////                    [alertView show];
					////                    [alertView release];
					//                    break;
					//                }
                case 0: {
                    // Full reset
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Fully reset MyBudget?", nil)
                                                                        message:NSLocalizedString(@"This will delete all data that you have entered and leave MyBudget as if it was newly installed. Would you like to continue?", nil)
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"NO", nil)
                                                              otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
                    alertView.tag = ALERT_VIEW_RESET_TAG;
                    [alertView show];
                    [alertView release];
                    break;
                }
                default:
                    break;
            }
            break;
		default:
            break;
    }
}

#pragma mark - LoginTableViewControllerDelegate methods

-(void)didUserLoggedOut {
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    if ([delegate respondsToSelector:@selector(didUserLoggedOut)]) {
        [delegate didUserLoggedOut];
    }
}

#pragma mark - iCloud methods

-(BOOL)isICloudAvailable {
    NSURL* ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"iCloud access at %@", ubiq);
        return YES;
    } else {
        NSLog(@"No iCloud access");
        return NO;
    }
}

#pragma mark - iCloud Backup

-(void)createBackup {
    NSString* fileName = [NSString stringWithFormat:@"MyBudget %@", [MOUser instance].nickname];
    
    NSURL* ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    
    NSURL* ubiquitousPackage = [[ubiq URLByAppendingPathComponent:DOCUMENTS] URLByAppendingPathComponent:fileName];
    
    ICloudDocument* tempDoc = [[[ICloudDocument alloc] initWithFileURL:ubiquitousPackage] autorelease];
    [tempDoc saveToURL:[tempDoc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (success) {
            [[CoreDataManager instance] saveContext];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Backup created!", nil)
                                                                message:[NSString stringWithFormat:NSLocalizedString(@"Created backup by name '%@'", nil), fileName]
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
    }];
}

-(void)backupApp {
    if ([self isICloudAvailable]) {
        [self createBackup];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No iCloud access", nil)
                                                            message:NSLocalizedString(@"No iCloud access", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

#pragma mark - iCloud Restore

-(void)restore {
    NSMetadataQuery* query = [[NSMetadataQuery alloc] init];
    self.metadataQuery = query;
    [query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",
                         NSMetadataItemFSNameKey, [NSString stringWithFormat:@"MyBudget %@", [MOUser instance].nickname]];
    [query setPredicate:pred];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryDidFinishGathering:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification
                                               object:query];
    [query startQuery];
    [query release];
}

-(void)loadData:(NSMetadataQuery*)query {
    NSLog(@"%i", [query resultCount]);
    if ([query resultCount] == 1) {
        NSMetadataItem* item = [query resultAtIndex:0];
        NSURL* url = [item valueForAttribute:NSMetadataItemURLKey];
        ICloudDocument* doc = [[[ICloudDocument alloc] initWithFileURL:url] autorelease];
        
        [doc openWithCompletionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"iCloud document opened");
                [[CoreDataManager instance] saveContext];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"App Restored!", nil)
                                                                    message:NSLocalizedString(@"In order to apply changes, you need to restart app. Please press OK", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                          otherButtonTitles:nil, nil];
                alertView.tag = ALERT_VIEW_EXIT_APP;
                [alertView show];
                [alertView release];
            } else {
                NSLog(@"failed opening document from iCloud");
            }
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Restore failed.", nil)
                                                            message:NSLocalizedString(@"There is no backup file.", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

-(void)queryDidFinishGathering:(NSNotification*)notification {
    NSMetadataQuery* query = [notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:query];
    self.metadataQuery = nil;
    [self loadData:query];
}

-(void)restoreApp {
    if ([self isICloudAvailable]) {
        [self restore];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No iCloud access", nil)
                                                            message:NSLocalizedString(@"No iCloud access", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_VIEW_RESET_TAG:
            if(buttonIndex == 1){
                [[CoreDataManager instance] deleteData:[MOUser instance] alsoFromPersitentStore:YES];
                [MOUser resetUserData];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_NICKNAME];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_PASSWORD];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEEP_ME_LOGGED_IN];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:LAST_LOGGED_USER_NAME];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        case ALERT_VIEW_BACKUP_TAG:
            if(buttonIndex == 1){
                [self backupApp];
            }
            break;
        case ALERT_VIEW_RESTORE_TAG:
            if(buttonIndex == 1){
                [self restoreApp];
            }
            break;
        case ALERT_VIEW_EXIT_APP:
            if(buttonIndex == 0){
                exit(0);
            }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Text maximum length is 2
    if (range.location >= 2) {
        return NO;
    }
    
    NSCharacterSet *validCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    BOOL shouldChange = [string length] == 0 || [string rangeOfCharacterFromSet:validCharacterSet].location != NSNotFound;
    
    if (!shouldChange) {
        return NO;
    }
    
    switch (textField.tag) {
        case TEXT_FIELD_MONTH_START_DATE_TAG: {
            if (([textField.text isEqualToString:@""] && [string intValue] < 1) ||
                ([[NSString stringWithFormat:@"%@%@", textField.text, string] intValue] > MAX_DATE_OF_MONTH)) {
                return NO;
            }
            break;
        }
            
        case TEXT_FIELD_DELETE_AFTER_MONTHS_TAG: {
            if ([textField.text isEqualToString:@""] && [string intValue] < 1) {
                return NO;
            }
            break;
        }
        default:
            break;
    }
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSString* text = textField.text;
    if (![text isEqualToString:@""]) {
        switch (textField.tag) {
            case TEXT_FIELD_MONTH_START_DATE_TAG:
                [MOUser instance].setting.monthStartDate = text;
                break;
                
            case TEXT_FIELD_DELETE_AFTER_MONTHS_TAG:
                [MOUser instance].setting.deleteAfterMonths = text;
                break;
            default:
                break;
        }
        [[CoreDataManager instance] saveContext];
    }
    return YES;
}

-(void)dealloc {
    if(metadataQuery) {
        [metadataQuery release];
    }
    [super dealloc];
}

@end
