/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 3/7/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>

/// Represents pie legends
@interface PieLegendsView : UIView {
    /// Holds PieInfo objects
    NSArray* pieArray;
}

/**
 * @brief  Creates object with specified frame and info array
 * @param frame - frame
 * @param array - info array
 * @return - initialized object
 */
- (id)initWithFrame:(CGRect)frame withPieArray:(NSArray*)array;

@end
