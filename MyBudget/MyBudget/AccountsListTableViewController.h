/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 2/9/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "TransferListViewController.h"
#import "MOAccount.h"

/// @brief the AccountsListTableViewControllerDelegate.
@protocol AccountsListTableViewControllerDelegate <NSObject>

/**
 * @brief the delegate method, which calls at selecting account
 * @param account - the selected account name
 */
-(void)didSelectAccount:(MOAccount*)account;

@end

/**
 * @brief AccountListTableViewController class is responsible for displaying and removing 
 * accounts list.
 */
@interface AccountsListTableViewController : TransferListViewController {
    
    id<AccountsListTableViewControllerDelegate> delegate;
    
    /// selected account
    MOAccount* account;
    
}
/// the AccountsListTableViewControllerDelegate delegate.
@property(nonatomic, assign) id<AccountsListTableViewControllerDelegate> delegate;

@end
