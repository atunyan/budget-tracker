/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 10.04.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */


#import "SearchSettingsTableViewController.h"
#import "MOUser.h"
#import "SearchData.h"
#import "CoreDataManager.h"
#import "MOSearchSettings.h"
#import "Constants.h"
#import "DurationPickerViewController.h"

/// the tag for state button
#define STATE_BUTTON_TAG 22

/// The switch indicating whether the start/end date is specified for search
#define PERIOD_SWITCH_TAG 55

/// The tag for the label displaying start/end date 
#define DATE_LABEL_TAG 66

/// Declarations for the private methods should be here.
@interface SearchSettingsTableViewController () {

BOOL isSwitchOn;

}

@end

@implementation SearchSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        isSwitchOn = [SearchData instance].startDate || [SearchData instance].endDate;
    }
    return self;
}

-(void) saveSearchSettings {
    if (isSwitchOn && (![SearchData instance].startDate || ![SearchData instance].endDate)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) 
                                                            message:NSLocalizedString(@"Start/End Dates are not selected.", nil) 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    MOSearchSettings* searchSettings = [[CoreDataManager instance] searchSettings];

    searchSettings.searchInIncomeAmount = [SearchData instance].searchInIncomeAmount;
    searchSettings.searchInIncomeName = [SearchData instance].searchInIncomeName;
    searchSettings.searchInIncomeAccount = [SearchData instance].searchInIncomeAccount;
    searchSettings.searchInAccountAmount = [SearchData instance].searchInAccountAmount;
    searchSettings.searchInAccountName = [SearchData instance].searchInAccountName;
    searchSettings.searchInAccountType = [SearchData instance].searchInAccountType;
    searchSettings.searchInPaymentAmount = [SearchData instance].searchInPaymentAmount;
    searchSettings.searchInPaymentName = [SearchData instance].searchInPaymentName;
    searchSettings.searchInPaymentAccount = [SearchData instance].searchInPaymentAccount;
    searchSettings.searchInPaymentLocation = [SearchData instance].searchInPaymentLocation;
    searchSettings.searchInPaymentCategory = [SearchData instance].searchInPaymentCategory;
    
    searchSettings.startDate = [SearchData instance].startDate;
    searchSettings.endDate = [SearchData instance].endDate;
    
    [MOUser instance].searchSettings = searchSettings;
    
    [[CoreDataManager instance] saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}

/// creates pay bar button
-(void) createSaveBarButton {
    UIBarButtonItem* saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveSearchSettings)];
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    [saveBarButtonItem release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSaveBarButton];

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"Incomes", nil); 
        case 1:
            return NSLocalizedString(@"Accounts", nil); 
        case 2:
            return NSLocalizedString(@"Payments", nil);
        case 3:
            return NSLocalizedString(@"Search Period", nil);
        default:
            break;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 3;
        case 2:
            return 5;
        case 3:                                                 
            if (isSwitchOn) {
                return 2;
            } 
            return 1;
        default:
            break;
    }
    return 0;
}

-(void) updateStateButton:(UIButton *) button {
    switch (button.tag - STATE_BUTTON_TAG) {
        case 0: {
            BOOL boolValue = [[SearchData instance].searchInIncomeAmount boolValue];
            NSNumber* number = [NSNumber numberWithBool:!boolValue];

            [SearchData instance].searchInIncomeAmount = number;
        }
            break;
        case 1: {
            BOOL boolValue = [[SearchData instance].searchInIncomeName boolValue];
            NSNumber* number = [NSNumber numberWithBool:!boolValue];
            
            [SearchData instance].searchInIncomeName = number;
        }
            break;
        case 2: {
            BOOL boolValue = [[SearchData instance].searchInIncomeAccount boolValue];
            NSNumber* number = [NSNumber numberWithBool:!boolValue];
            
            [SearchData instance].searchInIncomeAccount = number;
        }
            break;
        case 3: {
            BOOL boolValue = [[SearchData instance].searchInAccountAmount boolValue];
            NSNumber* number = [NSNumber numberWithBool:!boolValue];
            
            [SearchData instance].searchInAccountAmount = number;
        }
            break;
        case 4: {
            BOOL boolValue = [[SearchData instance].searchInAccountName boolValue];
            NSNumber* number = [NSNumber numberWithBool:!boolValue];
            
            [SearchData instance].searchInAccountName = number;
        }
            break;
        case 5: {
            BOOL boolValue = [[SearchData instance].searchInAccountType boolValue];
            NSNumber* number = [NSNumber numberWithBool:!boolValue];
            
            [SearchData instance].searchInAccountType = number;
        }
            break;
        case 6: {
            BOOL boolValue = [[SearchData instance].searchInPaymentAmount boolValue];
            NSNumber* number = [NSNumber numberWithBool:!boolValue];
            
            [SearchData instance].searchInPaymentAmount = number;
        }
            break;
        case 7: {
            BOOL boolValue = [[SearchData instance].searchInPaymentName boolValue];
            NSNumber* number = [NSNumber numberWithBool:!boolValue];
            
            [SearchData instance].searchInPaymentName = number;
        }
            break;
        case 8: {
            BOOL boolValue = [[SearchData instance].searchInPaymentAccount boolValue];
            NSNumber* number = [NSNumber numberWithBool:!boolValue];
            
            [SearchData instance].searchInPaymentAccount = number;
        }
            break;
        case 9: {
            BOOL boolValue = [[SearchData instance].searchInPaymentLocation boolValue];
            NSNumber* number = [NSNumber numberWithBool:!boolValue];
            
            [SearchData instance].searchInPaymentLocation = number;
        }
            break;
        case 10: {
            BOOL boolValue = [[SearchData instance].searchInPaymentCategory boolValue];
            NSNumber* number = [NSNumber numberWithBool:!boolValue];
            
            [SearchData instance].searchInPaymentCategory = number;
        }
            break;
        default:
            break;
    }
    
    UIImage* image = [UIImage imageNamed:@"checkboxCheckedBig.png"];
    if ([button.currentBackgroundImage isEqual:image]) {
        [button setBackgroundImage:[UIImage imageNamed:@"checkboxUncheckedBig.png"] forState:UIControlStateNormal];
        
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"checkboxCheckedBig.png"] forState:UIControlStateNormal];
    }
}

-(void)createStateButton:(UITableViewCell *) cell 
               isChecked:(BOOL) isChecked  
                     tag:(NSInteger) tag {
    UIButton* button = (UIButton *)[cell viewWithTag:tag];
    UIImage* image = [UIImage imageNamed:@"checkboxCheckedBig.png"];
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(270, 10, image.size.width, image.size.height);
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        button.tag = tag;
        [button addTarget:self action:@selector(updateStateButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = button;
    }
    if (isChecked) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"checkboxUncheckedBig.png"] forState:UIControlStateNormal];
    }
}

-(void) changeSwitchState:(UISwitch *) sender {
    isSwitchOn = !isSwitchOn;
    if (!isSwitchOn) {
        [SearchData instance].startDate = nil;
        [SearchData instance].endDate = nil;
    }
    [self.tableView reloadData];

    if (isSwitchOn) {
        NSIndexPath *offsetIndexPath = [NSIndexPath indexPathForRow:1 inSection:3];
        [self.tableView scrollToRowAtIndexPath:offsetIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void) createSwitch:(UITableViewCell *) cell {
    UISwitch* switchView = (UISwitch *)[cell viewWithTag:PERIOD_SWITCH_TAG];
    if (!switchView) {
        switchView = [[[UISwitch alloc] initWithFrame: CGRectMake(220, 10, 100, cell.frame.size.height)] autorelease];
        switchView.tag = PERIOD_SWITCH_TAG;
        switchView.onTintColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
        [switchView addTarget:self action:@selector(changeSwitchState:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchView];
    }
    switchView.on = isSwitchOn;
}

-(void) createDateLabel:(UITableViewCell *) cell {
    UILabel* dateLabel = (UILabel *) [cell viewWithTag:DATE_LABEL_TAG];
    if (! dateLabel) {
        dateLabel = [[[UILabel alloc] init] autorelease];
        dateLabel.textColor = [UIColor darkGrayColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:14.0f];
        dateLabel.tag = DATE_LABEL_TAG;
        dateLabel.textAlignment = UITextAlignmentRight;
        dateLabel.frame = CGRectMake(130, 0, 160, cell.frame.size.height);
        [cell addSubview: dateLabel];
    }
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [formatter setDateFormat:DATE_FORMAT_STYLE];
    NSString* startDate = nil;
    NSString* endDate = nil;
    if ([SearchData instance].startDate) {
        startDate = [formatter stringFromDate:[SearchData instance].startDate];
    }
    if ([SearchData instance].endDate) {
        endDate = [formatter stringFromDate:[SearchData instance].endDate];
    }
    dateLabel.text = [startDate stringByAppendingFormat:@" - %@", endDate];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier1 = @"CellSwitch";
    static NSString *CellIdentifier2 = @"CellLabel";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cellSwitch = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    UITableViewCell *cellLabel = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (nil == cellSwitch) {
        cellSwitch = [[[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
        cellSwitch.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        cellSwitch.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (nil == cellLabel) {
        cellLabel = [[[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
        cellLabel.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        cellLabel.selectionStyle = UITableViewCellSelectionStyleGray;
        cellLabel.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Amount", nil);
                    [self createStateButton:cell isChecked:[[SearchData instance].searchInIncomeAmount boolValue] tag:STATE_BUTTON_TAG];
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Name", nil);
                    [self createStateButton:cell isChecked:[[SearchData instance].searchInIncomeName boolValue] tag:STATE_BUTTON_TAG + 1];
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"Account", nil);
                    [self createStateButton:cell isChecked:[[SearchData instance].searchInIncomeAccount boolValue] tag:STATE_BUTTON_TAG + 2];
                    break;                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Amount", nil);
                    [self createStateButton:cell isChecked:[[SearchData instance].searchInAccountAmount boolValue] tag:STATE_BUTTON_TAG + 3];
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Name", nil);
                    [self createStateButton:cell isChecked:[[SearchData instance].searchInAccountName boolValue] tag:STATE_BUTTON_TAG + 4];
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"Type", nil);
                    [self createStateButton:cell isChecked:[[SearchData instance].searchInAccountType boolValue] tag:STATE_BUTTON_TAG + 5];
                    break;                    
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Amount", nil);
                    [self createStateButton:cell isChecked:[[SearchData instance].searchInPaymentAmount boolValue] tag:STATE_BUTTON_TAG + 6];
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Name", nil);
                    [self createStateButton:cell isChecked:[[SearchData instance].searchInPaymentName boolValue] tag:STATE_BUTTON_TAG + 7];
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"Account", nil);
                    [self createStateButton:cell isChecked:[[SearchData instance].searchInPaymentAccount boolValue] tag:STATE_BUTTON_TAG + 8];
                    break;  
                case 3:
                    cell.textLabel.text = NSLocalizedString(@"Location", nil);
                    [self createStateButton:cell isChecked:[[SearchData instance].searchInPaymentLocation boolValue] tag:STATE_BUTTON_TAG + 9];
                    break;  
                case 4:
                    cell.textLabel.text = NSLocalizedString(@"Category", nil);
                    [self createStateButton:cell isChecked:[[SearchData instance].searchInPaymentCategory boolValue] tag:STATE_BUTTON_TAG + 10];
                    break;  
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    cellSwitch.textLabel.text = NSLocalizedString(@"Period", nil);
                    [self createSwitch:cellSwitch];
                    return cellSwitch;
                case 1:
                    cellLabel.textLabel.text = NSLocalizedString(@"Start/End Dates", nil);
                    [self createDateLabel:cellLabel];
                    return cellLabel;
                default:
                    break;
            }
        default:
            break;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

-(void)openDatePickerView {
    DurationPickerViewController *durationPickerViewController = [[DurationPickerViewController alloc] initWithStartDate:[SearchData instance].startDate andEndDate:[SearchData instance].endDate];
    durationPickerViewController.delegate = (id)self;
    durationPickerViewController.title = NSLocalizedString(@"Duration", nil);
    [self.navigationController pushViewController:durationPickerViewController animated:YES];
    [durationPickerViewController release];
}

-(void)didSavedWithStartDate:(NSDate*)startDate andWithEndDate:(NSDate*)endDate {
    if (startDate && endDate) {
        [SearchData instance].startDate = startDate;
        [SearchData instance].endDate = endDate;
        [self.tableView reloadData];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (3 == indexPath.section && 1 == indexPath.row) {
        [self openDatePickerView];
    }
}

@end
