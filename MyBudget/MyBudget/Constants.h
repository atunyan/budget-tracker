/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#pragma mark - Core Data manager
#pragma mark - sorting


/// User entity name
#define ENTITY_USER             @"MOUser"

/// Income entity name
#define ENTITY_INCOME           @"MOIncome"

/// Category entity name
#define ENTITY_CATEGORY         @"MOCategory"

/// Payment entity name
#define ENTITY_BILL             @"MOPayment"

/// Setting entity name
#define ENTITY_SETTING          @"MOSetting"

/// Search Settings entity name
#define ENTITY_SEARCH_SETTINGS  @"MOSearchSettings"

/// Report entity name
#define ENTITY_REPORT           @"MOReport"

/// Account entity name
#define ENTITY_ACCOUNT          @"MOAccount"

/// Recurring entity name
#define ENTITY_RECURRING        @"MORecurrence"


/// For datTime sorting descriptor
#define SORT_BY_DATE_TIME               @"dateTime"

/// For name sorting descriptor
#define SORT_BY_NAME                    @"name"

/// For categoryID sorting descriptor
#define SORT_BY_CATEGORY_INDEX          @"categoryIndex"


/// Root Category Parent ID
#define ROOT_CATEGORY_PARENT_ID         0

/// The format of month
#define DATE_FORMAT_MONTH   @"MMMM yyyy"

/// The format of Date Picker
#define DATE_FORMAT_STYLE @"dd/MM/yyyy"

/// The format of Date Picker
#define DATE_FORMAT_STYLE_1 @"dd MMMM yyyy"

/// The format of Date Picker with hour and minutes
#define DATE_FORMAT_STYLE_WITH_TIME @"dd/MM/yyyy HH-mm"

/// Currently logged user's name
#define USER_NICKNAME   @"Username"

/// Currently logged user's password
#define USER_PASSWORD   @"Password"


/// The state of keep me logged in
#define KEEP_ME_LOGGED_IN @"KeepMeLoggedInState"

/// Last logged user name
#define LAST_LOGGED_USER_NAME   @"LastLoggedUserName"

/// The width of button. 
#define BUTTON_WIDTH 84

/// The height of button
#define BUTTON_HEIGHT 84

/// View height without navigation bar
#define TRANSFER_VIEW_HEIGHT        436

/// The key of local notification object id
#define LOCAL_NOTIF_OBJECT_ID           @"ObjectID"

/// The page name of the payment
#define BILL_PAGE_TITLE @"Payment Details"

/// The page name of the income
#define INCOME_PAGE_TITLE @"Income Details"

/// for iCloud document path
#define DOCUMENTS           @"Documents"

/// the root category directory
#define ROOT_CATEGORY_DIR   @"CategoryImages"


/*************   PERIODICITIES   *****************/
/// daily periodicity
#define PERIODICITY_DAILY       @"Daily"

/// workdays periodicity
#define PERIODICITY_WORKDAYS    @"Workdays"

/// weekly periodicity
#define PERIODICITY_WEEKLY      @"Weekly"

/// monthly periodicity
#define PERIODICITY_MONTHLY     @"Monthly"

/// quarterly periodicity
#define PERIODICITY_QUARTERLY   @"Quarterly"


/// the length of password is limited to 10 characters
#define MAX_PASSWORD_LENGTH 10
