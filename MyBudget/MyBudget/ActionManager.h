
/**
 *   @file 
 *   My Budget
 *
 *   Created by Arevik Tunyan on 23/04/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@class MOTransfer;
@class MOAccount;

/**
 * @brief The class is responsible for perforing actions such as save, delete
 * and edit with items (income, payment and account).
 */
@interface ActionManager : NSObject {
    
}

/**
 * @brief Deletes non recurring transfer, and for the recurring transfer, opens 
 * the actionSheet in the selected view and deletes the selected transfer.
 * @param transfer - the transfer to which recurring is added
 * @return - YES, if transfer is deleted successfully, otherwise NO
 */
+(BOOL) deleteNonRecurringItem:(MOTransfer *)transfer;

/**
 * @brief Deletes non recurring transfer, and for the recurring transfer, opens 
 * the actionSheet in the selected view and deletes the selected transfer.
 * @param transfer - the transfer to which recurring is added
 * @param view - the view on which actionSheet should be opened
 * @param delegate - the delegate of action sheet
 * @return - YES, if transfer is deleted successfully, otherwise NO
 */
+(BOOL) deleteTransfer:(MOTransfer *)transfer  view:(UIView*) view delegate:(id) delegate;


/**
 * @brief Deletes the selected transfer, depending on the chosen option of action sheet.
 * @param transfer - the transfer to which recurring is added
 * @param buttonIndex - the button index of action sheet
 * @param selectedMonth - the selected month
 * @return - YES if the transfer is deleted successfully, otherwise NO
 */
+(BOOL) deleteRecurrencesOf:(MOTransfer *) transfer 
                     index:(NSInteger) buttonIndex 
                      date:(NSDate *) selectedMonth;

/**
 * @brief Adds recurring to the transfer.
 * @param fireDate - the fire date of recurring, is nil for income
 * @param transfer - the transfer to which recurring is added
 */
+(void)addRecurringsBySelectedDate:(NSDate*)fireDate 
                          transfer:(MOTransfer *) transfer;

/**
 * @brief Adds transfer to the account with selected date
 * @param transfer - the transfer to be added to the account
 * @param selectedDate - the date according which the filtering should be done
 */
+(void) addToAccount:(MOTransfer *)transfer selectedDate:(NSDate *) selectedDate;

/**
 * @brief Calculates the total amount of incomes connected to the account
 * @param currentAccount - the account for which incomes should be calculated
 * @return - the total amount of incomes connected to the specified account
 */
+(NSNumber *) totalAmountOfAccountIncomes:(MOAccount *) currentAccount;

/**
 * @brief Calculates the total amount of payments connected to the account
 * @param currentAccount - the account for which paymentss should be calculated
 * @return - the total amount of payments connected to the specified account
 */
+(NSNumber *) totalAmountOfAccountPayments:(MOAccount *) currentAccount;

/**
 * @brief Creates local notifications for recurring transfers
 * @param fireDate - reminder time
 * @param transfer - the transfer to be added to the account
 */
+ (void)scheduleNotificationWithFireDate:(NSDate*)fireDate transfer:(MOTransfer *) transfer;

@end
