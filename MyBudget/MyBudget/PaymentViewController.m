 /**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 2/13/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "PaymentViewController.h"
#import "CategoriesListViewController.h"
#import "MapViewController.h"
#import "Constants.h"
#import "DatePickerViewController.h"
#import "Constants.h"
#import "UserInfo.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import "MOPayment.h"
#import "MORecurrence.h"
#import "DataPickerViewController.h"
#import "MOCategory.h"
#import "LocationInfo.h"
#import "MyBudgetHelper.h"
#import "ActionManager.h"

#import <QuartzCore/QuartzCore.h>

/// The tag for reminder button
#define REMINDER_BUTTON_TAG             693

/// The tag for reminder label
#define REMINDER_TRANSFER_LABEL_TAG     694

/// name alert view tag
#define ALERT_VIEW_NAME_TAG             400

/// The tag for location label
#define LOCATION_TRANSFER_LABEL_TAG         150

/// The tag for category label
#define CATEGORY_TRANSFER_LABEL_TAG         160

@implementation PaymentViewController

- (id)initWithTransfer:(id)payment isOpenedFromCalendar:(BOOL)isFromCalendar
{
    self = [super initWithTransfer:payment];
    if (self) {
        if (currentMO) {
            locationInfo = [[LocationInfo locationInfoFromData:currentMO.location] retain];
        }
        if (((MOPayment*)currentMO).fireDate) {
            reminderInfo = [[ReminderInfo alloc] init];
            reminderInfo.periodicity = currentMO.periodicity;
            reminderInfo.endDateTime = currentMO.endDate;
        }

        initialDate = nil;
        selectedDate = [[NSDate alloc] init];
        
        isOpenedFromCalendar = isFromCalendar;
         
        scrollingUpHeight = 440;
        scrollingDownHeight = 220;
    }
    return self;
}

-(void) changeSwitchState:(UISwitch *) switcher {
    [self createPeriodFormWithRecurring:switcher.isOn withPeriodicity:currentMO.periodicity withEndDate:currentMO.endDate];
}

-(void)createRecurringForm {
    [self createRecurringFormWithRecurring:[currentMO.isRecurring boolValue]];
}

-(void) createReminderForm {
    [self createFieldTitleWithOriginY:(originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW) withString:NSLocalizedString(@"Remind At", nil) tag:REMINDER_TRANSFER_LABEL_TAG];
    
    UIButton* reminderButton = (UIButton*)[transferScrollView viewWithTag:REMINDER_BUTTON_TAG];
    if (!reminderButton) {
        reminderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        reminderButton.layer.cornerRadius = 5.0f;
        UIImage* image = [MyBudgetHelper imageWithColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]]];
        [reminderButton setBackgroundImage:image forState:UIControlStateNormal];
        reminderButton.clipsToBounds = YES;
        reminderButton.frame = CGRectMake(originX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW, originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW, 160, 30);
        reminderButton.tag  = REMINDER_BUTTON_TAG;
        reminderButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [reminderButton addTarget:self action:@selector(openReminderDatePickerView) forControlEvents:UIControlEventTouchUpInside];
        [transferScrollView addSubview:reminderButton];
    }
    if (!((MOPayment*)currentMO).fireDate) {
        [reminderButton setTitle:NSLocalizedString(@"Select Reminder Time", nil) forState:UIControlStateNormal];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:DATE_FORMAT_STYLE_WITH_TIME];
        [reminderButton  setTitle:[formatter stringFromDate:((MOPayment*)currentMO).fireDate] forState:UIControlStateNormal];
        [formatter release];
    }
    
    [reminderButton setEnabled:[self isEnabled]];
    
    originY = reminderButton.frame.origin.y + reminderButton.frame.size.height;
}

/// creates pay bar button
-(void) createPayBarButton {
    UIBarButtonItem* payBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Pay", nil) style:UIBarButtonItemStyleDone target:self action:@selector(makePayment)];
    self.navigationItem.rightBarButtonItem = payBarButtonItem;
    [payBarButtonItem release];
}

-(void)createLocationButton {
    [self createFieldTitleWithOriginY:(originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW) withString:NSLocalizedString(@"Location", nil) tag:LOCATION_TRANSFER_LABEL_TAG];
    
    UIButton* locationButton = (UIButton*)[transferScrollView viewWithTag:LOCATION_BUTTON_TAG];
    if (!locationButton) {
        locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        locationButton.layer.cornerRadius = 5.0f;
        UIImage* image = [MyBudgetHelper imageWithColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]]];
        [locationButton setBackgroundImage:image forState:UIControlStateNormal];
        locationButton.clipsToBounds = YES;
        locationButton.frame = CGRectMake(originX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW, originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW, 160, 30);
        locationButton.tag = LOCATION_BUTTON_TAG;
        locationButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [locationButton addTarget:self action:@selector(openMapView) forControlEvents:UIControlEventTouchUpInside];
        [transferScrollView addSubview:locationButton];
    }
    if (![LocationInfo dataAddress:currentMO.location]) {
        [locationButton setTitle:NSLocalizedString(@"Select location", nil) forState:UIControlStateNormal];
    } else {
        [locationButton setTitle:[LocationInfo dataAddress:currentMO.location] forState:UIControlStateNormal];
    }
    
    if (transferViewModeType == kTransferViewModeUpdating) {
        [locationButton setEnabled:isInEditMode];
    }
    
    originY = locationButton.frame.origin.y + locationButton.frame.size.height;
}

-(void)createCategoryButton { 
    [self createFieldTitleWithOriginY:(originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW) 
                           withString:NSLocalizedString(@"Category", nil) 
                                  tag:CATEGORY_TRANSFER_LABEL_TAG];
    
    UIButton* categoryButton = (UIButton*)[transferScrollView viewWithTag:CATEGORY_BUTTON_TAG];
    if (!categoryButton) {
        categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        categoryButton.layer.cornerRadius = 5.0f;
        UIImage* image = [MyBudgetHelper imageWithColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]]];
        [categoryButton setBackgroundImage:image forState:UIControlStateNormal];
        categoryButton.clipsToBounds = YES;
        categoryButton.frame = CGRectMake(originX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW, originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW, 160, 30);
        categoryButton.tag  = CATEGORY_BUTTON_TAG;
        categoryButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [categoryButton addTarget:self action:@selector(openCategoryView) forControlEvents:UIControlEventTouchUpInside];
        [transferScrollView addSubview:categoryButton];
    }
    if (!currentMO) {
        [categoryButton setTitle:NSLocalizedString(@"Select category", nil) forState:UIControlStateNormal];
    } else {
        category = [((MOPayment*)currentMO).category retain];
        [categoryButton setTitle:[NSString stringWithFormat:@"%@/%@", category.parentCategory.name, category.name] forState:UIControlStateNormal];
    }
    
    [categoryButton setEnabled:[self isEnabled]];
    
    originY = categoryButton.frame.origin.y +  categoryButton.frame.size.height;
}

-(void) openDataPickerView {
    [self openDataPickerViewWithPeriodicity:reminderInfo.periodicity withEndDate:reminderInfo.endDateTime withStartDate:initialDate ? initialDate : [NSDate date]];
}

-(void)openReminderDatePickerView {
    [self resignTextFields];
    
    isDateSelected = NO;
    DatePickerViewController *datePickerViewController = [[DatePickerViewController alloc] initWithDate:((MOPayment*)currentMO).fireDate withEndDate:reminderInfo.endDateTime andMode:UIDatePickerModeDateAndTime];
    datePickerViewController.delegate = self;
    datePickerViewController.title = NSLocalizedString(@"Remind At", nil);
    [self.navigationController pushViewController:datePickerViewController animated:YES];
    [datePickerViewController release];
}

-(void)openDatePickerView {
    [self resignTextFields];
    
    isDateSelected = YES;
    DatePickerViewController *datePickerViewController;
    if (initialDate) {
        datePickerViewController = [[DatePickerViewController alloc] initWithDate:initialDate withEndDate:reminderInfo.endDateTime andMode:UIDatePickerModeDate];
    } else {
        datePickerViewController = [[DatePickerViewController alloc] initWithDate:currentMO.dateTime withEndDate:reminderInfo.endDateTime andMode:UIDatePickerModeDate];
    }
    datePickerViewController.delegate = self;
    datePickerViewController.title = NSLocalizedString(@"Date", nil);
    [self.navigationController pushViewController:datePickerViewController animated:YES];
    [datePickerViewController release];
}

/// the target method, which calls at selecting category button
-(void)openCategoryView {
    [self resignTextFields];
    
    CategoriesListViewController* categoryViewController =  [[CategoriesListViewController alloc] initWithStyle:UITableViewStylePlain withCategory:category withClickedCategory:nil];
    categoryViewController.title = NSLocalizedString(@"Categories", nil);
    categoryViewController.delegate =  self;
    [self.navigationController pushViewController:categoryViewController animated:YES];
    [categoryViewController release];
}

-(void)openMapView {
    [self resignTextFields];
    
    MapViewController* mapViewController = [[MapViewController alloc] initWithLocationInfo:[LocationInfo locationInfoFromData:currentMO.location]];
    mapViewController.delegate = self;
    mapViewController.view.frame = self.view.frame;
    [self.navigationController pushViewController:mapViewController animated:YES];
    [mapViewController release];
}

-(void)updatePage {
    MORecurrence* recurrence = nil;
    if (isOpenedFromCalendar) {
        recurrence = [MyBudgetHelper recurrenceByDate:selectedDate transfer:currentMO withFormatter:DATE_FORMAT_STYLE];
    } else {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"MM yyyy"];
        
        NSString* dateString = [formatter stringFromDate:selectedDate];
        
        NSArray* recurrings = [CoreDataManager sortSet:((MOPayment*)currentMO).recurrings byProperty:SORT_BY_DATE_TIME ascending:YES];
        for (MORecurrence* r in recurrings) {
            if ([[formatter stringFromDate:r.dateTime] isEqualToString:dateString]) {
                recurrence = r;
                selectedDate = [recurrence.dateTime retain];
                break;
            }
        }
    }
    
    if(recurrence && ![recurrence.isDone boolValue]){
        [self createPayBarButton];
    } else {
        [self createEditSaveBarButton:@selector(editSaveTransfer)];
    }
    
    if (initialDate) {
        NSAssert([currentMO.amount doubleValue] < 0, @"The payment amount should be always negative");
        [self createMainFieldsForm:[NSNumber numberWithDouble:[currentMO.amount doubleValue] * (-1)] name:currentMO.name notes:currentMO.moDescription date:initialDate dateName:NSLocalizedString(@"Start Date", nil) accountName:((MOPayment*)currentMO).account.name];
    } else {
        NSNumber* recurrenceAmount = nil;
        if (recurrence) {
            NSAssert([recurrence.amount doubleValue] < 0, @"The payment amount should be always negative");
            recurrenceAmount = [NSNumber numberWithDouble:[recurrence.amount doubleValue] * (-1)];
        }
        [self createMainFieldsForm:recurrenceAmount name:currentMO.name notes:currentMO.moDescription date:recurrence.dateTime dateName:NSLocalizedString(@"Start Date", nil) accountName:((MOPayment*)currentMO).account.name];
    }
    [self createCategoryButton];

    [self createLocationButton];
    
    [self createReminderForm];
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


#pragma mark - the target methods

-(void)datePickerControllerDidSave:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (date) {
        if (isDateSelected) {
            [formatter setDateFormat:DATE_FORMAT_STYLE];
            self.initialDate = date;
            UIButton *button = (UIButton *)[self.view viewWithTag:DATE_BUTTON_TAG];
            [button setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
            
            if ([reminderInfo.endDateTime compare:date] == NSOrderedAscending) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:DATE_FORMAT_STYLE];
                NSString *stringFromDate = [dateFormatter stringFromDate:date];
                reminderInfo.endDateTime = [dateFormatter dateFromString:stringFromDate];
                
                [dateFormatter setDateFormat:DATE_FORMAT_STYLE];
                
                 button = (UIButton *)[transferScrollView viewWithTag:REPEAT_BUTTON_TAG];
                [button setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@, till %@", nil), reminderInfo.periodicity,[dateFormatter stringFromDate:reminderInfo.endDateTime]] forState:UIControlStateNormal];
                [dateFormatter release];
            }
        } else {
            [formatter setDateFormat:DATE_FORMAT_STYLE_WITH_TIME];
            UIButton *button = (UIButton *)[self.view viewWithTag:REMINDER_BUTTON_TAG];
            [button setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
        }
    } else {
        UIButton *button = (UIButton *)[self.view viewWithTag:REMINDER_BUTTON_TAG];
        [button setTitle:NSLocalizedString(@"Select Reminder Time", nil) forState:UIControlStateNormal];
    }
    [formatter release];
}


-(void) didSelectCategory:(MOCategory *)_category {    
    didCategorySelected = YES;
    UIButton*  categoryButton = (UIButton*)[self.view  viewWithTag:CATEGORY_BUTTON_TAG];
    [categoryButton setTitle:[NSString stringWithFormat:@"%@/%@", _category.parentCategory.name, _category.name] forState:UIControlStateNormal];
    if (category) {
        [category release];
    }
    category =  [_category retain];
}

-(void)didSelectLocation:(LocationInfo*)info {
    
    if (locationInfo) {
        [locationInfo release];
        locationInfo = nil;
    }
    
    locationInfo = [info retain];    
    UIButton*  locationButton = (UIButton*)[self.view  viewWithTag:LOCATION_BUTTON_TAG];
    [locationButton setTitle:[locationInfo address] forState:UIControlStateNormal];
}

/// the target method, which calls at saving added/changed payment
-(void)saveTransfer {  
    // Check for errors
    UITextField* amountTextField = (UITextField *)[transferScrollView viewWithTag:AMOUNT_TEXT_FIELD_TAG];
    if([amountTextField.text length] == 0){
        [self showMessageAlert:NSLocalizedString(@"Please fill in amount field", nil)];
        return;
    }
    
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * amount = [numberFormatter numberFromString:amountTextField.text];
    [numberFormatter release];
    
    if([amount doubleValue] == 0){
        [self showMessageAlert:[NSString stringWithFormat:NSLocalizedString(@"You can't create %@ with 0 %@ amount. Please correct it", nil), NSLocalizedString(@"payment", nil), [MOUser instance].setting.currency]];
        return;
    }
    
    UITextField* nameTextField = (UITextField *)[transferScrollView viewWithTag:NAME_TEXT_FIELD_TAG];
    NSString* name = [MyBudgetHelper trimString:nameTextField.text];
    if([name length] == 0){
        [self showMessageAlert:NSLocalizedString(@"Please fill in name field", nil)];
        return;
    }
    
    if (transferViewModeType == kTransferViewModeAdding) {
        if(!((MOPayment*)currentMO).account && !didAccountSelected) {
            [self showMessageAlert:NSLocalizedString(@"Please select account", nil)];
            return;
        }
        
        if(!((MOPayment*)currentMO).category && !didCategorySelected) {
            [self showMessageAlert:NSLocalizedString(@"Please select category", nil)];
            return;
        }
        
        BOOL isRecurringChecked = ((UISwitch *)[transferScrollView viewWithTag:RECURRING_FORM_TAG]).isOn;
        if (isRecurringChecked && !reminderInfo) {
            [self showMessageAlert:NSLocalizedString(@"Please select recurring periodicity and end date.", nil)];
            return;
        }
    }
    
    if ([[CoreDataManager instance] isInSet:[MOUser instance].payments nameBusy:name] && ![currentMO.name isEqualToString:name] && isNameBusy) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"The name is already used.\nDo you still want to use it?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"NO", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
        alertView.tag = ALERT_VIEW_NAME_TAG;
        [alertView show];
        [alertView release];
        return;
    }
    
    // All right, can save
    if (!currentMO) {
        currentMO = [[CoreDataManager instance] payment];
    }
    
    // name
    currentMO.name = name;
    
    // note
    UITextView* notes = (UITextView *)[transferScrollView viewWithTag:NOTES_TEXT_VIEW_TAG];
    currentMO.moDescription = notes.text;
    
    // location
    if (locationInfo) {
        currentMO.location = [LocationInfo dataFromLocationInfo:locationInfo];
    }
    
    if (transferViewModeType == kTransferViewModeAdding) {
        // amount
        currentMO.amount = [NSNumber numberWithDouble:[amount doubleValue] * (-1)];
        NSAssert([currentMO.amount doubleValue] < 0, @"The payment amount should be always negative");

        
        // account
        if (curAccount) {
            ((MOPayment*)currentMO).account = curAccount;
        }
        
        // category
        if (category) {
            ((MOPayment*)currentMO).category = category;
        }
        
        // date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:DATE_FORMAT_STYLE];
        UIButton* date = (UIButton *)[self.view viewWithTag:DATE_BUTTON_TAG];
        currentMO.dateTime = [formatter dateFromString:date.titleLabel.text];
        
        // fire date
        [formatter setDateFormat:DATE_FORMAT_STYLE_WITH_TIME];
        date = (UIButton *) [self.view viewWithTag:REMINDER_BUTTON_TAG];
        ((MOPayment*)currentMO).fireDate = [formatter dateFromString:date.titleLabel.text];
        [formatter release];
        
        // recurring
        currentMO.isRecurring = [NSNumber numberWithBool:((UISwitch *)[transferScrollView viewWithTag:RECURRING_FORM_TAG]).isOn];
        
        if (reminderInfo) {
            currentMO.periodicity = reminderInfo.periodicity;
            currentMO.endDate = reminderInfo.endDateTime;
        }
        
        // create notifications
        [ActionManager scheduleNotificationWithFireDate:((MOPayment*)currentMO).fireDate transfer:currentMO];
        
        // user
        ((MOPayment*)currentMO).user = [MOUser instance];
        [[MOUser instance].payments addObject:currentMO];
        
        // add recurring
        [ActionManager addRecurringsBySelectedDate:((MOPayment*)currentMO).fireDate transfer:currentMO];
    } else {
        // amount
        BOOL isDone = NO;
        double difference = 0;
        NSArray* recurrings = [CoreDataManager sortSet:((MOPayment*)currentMO).recurrings byProperty:SORT_BY_DATE_TIME ascending:YES];
        for (MORecurrence* recurrence in recurrings) {
            if ([[MyBudgetHelper dayFromDate:recurrence.dateTime] compare:[MyBudgetHelper dayFromDate:selectedDate]] == NSOrderedSame) {
                difference = [amount doubleValue] - [recurrence.amount doubleValue];
                recurrence.amount = [NSNumber numberWithDouble:[amount doubleValue] * (-1)];
                isDone = [recurrence.isDone boolValue];
                break;
            }
        }
        
        // account's amount
        if (isDone) {
            ((MOPayment*)currentMO).account.amount = [NSNumber numberWithDouble:([((MOPayment*)currentMO).account.amount doubleValue] - difference)];
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

-(void)makePayment {
    [ActionManager addToAccount:currentMO selectedDate:selectedDate];      
    if (isOpenedFromCalendar) {
        [self createEditSaveBarButton:@selector(editSaveTransfer)];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) dealloc {
    [initialDate release];
    [selectedDate release];
    [currentMO release];
    [category release];
    [locationInfo release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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

@end
