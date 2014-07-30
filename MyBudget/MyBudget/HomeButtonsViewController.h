/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 10.01.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

/// The tag for Login button
#define LOGIN_BUTTON_TAG 77

/** 
 * @brief the class is the main view of the @b MyBudget project. The main
 * buttons are created in this view which are available from home and settings page. 
 */
@interface HomeButtonsViewController : UIViewController<UIScrollViewDelegate> {
    
    /**
     * @brief The number of columns, depends on the device orientation. 
     * For portrait mode it is 3, for the landscape mode it is 4.
     */
    NSUInteger numberOfRows;

    /// holds buttons tags and names
    NSMutableDictionary* buttonNameTagDictionary;
}

/**
 * @brief Replaces home button with Contact.
 * @param tag - the tag for home/contact button.
 */
-(void) changeButton:(NSUInteger)tag;

/// Creates the scroll view and adds buttons on it.
-(void)createMainView;

@end
