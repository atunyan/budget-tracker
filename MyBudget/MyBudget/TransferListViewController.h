/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/14/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "TransferProtocols.h"
#import "TransferDataSource.h"
#import "Kal.h"
#import "MOTransfer.h"

/// Used for handling actions from list table view to parent view controller
@protocol TransferListViewControllerDelegate <NSObject>

/// Opens entity add/update view
-(void)openEntityViewController:(id)data;

@end

/**
 * @brief This is parent class for payment/income lists.
 */
@interface TransferListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, TransferViewControllerDelegate, UIActionSheetDelegate> {
    /// The array of items displayed in the table view
    UITableView* tableView;
    
    /// The array of items stored in the database
    NSMutableArray* listOfItems;
    
    /// The array of items filtered according to visible month
    NSMutableArray* filteredItems;
    
    /// Indicates is table view in editing mode
    BOOL isInEditingMode;
    
    /// Indicates is account selected
    BOOL isAccountSelected;
    
    /// Indicates visible month.
    NSDate* selectedMonth;
    
    /// The height of toolbar
    NSUInteger toolbarHeight;
    
    /// The selected transfer;
    MOTransfer* transfer;   
}

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, assign) BOOL isAccountSelected;
@property (nonatomic, retain) NSDate* selectedMonth;
@property (nonatomic, retain) NSMutableArray* filteredItems;

/**
 * @brief  Creates table view cell amount label
 * @param cell - table view cell
 * @param index - the index of current item
 */
-(void)createAmountLabel:(UITableViewCell *)cell index:(NSInteger)index;

/**
 * @brief  Creates the name label for payment
 * @param index - the index of current item
 * @param cell - table view cell
 */
-(void) createSubsubTitleLabel:(NSInteger) index cell:(UITableViewCell *)cell;

/**
 * @brief  Adds category icon and name to the lists
 * @param index - the index of current item
 * @param cell - the current cell on which the category name and icon should be added.
 */
-(void)addTitleAndSubtitle:(NSInteger)index cell:(UITableViewCell *) cell;

/**
 * @brief  Adds ammount label text
 * @param index - the index of current item
 * @param cell - the current cell on which the category name and icon should be added.
 */
-(void) addAccountLabelText:(NSInteger) index cell:(UITableViewCell *) cell;

/**
 * @brief  Adds status label text
 * @param index - the index of the current item
 * @param cell - the current cell on which the status label should be added
 */
-(void) addStatusLabelText:(NSInteger) index cell:(UITableViewCell *) cell;

/**
 * @brief  The target method, wich calls when need to add/change entity.
 * @param indexPathRow - indexPath row
 */
-(void)updateEntity:(NSInteger)indexPathRow;

/// Filter items by months for representing in list
-(void)filterByMonth;

@end
