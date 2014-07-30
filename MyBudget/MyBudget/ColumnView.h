/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/29/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "RepresentationView.h"

@class ColumnScrollView;

/// Represents report by columns view
@interface ColumnView : RepresentationView {
    /// legends title array
    NSArray* legendsTitleArray;
    
    /// Account columns scroll view
    ColumnScrollView* columnScrollView;
}

@end
