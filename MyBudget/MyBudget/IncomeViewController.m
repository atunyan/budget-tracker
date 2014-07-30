/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 1/12/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "IncomeViewController.h"

#import "Constants.h"
#import "DatePickerViewController.h"
#import "MOUser.h"
#import "CoreDataManager.h"
#import "ReminderInfo.h"
#import "MORecurrence.h"
#import "MyBudgetHelper.h"
#import "ActionManager.h"

/// name alert view tag
#define ALERT_VIEW_NAME_TAG         400

@implementation IncomeViewController

- (id)initWithTransfer:(id)payment isOpenedFromCalendar:(BOOL)isFromCalendar
{
    self = [super initWithTransfer:payment];
    if (self) {
        initialDate = nil;
        selectedDate = [[NSDate alloc] init];
        
        scrollingUpHeight = 290;
        scrollingDownHeight = 70;
        
        isOpenedFromCalendar = isFromCalendar;
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

-(void) changeSwitchState:(UISwitch *) switcher {
    [self createPeriodFormWithRecurring:switcher.isOn withPeriodicity:currentMO.periodicity withEndDate:currentMO.endDate];
}

-(void)createRecurringForm {
    [self createRecurringFormWithRecurring:[currentMO.isRecurring boolValue]];
}

/// creates pay bar button
-(void) createAddBarButton {
    UIBarButtonItem* addBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", nil) style:UIBarButtonItemStyleDone target:self action:@selector(addIncome)];
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    [addBarButtonItem release];
}

-(void)addIncome {
    [ActionManager addToAccount:currentMO selectedDate:selectedDate];
    
    if (isOpenedFromCalendar) {
        [self createEditSaveBarButton:@selector(editSaveTransfer)];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)updatePage {
    MORecurrence* recurrence = nil;
    if (isOpenedFromCalendar) {
        recurrence = [MyBudgetHelper recurrenceByDate:selectedDate transfer:currentMO withFormatter:DATE_FORMAT_STYLE];
    } else {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"MM yyyy"];
        
        NSString* dateString = [formatter stringFromDate:selectedDate];
        
        NSArray* recurrings = [CoreDataManager sortSet:((MOIncome*)currentMO).recurrings byProperty:SORT_BY_DATE_TIME ascending:YES];
        for (MORecurrence* r in recurrings) {
            if ([[formatter stringFromDate:r.dateTime] isEqualToString:dateString]) {
                recurrence = r;
                selectedDate = [recurrence.dateTime retain];
                break;
            }
        }
    }
    
    if(recurrence && ![recurrence.isDone boolValue]){
        [self createAddBarButton];
    } else {
        [self createEditSaveBarButton:@selector(editSaveTransfer)];
    }
    
    if (initialDate) {
        [self createMainFieldsForm:currentMO.amount name:currentMO.name notes:currentMO.moDescription date:initialDate dateName:NSLocalizedString(@"Start Date", nil) accountName:((MOIncome*)currentMO).account.name];
    } else {        
        [self createMainFieldsForm:recurrence.amount name:currentMO.name notes:currentMO.moDescription date:recurrence.dateTime dateName:NSLocalizedString(@"Start Date", nil) accountName:((MOIncome*)currentMO).account.name];
    }
    
    [self createRecurringForm];
    [self createPeriodFormWithRecurring:[currentMO.isRecurring boolValue] withPeriodicity:currentMO.periodicity withEndDate:currentMO.endDate];
    
    if (transferViewModeType == kTransferViewModeUpdating) {
        [self createDeleteButton];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    transferScrollView.contentSize = CGSizeMake(self.view.frame.size.width, TRANSFER_VIEW_HEIGHT + scrollingDownHeight);
    
    [self updatePage];
}

-(void) openDataPickerView {
    [self openDataPickerViewWithPeriodicity:reminderInfo.periodicity withEndDate:reminderInfo.endDateTime withStartDate:initialDate ? initialDate : [NSDate date]];
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


-(void)openDatePickerView {
    [self resignTextFields];
    
    DatePickerViewController *datePickerViewController;
    if (initialDate) {
        datePickerViewController = [[DatePickerViewController alloc] initWithDate:initialDate withEndDate:reminderInfo.endDateTime andMode:UIDatePickerModeDate];
    } else {
        datePickerViewController = [[DatePickerViewController alloc] initWithDate:currentMO.dateTime withEndDate:reminderInfo.endDateTime andMode:UIDatePickerModeDate];
    }
    datePickerViewController.delegate = self;
    datePickerViewController.title = NSLocalizedString(@"Start Date", nil);
    [self.navigationController pushViewController:datePickerViewController animated:YES];
    [datePickerViewController release];
}

-(void)datePickerControllerDidSave:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_STYLE];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:DATE_BUTTON_TAG];
    [button setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    currentMO.dateTime = [formatter dateFromString:button.titleLabel.text];

    [formatter release];
    
    if ([((MOIncome*)currentMO).endDate compare:date] == NSOrderedAscending) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFromDate = [dateFormatter stringFromDate:date];
        ((MOIncome*)currentMO).endDate = [dateFormatter dateFromString:stringFromDate];
        
        [dateFormatter setDateFormat:DATE_FORMAT_STYLE];
        
         button = (UIButton *)[transferScrollView viewWithTag:REPEAT_BUTTON_TAG];
        [button setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@, till %@", nil), ((MOIncome*)currentMO).periodicity,[dateFormatter stringFromDate:((MOIncome*)currentMO).endDate]] forState:UIControlStateNormal];
        [dateFormatter release];
    }
}

-(void)saveTransfer {
    // Check errors
    UITextField* amountTextField = (UITextField *)[self.view viewWithTag:AMOUNT_TEXT_FIELD_TAG];
    if([amountTextField.text length] == 0){
        [self showMessageAlert:NSLocalizedString(@"Please fill in amount field", nil)];
        return;
    }
    
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setDecimalSeparator:@","];
    NSNumber * amount = [numberFormatter numberFromString:amountTextField.text];
    if (amount == nil) {
        [numberFormatter setDecimalSeparator:@"."];
        amount = [numberFormatter numberFromString:amountTextField.text];
    }
    [numberFormatter release];
    
    if([amount doubleValue] == 0){
        [self showMessageAlert:[NSString stringWithFormat:NSLocalizedString(@"You can't create %@ with 0 %@ amount. Please correct it", nil), NSLocalizedString(@"income", nil), [MOUser instance].setting.currency]];
        return;
    }

    UITextField* nameTextField = (UITextField *)[self.view viewWithTag:NAME_TEXT_FIELD_TAG];
    NSString* name = [MyBudgetHelper trimString:nameTextField.text];
    if([name length] == 0){
        [self showMessageAlert:NSLocalizedString(@"Please fill in name field", nil)];
        return;
    }
    
    if (transferViewModeType == kTransferViewModeAdding) {
        if(!((MOIncome*)currentMO).account && !didAccountSelected) {
            [self showMessageAlert:NSLocalizedString(@"Please select account", nil)];
            return;
        }
        
        BOOL isRecurringChecked = ((UISwitch *)[transferScrollView viewWithTag:RECURRING_FORM_TAG]).isOn;
        if (isRecurringChecked && !reminderInfo) {
            [self showMessageAlert:NSLocalizedString(@"Please select recurring periodicity and end date.", nil)];
            return;
        }
    }
    
    if ([[CoreDataManager instance] isInSet:[MOUser instance].incomes nameBusy:name] && ![currentMO.name isEqualToString:name] && isNameBusy) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"The name is already used.\nDo you still want to use it?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"NO", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
        alertView.tag = ALERT_VIEW_NAME_TAG;
        [alertView show];
        [alertView release];
        return;
    }
    
    // All right, can save
    if (!currentMO) {
        currentMO = [[CoreDataManager instance] income];
    }
    
    // name
    currentMO.name = name;
    
    // note
    UITextView* notes = (UITextView *)[self.view viewWithTag:NOTES_TEXT_VIEW_TAG];
    currentMO.moDescription = notes.text;
    
    if (transferViewModeType == kTransferViewModeAdding) {
        // amount
        currentMO.amount = amount;
        
        // account
        if (curAccount) {
            ((MOIncome*)currentMO).account = curAccount;
        }
        
        // date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:DATE_FORMAT_STYLE];
        UIButton* date = (UIButton *) [self.view viewWithTag:DATE_BUTTON_TAG];
        currentMO.dateTime = [formatter dateFromString:date.titleLabel.text];
        [formatter release];
        
        // recurring
        currentMO.isRecurring = [NSNumber numberWithBool:((UISwitch *)[transferScrollView viewWithTag:RECURRING_FORM_TAG]).isOn];
        
        if (reminderInfo) {
            currentMO.periodicity = reminderInfo.periodicity;
            currentMO.endDate = reminderInfo.endDateTime;
        }
        
        // create notifications
        [ActionManager scheduleNotificationWithFireDate:nil transfer:currentMO];
        
        // user
        ((MOIncome*)currentMO).user = [MOUser instance];
        [[MOUser instance].incomes addObject:currentMO];
        
        // add recurring
        [ActionManager addRecurringsBySelectedDate:nil transfer:currentMO];
    } else {
        // amount
        BOOL isDone = NO;
        double difference = 0;
        NSArray* recurrings = [CoreDataManager sortSet:((MOIncome*)currentMO).recurrings byProperty:SORT_BY_DATE_TIME ascending:YES];
        for (MORecurrence* recurrence in recurrings) {
            if ([[MyBudgetHelper dayFromDate:recurrence.dateTime] compare:[MyBudgetHelper dayFromDate:selectedDate]] == NSOrderedSame) {
                difference = [amount doubleValue] - [recurrence.amount doubleValue];
                recurrence.amount = amount;
                isDone = [recurrence.isDone boolValue];
                break;
            }
        }
        
        // account's amount
        if (isDone) {
            ((MOIncome*)currentMO).account.amount = [NSNumber numberWithDouble:([((MOIncome*)currentMO).account.amount doubleValue] + difference)];
        }
    }
    
    // Save data
    [[CoreDataManager instance] saveContext];

    // add in list
    if ([delegate respondsToSelector:@selector(didSavedTransfer:)]) {
        if (transferViewModeType == kTransferViewModeAdding) {
            [delegate didSavedTransfer:currentMO];
        } else {
            [delegate didSavedTransfer:nil];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editTransfer {
    isInEditMode = YES;
    [self updatePage];
}

-(void)editSaveTransfer {
    if (isInEditMode) {
        [self saveTransfer];
    } else {
        [self editTransfer];
    }
}

@end
