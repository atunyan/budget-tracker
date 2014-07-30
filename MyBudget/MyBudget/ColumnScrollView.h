/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 3/5/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>

@class Report;

/// Used for showing Accounts columns in paging scrolling view
@interface ColumnScrollView : UIScrollView {
    Report* report;
    
    /// values  for y-axis    
    NSMutableArray*  yAxisValueArray;
    
    /// holds ColumnReportInfo objects for drawing columns
    NSMutableArray* columnReportInfoArray;

    /// holds column page views
    NSMutableArray* columnPageArray;
}

///data source for report view
@property (nonatomic, retain) Report* report;

/**
 * @brief  Creates object with specified frame, report
 * @param frame - frame
 * @param aReport - report
 * @return - Initialized object
 */
-(id)initWithFrame:(CGRect)frame withReport:(Report*)aReport;

/// updates scroll view
-(void)updateScrollView;

@end
