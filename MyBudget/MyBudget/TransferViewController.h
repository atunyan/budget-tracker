/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 1/13/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "MapViewController.h"
#import "AccountsListTableViewController.h"
#import "DataPickerViewController.h"
#import "MOAccount.h"
#import "MORecurrence.h"
#import "TransferProtocols.h"

/// @brief the vertical difference between view fields
#define VERTICAL_DIFFERENCE_BETWEEN_VIEW 20.0f

/// @brief the horizontal difference between view fields
#define HORIZONTAL_DIFFERENCE_BETWEEN_VIEW 10.0f

/// the tag for currency label
#define CURRENCY_LABEL_TAG      43

/// The tag for amount text field
#define AMOUNT_TEXT_FIELD_TAG   144

/// The tag for amount label
#define AMOUNT_TRANSFER_LABEL_TAG   45

/// The tag for name text field
#define NAME_TEXT_FIELD_TAG         54

/// The tag for name label
#define NAME_TRANSFER_LABEL_TAG     55

/// The tag for notes text view
#define NOTES_TEXT_VIEW_TAG 166

/// The tag for date button tag
#define DATE_BUTTON_TAG 1000

/// The tag for recurring switch
#define RECURRING_FORM_TAG 91

/// The tag for repeat button
#define REPEAT_BUTTON_TAG 92

/// The tag for repeat button
#define REPEAT_TITLELABEL_TAG 94

/// The tag for delete button
#define DELETE_BUTTON_TAG 96

/// the account type selection button tag
#define ACCOUNT_TYPE_TEXT_FIELD_TAG 134

/// the account type label tag
#define ACCOUNT_TYPES_LABEL_TAG      135

/// Indicates transfer view mode type
typedef enum {
    /// "adding" mode
    kTransferViewModeAdding,
    
    /// "updating" mode
    kTransferViewModeUpdating
} TransferViewModeType;

@class ReminderInfo;
@class MOTransfer;

/**
 * @brief TransferViewController class. This class is responsible for 
 * creating/adding the main fields of payment/income. After creating new
 * income/payment, it is displayed on @ref
 * PaymentsListViewController and  @ref IncomesListTableViewController. 
 */

@interface TransferViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UITextViewDelegate, UIActionSheetDelegate, DatePickerViewControllerDelegate, LocationControllerDelegate, DataPickerViewControllerDelegate,AccountsListTableViewControllerDelegate> {
    
    /// The current managed object to be displayed in the view controller.
    MOTransfer* currentMO;
    
    /// The x coordinate for the field's title
    CGFloat originX;
    
    /// The y coordinate for the field's title
    CGFloat originY;
    
    /// The transfer view main scroll view
    UIScrollView* transferScrollView;
    
    /// scrolling up height, when user clicks in text field or text view
    int scrollingUpHeight;
    
    /// scrolling down height for long scroll view
    int scrollingDownHeight;
    
    /// temporary reminder info
    ReminderInfo* reminderInfo;
    
    /// the current account object
    MOAccount* curAccount;
    
    /// the BOOL value, indicates did account selected
    BOOL didAccountSelected;
    
    id<TransferViewControllerDelegate> delegate;
    
    NSDate* initialDate;
    
    NSDate* selectedDate;
    
    BOOL isInEditMode;
    
    TransferViewModeType transferViewModeType;
    
    /// indicates is view opened from calendar view or from list view
    BOOL isOpenedFromCalendar;
    
    /// indicates is new created objetc's name already busy
    BOOL isNameBusy;
    
    /// the current selected textfield
    UITextField* currentTextField;
    
    /// the current text view
    UITextView* currentTextView;
}

/// The delegate of @ref TransferViewControllerDelegate protocol
@property (nonatomic, assign) id<TransferViewControllerDelegate> delegate;

/// Initial date for the case of selection date in calendar view.
@property (nonatomic, retain) NSDate* initialDate;

/// Selected date for the case of selection date in list view.
@property (nonatomic, retain) NSDate* selectedDate;

/// transfer view mode type
@property (nonatomic, assign) TransferViewModeType transferViewModeType;

/// transfer view editing mode
@property (nonatomic, assign) BOOL isInEditMode;

/**
 * @brief Initializes the class properties with the predifined values.
 * @param payment - The member of the transfer, may be also nil.
 * @return - Initialized the class object.
 */
- (id)initWithTransfer:(id)payment;

/**
 * @brief Creates the main fields of the @ref IncomesListTableViewController 
 * and @ref PaymentsListViewController views.
 */
-(void)createMainFieldsForm:(NSNumber *) amount
                       name:(NSString *) name
                      notes:(NSString *) notes
                      date :(NSDate *) date 
                   dateName: (NSString *) dateName 
                accountName:(NSString*)accountName;

/**
 * @brief Creates the current field title in respondance to the given Y coordinate.
 * @param frameOriginY - the y coordinate
 * @param titleString - the string of the current field.
 * @param tag - the tag for the title label
 */
-(void)createFieldTitleWithOriginY:(CGFloat)frameOriginY 
                        withString:(NSString *)titleString
                               tag:(NSInteger) tag;


/**
 * @brief Creates the save bar button.
 * @param selector - the action which should be done when save button is pressed.
 */
-(void) createEditSaveBarButton:(SEL) selector;

/**
 * @brief Showing warning messages, if requiared field not filled
 * @param message - the warning message
 */
-(void)showMessageAlert:(NSString*)message ;

/**
 * @brief  Creates recurring switch
 * @param isRecurringOn - indicates is switch on or off
 */
-(void)createRecurringFormWithRecurring:(BOOL)isRecurringOn;

/**
 * @brief  Creates period view by specified periodicity and end date
 * @param isRecurringOn - indicates is periodicity view must be shown or not
 * @param periodicity - periodicity
 * @param endDate - end date
 */
-(void) createPeriodFormWithRecurring:(BOOL)isRecurringOn withPeriodicity:(NSString*)periodicity withEndDate:(NSDate*)endDate;

/// creates delete button for transfer
-(void)createDeleteButton;

/**
 * @brief  Opens data picker view for selecting periodicity and end date
 * @param periodicity - periodicity
 * @param endDate - end date
 * @param startDate - for validation comparing with end date
 */
-(void) openDataPickerViewWithPeriodicity:(NSString*)periodicity withEndDate:(NSDate*)endDate withStartDate:(NSDate*)startDate;

/// @brief creates account type text field
-(void)createAccountTypeField;

/// @return - Is transfer view in add or update mode
-(BOOL)isEnabled;

/// saves transfer object
-(void)saveTransfer;

/// resignes all text fields
-(void)resignTextFields;

@end
