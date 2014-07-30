/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 03/02/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#import "MOIncome.h"
#import "MOPayment.h"
#import "MOAccount.h"

/// the tag for displaying the item subtitle 
#define SUBTITLE_LABEL_TAG 69

/// the tag for displaying the item title 
#define TITLE_LABEL_TAG 59

/// tag for displaying the account label
#define ACCOUNT_LABEL_TAG 39

/// tag for displaying the amount label
#define AMOUNT_LABEL_TAG 29

/// tag for displaying the name label
#define NAME_LABEL_TAG 49

/// the tag for displaying the item location
#define LOCATION_LABEL_TAG 79

/// the tag for status label
#define STATUS_LABEL_TAG 89

/// The class creates all the neccessary labels for list view for all the items.
@interface ListView : NSObject {
    
}

/**
 * @brief Creates subtitle label
 * @param cell - the cell of table view on which the label is added
 */
+(void) createSubtitleLabel:(UITableViewCell *)cell;

/**
 * @brief Creates title label
 * @param cell - the cell of table view on which the label is added
 */
+(void) createTitleLabel:(UITableViewCell *)cell;

/**
 * @brief Creates account label
 * @param cell - the cell of table view on which the label is added
 */
+(void) createAccountLabel:(UITableViewCell *)cell;

/**
 * @brief Creates status label for payment and income list
 * @param cell - the cell of table view on which the label is added
 */
+(void) createStatusLabel:(UITableViewCell *)cell;

/**
 * @brief Creates amount label
 * @param cell - the cell of table view on which the label is added
 * @param currentObject - the current object which amount is displayed
 * @param date - selected date
 * @param isInEditingMode - YES, if list is in editing mode, otherwise NO.
 */
+(void) createAmountLabel:(UITableViewCell *)cell 
             filteredData:(MOTransfer *) currentObject 
          isInEditingMode:(BOOL) isInEditingMode
            accordingDate:(NSDate*)date;

/**
 * @brief Creates subsubtitle label
 * @param currentObject - the current object which subsubtitle is displayed
 * @param cell - the cell of table view on which the label is added
 * @param date - selected date
 */
+(void) createSubsubTitleLabel:(MOPayment *)currentObject cell:(UITableViewCell *)cell accordingDate:(NSDate*)date;

/**
 * @brief Creates account type label for accounts list
 * @param cell - the cell of table view on which the label is added
 * @param currentObject - the current object which account type is displayed
 * @param isInEditingMode - YES, if list is in editing mode, otherwise NO.
 */
+(void) createAccountTypeLabel:(UITableViewCell *)cell filteredData:(MOAccount *)currentObject isInEditingMode:(BOOL) isInEditingMode;

/**
 * @brief Creates location label for payments list
 * @param currentObject - the current object which location is displayed
 * @param cell - the cell of table view on which the label is added
 */
+(void) createLocationLabel:(MOPayment *)currentObject cell:(UITableViewCell *)cell;


/**
 * @brief Adds title and subtitle texts for income
 * @param currentObject - the current object which title and subtitle are displayed
 * @param cell - the cell of table view on which the label is added
 * @param date - selected date
 */
+(void) addTitleAndSubtitleForIncome:(MOIncome *)currentObject cell:(UITableViewCell *)cell accordingDate:(NSDate*)date;

/**
 * @brief Adds title and subtitle texts for payment
 * @param payment - the  current object which title and subtitle are displayed
 * @param cell - the cell of table view on which the label is added
 */
+(void) addTitleAndSubtitleForPayment:(MOPayment *) payment cell:(UITableViewCell *) cell;

/**
 * @brief Adds title and subtitle texts for account
 * @param account - the  current object which title and subtitle are displayed
 * @param cell - the cell of table view on which the label is added
 */
+(void) addTitleAndSubtitleForAccount:(MOAccount *) account cell:(UITableViewCell *) cell;

/**
 * @brief Adds accounts' label texts for income
 * @param transfer - the  current object which account label text is added
 * @param cell - the cell of table view on which the label is added
 * @param isInEditingMode - YES, if list is in editing mode, otherwise NO.
 */
+(void) addAccountLabelText:(MOTransfer *) transfer cell:(UITableViewCell *) cell isInEditingMode:(BOOL) isInEditingMode;


/**
 * @brief Adds status label text
 * @param transfer - the current transfer(income/payment) which status label should be added
 * @param cell - the cell of table view on which the label is added
 * @param selectedDate - the selected date, according which the sorting is done.
 */
+(void) addStatusLabelText:(MOTransfer *) transfer cell:(UITableViewCell *) cell 
           isInEditingMode:(BOOL) isInEditingMode 
             selectedDate :(NSDate *) selectedDate;


@end
