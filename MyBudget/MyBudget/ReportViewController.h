/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/22/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "MyBudgetAppDelegate.h"
#import "DurationPickerViewController.h"

/// Indicates Report view UI type
typedef enum {
    /// table view
    kReportViewTypeTable = 0,
    
    /// column type
    kReportViewTypeColumn,
    
    /// pie type
    kReportViewTypePie,
    
    /// graphic type
    kReportViewTypeGraphic,
} ReportViewType;

@class ReportTableViewController;
@class ReportView;
@class PieView;
@class ColumnView;

///template yet empty
@interface ReportViewController : UIViewController <ADBannerViewDelegate, BannerViewContainer, DurationPickerViewControllerDelegate> {
    /// Shows reports by table
    ReportTableViewController* tableViewController;
    
    /// Shows reports by graphic
    ReportView* graphicView;
    
    /// Shows reports by pie
    PieView* pieView;
    
    /// Shows reports by columns
    ColumnView* columnView;
}

@end
