/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 1/13/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "TransferViewController.h"
#import "AccountsListTableViewController.h"
#import "MapViewController.h"
#import "Constants.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import "MOPayment.h"
#import "MOIncome.h"
#import "DataPickerViewController.h"
#import "ReminderInfo.h"
#import "MyBudgetHelper.h"
#import "MOTransfer.h"
#import "MORecurrence.h"
#import "ActionManager.h"

#import <QuartzCore/QuartzCore.h>

/// The scroll view content size increment coeficent , when textFiled/textView become changed
#define SCROLL_VIEW_CONTENT_SIZE_INCRETEMENT_VALUE 266 /// 216 + 50 (keyboard height + iAd banner height)

/// The select account button tag
#define ACCOUNT_BUTTON_TAG 267

/// The tag for account label
#define ACCOUNT_TRANSFER_LABEL_TAg      268

/// The tag for note label
#define NOTE_TRANSFER_LABEL_TAG         300

/// The tag for recurring label
#define RECURRING_TRANSFER_LABEL_TAG    310

/// name alert view tag
#define ALERT_VIEW_NAME_TAG         400

/// name action sheet tag
#define ACTION_SHEET_NAME_TAG1         1000

/// name action sheet tag
#define ACTION_SHEET_NAME_TAG2         1001

@implementation TransferViewController

@synthesize delegate;
@synthesize initialDate;
@synthesize selectedDate;
@synthesize transferViewModeType;
@synthesize isInEditMode;

- (id)initWithTransfer:(id)payment
{
    self = [super init];
    if (self) {
        // Custom initialization
        scrollingUpHeight = SCROLL_VIEW_CONTENT_SIZE_INCRETEMENT_VALUE;
        scrollingDownHeight = 0;
        
        currentMO = [payment retain];
        if (currentMO) {
            isInEditMode = NO;
            transferViewModeType = kTransferViewModeUpdating;
        } else {
            isInEditMode = YES;
            transferViewModeType = kTransferViewModeAdding;
        }
        
        isNameBusy = YES;
    }
    return self;
}

-(void)dealloc {
    [curAccount release];
    [transferScrollView release];
    [reminderInfo release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL)isEnabled {
    if (transferViewModeType == kTransferViewModeAdding) {
        return YES;
    }
    return NO;
}

#pragma mark - View lifecycle

-(void)createFieldTitleWithOriginY:(CGFloat)frameOriginY 
                        withString:(NSString *)titleString 
                               tag:(NSInteger)tag {
    UILabel* titleLabel = (UILabel*)[transferScrollView viewWithTag:tag];
    if (!titleLabel) {
        titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, frameOriginY, 120, 30)] autorelease];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.tag = tag;
        titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor blackColor];
        [transferScrollView addSubview:titleLabel];
    }
    titleLabel.text = titleString;
    
    originX = titleLabel.frame.origin.x + titleLabel.frame.size.width;
}

/**
 * @brief the method creates text field for filling in the amount' value.
 * @param text - the predifined value for amount, may be also nil.
 */
-(void)createTextField:(NSString *)text textFieldTag:(NSInteger)textFieldTag 
verticalOffset:(NSInteger)verticalOffset fieldName:(NSString *)fieldName labelTag:(NSInteger)labelTag{
    
    [self createFieldTitleWithOriginY:verticalOffset withString:fieldName tag:labelTag];
    
    UITextField* textField = (UITextField*)[transferScrollView viewWithTag:textFieldTag];
    if (!textField) {
        textField = [[[UITextField alloc] initWithFrame:CGRectMake(originX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW, verticalOffset , 160, 30)] autorelease];
        textField.delegate = self;
        textField.keyboardType = (textFieldTag == AMOUNT_TEXT_FIELD_TAG) ? UIKeyboardTypeDecimalPad : UIKeyboardTypeDefault;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = [UIFont boldSystemFontOfSize:14.0f];
        textField.tag = textFieldTag;
        [transferScrollView addSubview:textField];
    }
    textField.text = text;
    
    if(textField.tag == AMOUNT_TEXT_FIELD_TAG){
        UILabel* currencyLabel = (UILabel*)[transferScrollView viewWithTag:CURRENCY_LABEL_TAG];
        if (!currencyLabel) {
            currencyLabel = [[[UILabel alloc] initWithFrame:CGRectMake(textField.frame.origin.x + textField.frame.size.width - 30, textField.frame.origin.y, 30, textField.frame.size.height)] autorelease];
            currencyLabel.backgroundColor = [UIColor clearColor];
            currencyLabel.font = [UIFont systemFontOfSize:12];
            currencyLabel.textAlignment = UITextAlignmentLeft;
            [transferScrollView addSubview:currencyLabel];
        }
        currencyLabel.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
        currencyLabel.text = [MOUser instance].setting.currency;
    }
    if (transferViewModeType == kTransferViewModeUpdating) {
        [textField setEnabled:isInEditMode];
    }
    originY = textField.frame.origin.y + textField.frame.size.height;
}

/**
 * @brief This method calls at creating date button
 * @param date - the predifined value for date, may be also nil.
 * @param dateName - the name of date field
 */
-(void)createDateButton:(NSDate *) date dateName :(NSString *) dateName {
    [self createFieldTitleWithOriginY:(originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW) withString:dateName tag:34];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:DATE_FORMAT_STYLE];
    
    UIButton* dateButton = (UIButton*)[transferScrollView viewWithTag:DATE_BUTTON_TAG];
    if (!dateButton) {
        dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [dateButton addTarget:self action:@selector(openDatePickerView) forControlEvents:UIControlEventTouchUpInside];
        dateButton.tag = DATE_BUTTON_TAG;
        dateButton.frame = CGRectMake(originX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW, (originY +  VERTICAL_DIFFERENCE_BETWEEN_VIEW), 160, 30);
        
        UIImage* image = [MyBudgetHelper imageWithColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]]];
        [dateButton setBackgroundImage:image forState:UIControlStateNormal];
        dateButton.clipsToBounds = YES;
        dateButton.layer.cornerRadius = 5;
        [dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        dateButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [transferScrollView addSubview:dateButton];
    }
    if (!date) {
        [dateButton setTitle:[formatter  stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    } else {
        [dateButton setTitle:[formatter  stringFromDate:date] forState:UIControlStateNormal];
    }
    [dateButton setEnabled:[self isEnabled]];
    
    originY = dateButton.frame.origin.y +  dateButton.frame.size.height;
}

/**
 * @brief the method creates text view for filling in the notes' value.
 * @param text - the predifined value for notes, may be also nil.
 */
-(void)createNoteTextView:(NSString *) text {
    [self createFieldTitleWithOriginY:(originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW) withString:NSLocalizedString(@"Notes", nil) tag:NOTE_TRANSFER_LABEL_TAG];
    
    UITextView* notesTextView = (UITextView*)[transferScrollView viewWithTag:NOTES_TEXT_VIEW_TAG];
    if (!notesTextView) {
        notesTextView = [[[UITextView alloc] initWithFrame:CGRectMake(originX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW, originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW, 160, 90)] autorelease];
        notesTextView.delegate = self;
        notesTextView.layer.cornerRadius = 5.0f;
        notesTextView.layer.borderWidth = 1.0f;
        notesTextView.font = [UIFont systemFontOfSize:12.0f];
        notesTextView.tag = NOTES_TEXT_VIEW_TAG;
        [transferScrollView addSubview:notesTextView];
    }
    notesTextView.layer.borderColor = [[NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]] CGColor];
    notesTextView.text = text;
    if (transferViewModeType == kTransferViewModeUpdating) {
        [notesTextView setEditable:isInEditMode];
    }

    originY = notesTextView.frame.origin.y +  notesTextView.frame.size.height;
}

-(void)createAccountButton:(NSString*)text {
    [self createFieldTitleWithOriginY:(originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW) withString:NSLocalizedString(@"Аccount", nil) tag:ACCOUNT_TRANSFER_LABEL_TAg];
    
    UIButton* accountBtn = (UIButton*)[transferScrollView viewWithTag:ACCOUNT_BUTTON_TAG];
    if (!accountBtn) {
        accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        accountBtn.frame = CGRectMake(originX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW, (originY +  VERTICAL_DIFFERENCE_BETWEEN_VIEW), 160, 30);
        accountBtn.tag = ACCOUNT_BUTTON_TAG;
        
        UIImage* image = [MyBudgetHelper imageWithColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]]];
        [accountBtn setBackgroundImage:image forState:UIControlStateNormal];
        accountBtn.clipsToBounds = YES;
        accountBtn.layer.cornerRadius = 5.0f;
        accountBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [accountBtn addTarget:self action:@selector(selectAccount) forControlEvents:UIControlEventTouchUpInside];
        [transferScrollView addSubview:accountBtn];
    }
    [accountBtn setTitle:(!text) ? NSLocalizedString(@"Select Account", nil) : text forState:UIControlStateNormal];
    [accountBtn setEnabled:[self isEnabled]];
    
    originY = accountBtn.frame.origin.y +  accountBtn.frame.size.height;
}

-(void)createMainFieldsForm:(NSNumber *) amount
                       name:(NSString *) name
                      notes:(NSString *) notes
                      date :(NSDate *) date 
                   dateName: (NSString *) dateName 
                accountName:(NSString*)accountName {
    
    [self createTextField:(amount ? [NSString stringWithFormat:@"%.2f", [amount doubleValue]] : @"") textFieldTag:AMOUNT_TEXT_FIELD_TAG verticalOffset:20 fieldName:NSLocalizedString(@"Amount", nil) labelTag:AMOUNT_TRANSFER_LABEL_TAG];
    [self createTextField:name textFieldTag:NAME_TEXT_FIELD_TAG verticalOffset:60 fieldName:NSLocalizedString(@"Name", nil) labelTag:NAME_TRANSFER_LABEL_TAG];
    if(![dateName isEqualToString:@""]){
        [self createDateButton:date dateName:dateName];
    }
    if (![accountName isEqualToString:@""]) {
        [self createAccountButton:accountName];
    }
    [self createNoteTextView:notes];
}

-(void) createEditSaveBarButton:(SEL) selector {
    UIBarButtonItem *saveBarButtonItem;
    if (isInEditMode) {
        saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleDone target:self action:(SEL)selector];
    } else {
        saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStyleDone target:self action:(SEL)selector];
    }
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    [saveBarButtonItem release];
}

-(void)resignTextFields {
    [currentTextField resignFirstResponder];
    [currentTextView resignFirstResponder];
    [transferScrollView setContentSize:CGSizeMake(self.view.frame.size.width, TRANSFER_VIEW_HEIGHT + scrollingDownHeight)];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    transferScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transferScrollView.scrollEnabled = YES;
    transferScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:transferScrollView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)datePickerControllerDidSave:(NSDate *)date {
    NSAssert(false, @"Should be implemented in derived classes.");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - the target methods

-(void)openDatePickerView {
    NSAssert(false, @"Should be implemented in derived classes.");
}

-(void)selectAccount {
    [self resignTextFields];
    
    AccountsListTableViewController* accountListTableViewController = [[AccountsListTableViewController alloc] init];
    accountListTableViewController.isAccountSelected = YES;
    accountListTableViewController.delegate = self;
    [self.navigationController pushViewController:accountListTableViewController animated:YES];
    [accountListTableViewController release];
}

-(void)didSelectAccount:(MOAccount *)account {
    didAccountSelected = YES;
    UIButton* button = (UIButton*)[transferScrollView viewWithTag:ACCOUNT_BUTTON_TAG];
    [button setTitle:account.name forState:UIControlStateNormal];
    if (curAccount) {
        [curAccount release];
    }
    curAccount =  [account retain];
}

#pragma mark - delegate methods

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    currentTextView = textView;
    transferScrollView.contentSize = CGSizeMake(self.view.frame.size.width, TRANSFER_VIEW_HEIGHT + scrollingUpHeight);
    //svos = scrollView
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:transferScrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [transferScrollView setContentOffset:pt animated:YES]; 
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    currentTextField = textField;
    transferScrollView.contentSize = CGSizeMake(self.view.frame.size.width, TRANSFER_VIEW_HEIGHT + scrollingUpHeight);
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:transferScrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y = (textField.tag == ACCOUNT_TYPE_TEXT_FIELD_TAG) ? 80 : 0 ;
    [transferScrollView setContentOffset:pt animated:YES];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [transferScrollView setContentSize:CGSizeMake(self.view.frame.size.width, TRANSFER_VIEW_HEIGHT + scrollingDownHeight)];
    return YES;
}

-(void)showMessageAlert:(NSString*)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) 
                                                        message:message 
                                                       delegate:nil 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alertView show];
    [alertView release];
}

#pragma mark - UIAlertViewDelegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_VIEW_NAME_TAG:
            switch (buttonIndex) {
                case 0:
                    isNameBusy = YES;
                    break;
                case 1:
                    isNameBusy = NO;
                    [self saveTransfer];
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

-(void)saveTransfer {
    NSAssert(false, @"Should be implemented in derived classes.");
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString* currentText = [[[NSMutableString alloc] initWithString:textField.text] autorelease];
    
    if (range.length > 0) {
        [currentText replaceCharactersInRange:range withString:@""];
    } else {
        [currentText insertString:string atIndex:range.location];
    }
    
    // Set text fields max text length
    if (textField.tag == AMOUNT_TEXT_FIELD_TAG) {
        if ([currentText length] > 9 && range.length == 0) {
            return NO;
        }
        
        // if text empty
        if ([currentText isEqualToString:@""]) {
            return YES;
        }
        
        // if starts with "-"
        if ([currentText isEqualToString:@"-"]) {
            return YES;
        }
        
        // if not a number
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setDecimalSeparator:@"."];
        NSNumber * myNumber = [f numberFromString:currentText];
        if (myNumber == nil) {
            [f setDecimalSeparator:@","];
            myNumber = [f numberFromString:currentText];
        }
        [f release];
        
        if (!myNumber) {
            return NO;
        }
    } else {
        if ([currentText length] > 20) {
            return NO;
        }
    }
    
    return YES;
}

-(void) changeSwitchState:(UISwitch *) switcher {
    NSAssert(false, @"Should be implemented in derived classes.");
}

-(void)createRecurringFormWithRecurring:(BOOL)isRecurringOn {
    [self createFieldTitleWithOriginY:(originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW) withString:NSLocalizedString(@"Recurring", nil) tag:RECURRING_TRANSFER_LABEL_TAG];
    
    UISwitch* switchView = (UISwitch *)[transferScrollView viewWithTag:RECURRING_FORM_TAG];
    if (!switchView) {
        switchView = [[[UISwitch alloc] initWithFrame: CGRectMake((transferScrollView.frame.size.width - 100), (originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW), 100, 30)] autorelease];
        switchView.tag = RECURRING_FORM_TAG;
        switchView.onTintColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
        [switchView addTarget:self action:@selector(changeSwitchState:) forControlEvents:UIControlEventValueChanged];
        [transferScrollView addSubview:switchView];
    }
    switchView.on = isRecurringOn;
    [switchView setEnabled:[self isEnabled]];
    
    originY = switchView.frame.origin.y + switchView.frame.size.height;
}

-(void) openDataPickerView {
    NSAssert(false, @"Should be implemented in derived classes.");
}

-(void) createPeriodFormWithRecurring:(BOOL)isRecurringOn withPeriodicity:(NSString*)periodicity withEndDate:(NSDate*)endDate {
    if (isRecurringOn) {
        UISwitch* switchView = (UISwitch *)[transferScrollView viewWithTag:RECURRING_FORM_TAG];
        originY = switchView.frame.origin.y + switchView.frame.size.height;
        [self createFieldTitleWithOriginY:(originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW)
                               withString:NSLocalizedString(@"Repeat", nil)
                                      tag:REPEAT_TITLELABEL_TAG];
        
        UIButton* repeatButton = (UIButton*)[transferScrollView viewWithTag:REPEAT_BUTTON_TAG];
        if (!repeatButton) {
            repeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
            repeatButton.frame = CGRectMake(originX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW, originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW, 160, 30);
            repeatButton.layer.cornerRadius = 5.0f;
            
            UIImage* image = [MyBudgetHelper imageWithColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]]];
            [repeatButton setBackgroundImage:image forState:UIControlStateNormal];
            repeatButton.clipsToBounds = YES;
            repeatButton.tag  = REPEAT_BUTTON_TAG;
            repeatButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [repeatButton addTarget:self action:@selector(openDataPickerView) forControlEvents:UIControlEventTouchUpInside];
            
            [transferScrollView addSubview:repeatButton];
        }
        if (!periodicity) {
            [repeatButton setTitle:NSLocalizedString(@"Please Select Periodicity", nil) forState:UIControlStateNormal];
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:DATE_FORMAT_STYLE];    
            NSString* endDateText = [formatter stringFromDate:endDate];
            [formatter release];            
            [repeatButton  setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@, till %@", nil), periodicity, endDateText] forState:UIControlStateNormal];
        }
        
        [repeatButton setEnabled:[self isEnabled]];
        
        originY = repeatButton.frame.origin.y + repeatButton.frame.size.height;
    } else {
        [[transferScrollView viewWithTag:REPEAT_BUTTON_TAG] removeFromSuperview];
        [[transferScrollView viewWithTag:REPEAT_TITLELABEL_TAG] removeFromSuperview];
    }
}

-(void)createDeleteButton {
    UIImage* image = [UIImage imageNamed:@"delete.png"];
    UIButton* deleteButton = (UIButton*)[transferScrollView viewWithTag:DELETE_BUTTON_TAG];
    if (!deleteButton) {
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.layer.cornerRadius = 5.0f;
        
        deleteButton.clipsToBounds = YES;
        deleteButton.tag  = DELETE_BUTTON_TAG;
        [deleteButton setBackgroundImage:image forState:UIControlStateNormal];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [deleteButton setTitle:NSLocalizedString(@"Delete", @"Delete") forState:UIControlStateNormal];
        deleteButton.titleLabel.textColor = [UIColor whiteColor];
        [deleteButton addTarget:self action:@selector(deleteTransfer) forControlEvents:UIControlEventTouchUpInside];
        
        [transferScrollView addSubview:deleteButton];
    }
    deleteButton.frame = CGRectMake(originX + 10, originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW, image.size.width - 40, image.size.height);
}

-(void)createAccountTypeField {
    UITextField* typeTextField = (UITextField*)[transferScrollView viewWithTag:ACCOUNT_TYPE_TEXT_FIELD_TAG];
    if (!typeTextField) {
        typeTextField = [[[UITextField alloc] initWithFrame:CGRectMake(originX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW, originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW, 160, 30)] autorelease];
        typeTextField.borderStyle = UITextBorderStyleRoundedRect;
        typeTextField.tag = ACCOUNT_TYPE_TEXT_FIELD_TAG;
        typeTextField.delegate = self;
        typeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        typeTextField.font = [UIFont systemFontOfSize:14.0f];
        [transferScrollView addSubview:typeTextField];
    }
    if (transferViewModeType == kTransferViewModeUpdating) {
        [typeTextField setEnabled:isInEditMode];
    }
    
    UILabel* typeSubtitleLabel = (UILabel*)[transferScrollView viewWithTag:ACCOUNT_TYPES_LABEL_TAG];
    if (!typeSubtitleLabel) {
        typeSubtitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(originX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW + 10, typeTextField.frame.origin.y + typeTextField.frame.size.height, 160, 20)] autorelease];
        typeSubtitleLabel.font = [UIFont systemFontOfSize:10.0f];
        typeSubtitleLabel.backgroundColor = [UIColor clearColor];
        typeSubtitleLabel.text  = NSLocalizedString(@"Savings, Credit, Cash, Visa, Debt, etc.", nil);
        typeSubtitleLabel.textColor = [UIColor lightGrayColor];
        typeSubtitleLabel.tag = ACCOUNT_TYPES_LABEL_TAG;
        [transferScrollView addSubview:typeSubtitleLabel];
    }
}

-(void) openDataPickerViewWithPeriodicity:(NSString*)periodicity withEndDate:(NSDate*)endDate withStartDate:(NSDate*)startDate {
    [self resignTextFields];
    
    DataPickerViewController *dataPickerViewController = [[DataPickerViewController alloc] initWithPeriodicity:periodicity andWithEndDate:endDate andWithStartDate:startDate];
    dataPickerViewController.delegate = (id)self;
    dataPickerViewController.title = NSLocalizedString(@"Repeat", nil);
    [self.navigationController pushViewController:dataPickerViewController animated:YES];
    [dataPickerViewController release];
}

#pragma mark - DataPickerViewControllerDelegate methods

-(void)didSavedWithPeriodicity:(NSString *)periodicity andWithEndDate:(NSDate *)endDate {
    if (reminderInfo) {
        [reminderInfo release];
        reminderInfo = nil;
    }
    reminderInfo = [[ReminderInfo alloc] init];
    reminderInfo.periodicity = periodicity;
    reminderInfo.endDateTime = endDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_STYLE];    
    NSString* endDateText = [formatter stringFromDate:endDate];
    [formatter release];
    
    UIButton *button = (UIButton *)[transferScrollView viewWithTag:REPEAT_BUTTON_TAG];
    [button setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@, till %@", nil), periodicity, endDateText] forState:UIControlStateNormal];
}

-(void)deleteTransfer {
    if ([ActionManager deleteTransfer:currentMO view:self.view.window delegate:self]) {
        // update list
        if ([delegate respondsToSelector:@selector(didDeletedTransfer)]) {
            [delegate didDeletedTransfer];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // update list
    if (actionSheet.tag == ACTION_SHEET_NAME_TAG1) {
        if ([ActionManager deleteRecurrencesOf:currentMO index :buttonIndex date :selectedDate]) {
            if ([delegate respondsToSelector:@selector(didDeletedTransfer)]) {
                [delegate didDeletedTransfer];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (actionSheet.tag == ACTION_SHEET_NAME_TAG2) {
        if (buttonIndex == 0) {
            [ActionManager deleteNonRecurringItem:currentMO];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end

