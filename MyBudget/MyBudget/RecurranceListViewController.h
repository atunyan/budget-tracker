/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 4/4/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "TransferListViewController.h"

/// calendar view tag
#define KAL_VIEW_TAG            2000

/// Used for showing list view and calendar for recurring objects
@interface RecurranceListViewController : TransferListViewController {
    
    /// Shows the calendar view.
    KalViewController* kalViewController;
    
    /// Manage the data source of the calendarView
    TransferDataSource* dataSource; 
}

@end
