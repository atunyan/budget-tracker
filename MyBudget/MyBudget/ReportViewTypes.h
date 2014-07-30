/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 4/10/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "MyBudgetAppDelegate.h"

@class MOReport;

/// Shows report view types
@interface ReportViewTypes : UITableViewController <ADBannerViewDelegate, BannerViewContainer> {
    /// Report object
    MOReport* report;
}

@end
