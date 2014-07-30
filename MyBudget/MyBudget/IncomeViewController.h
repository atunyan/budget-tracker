/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 1/12/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "TransferViewController.h"
#import "MOIncome.h"

/**
 * @brief IncomeViewController class. This class is responsible for 
 * creating/adding new income. After creatin new income, the created income 
 * displays on @ref IncomesListTableViewController.
 */

@interface IncomeViewController : TransferViewController {

}

/**
 * @brief Initializes the class properties with the predifined values.
 * @param payment - The member of the transfer, may be also nil.
 * @param isFromCalendar - indicates is view opened from calendar or not
 * @return - Initialized the class object.
 */
- (id)initWithTransfer:(id)payment isOpenedFromCalendar:(BOOL)isFromCalendar;

@end
