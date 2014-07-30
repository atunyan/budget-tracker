/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/8/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "SelectingTableViewController.h"

/// Displays all available currencies and current currency
@interface CurrencyTableViewController : SelectingTableViewController

/// Scrolls to selected currency row
-(void)scrollToSelectedRow;

@end
