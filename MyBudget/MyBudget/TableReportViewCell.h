/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/22/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>

/// Indicates Cell type
typedef enum {
    /// head type (always visible)
    kCellTypeHeader,
    
    /// Payment type (only these visible in Payment page)
    kCellTypeCommon,
} CellType;

///custom  tableview  cell  represents  table  report row
@interface TableReportViewCell : UITableViewCell {
    ///cell type
    CellType cellType;
  
    ///header titles
    NSArray* headerTitles;
    ///table rect
    CGRect tableRect;
    
    NSString* monthTitle;
    NSNumber* income;
    NSNumber* payment;
}
/// the month
@property (nonatomic,retain) NSString* monthTitle;

/// income amount
@property (nonatomic,retain) NSNumber* income;

/// payment amount
@property (nonatomic,retain) NSNumber* payment;

/// sets type of current cell
-(void) setCellType:(CellType) cType;
@end
