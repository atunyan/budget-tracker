/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/9/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>

@class SelectingInfo;

/// Used as parent class for all selectable table views
@interface SelectingTableViewController : UITableViewController {
    /// Info object
    SelectingInfo* selectingInfo;
    
    /// Table view title
    NSString* viewTitle;
    
    /// selected row index
    int selectedRowIndex;
}

/**
 * @brief  Initializes by specified style, by info, by title
 * @param style - table view style
 * @param info - info
 * @param title - table view title
 * @return - returns initialized object
 */
- (id)initWithStyle:(UITableViewStyle)style andWithInfo:(SelectingInfo*)info andWithTitle:(NSString*)title;

@end
