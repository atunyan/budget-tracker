/**
 *   @file
 *a   MyBudget
 *
 *   Created by Arevik Tunyan on 3/6/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>

@class ColumnReportInfo;

/// Represents columns one component (income/payment/account columns)
@interface ColumnPageView : UIView {
    /// hold info objects array
    NSArray* infoArray;
    
    /// values  for y-axis    
    NSArray*  yAxisValueArray;
    
    ///factor for shows correct value in the graphic
    float factor;

    /// holds 0-y-axis position
    float zeroYPosition;
}

/**
 * @brief  Creates object with specified frame, info array, y-axis value array
 * @param frame - frame
 * @param array - model info array
 * @param yArray - y-axis value array
 * @return - Initialized object
 */
-(id)initWithFrame:(CGRect)frame withInfoArray:(NSArray*)array withYAxisValueArray:(NSArray*)yArray;

@end
