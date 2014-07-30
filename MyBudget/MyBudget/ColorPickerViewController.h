/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/14/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "ColorPickerImageView.h"

/**
 * @brief The class is used for choosing an color for the whole application. 
 * Touching to the wheel, one can easily choose a color.
 */
@interface ColorPickerViewController : UIViewController {
    ColorPickerImageView* colorWheel;
}

/// The color wheel which is used for choosing colors.
@property (nonatomic, retain) ColorPickerImageView* colorWheel;

/**
 * @brief The delegate method to pass the choosen color.
 * @param color - the choosen color.
 */
- (void) pickedColor:(UIColor*)color;

@end

