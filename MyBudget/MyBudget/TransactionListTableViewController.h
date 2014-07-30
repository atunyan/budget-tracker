/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 3/1/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "TransferListViewController.h"
#import "MOAccount.h"

/**
 * @brief TransactionListTableViewController class is responsible for displaying all 
 * transactions which were made from selected account.
 */
@interface TransactionListTableViewController: UITableViewController {
    
    /// the transaction items array
    NSMutableArray* transactionItems;
    
    /// the current account
    MOAccount* currentTransAccount;
}
/**
 * @brief Initilizes transaction list for current account
 * @param style - the table view style
 * @param account - current account
 * @return initilized transaction list table view
 */
- (id)initWithStyle:(UITableViewStyle)style withAccount:(MOAccount*)account;

@end
