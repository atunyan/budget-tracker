/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/29/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "RepresentationView.h"

/// Represents report by pie view
@interface PieView : RepresentationView {
    /// Holds PieInfo objects
    NSArray* pieArray;
    
    /// shows pie legends    
    UIScrollView* legendsScrollView;
}

/**
 * @brief  Returns color by specified index
 * @param index - index
 * @returns color by specified index
 */
+(UIColor*)colorByIndex:(int)index;

@end
