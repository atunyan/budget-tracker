/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 29.02.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "SearchData.h"

#import "DatePickerViewController.h"

/**
 * @brief Search TableView class is responsible for searching any item from the available list.
 * It is possible to perform search only in one bean (e.g. income, payment) and in all the beans.
 */
@interface SearchTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, DatePickerViewControllerDelegate> {
    
    /// The array of income items filtered according to specified keyword.
    NSMutableArray *incomeFilteredData;
    
    /// The array of payment items filtered according to specified keyword.
    NSMutableArray *paymentFilteredData;
    
    /// The array of account items filtered according to specified keyword.
    NSMutableArray *accountFilteredData;
    
    /// The search bar 
    UISearchBar *searchBar;
    
    /// The search display controller for displaying search results.
    UISearchDisplayController *lsearchController;
    
    /// The search data
    SearchData* searchData;
}

@end
