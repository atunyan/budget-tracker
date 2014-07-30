/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 4/6/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
/// @brief CustomPageControl class is responsible for creating custom UIPageControl.
@interface CustomPageControl : UIView {
    /// page control dots count
    NSInteger dotCount;
    
    NSInteger currentPageIndex;
    
    /// page control dots color
    UIColor* dotColor;
}
/// current selected page index
@property(nonatomic, assign) NSInteger currentPageIndex;

/// this method updates custom page control view at page changing 
- (void)updateCurrentPageDisplay;

/**
 * @brief  initilize CustomPageControl class with frame and page count
 * @param pageCount - the control page count
 * @param frame - the control frame
 * @return initilized CustomPageControl object
 */
- (id)initWithFrame:(CGRect)frame withPageCount:(NSInteger)pageCount;

@end
