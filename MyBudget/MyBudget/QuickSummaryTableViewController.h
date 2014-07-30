/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/24/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>

/// Indicates type of income/payment durations for calculating sum amount
typedef enum {
    /// duration by day
    kDurationTypeDay = 0,
    
    /// duration by week
    kDurationTypeWeek,
    
    /// duration by month
    kDurationTypeMonth,
    
    /// duration by year
    kDurationTyepYear,
} DurationType;

/// Shows income/payment quick summary by day, week, month, year
@interface QuickSummaryTableViewController : UITableViewController {
	/// headers array
    NSArray* elements;
    
    /// headers array
    NSArray* imagesNames;
    
    /// Current date
    NSDate* date;
}

@end
