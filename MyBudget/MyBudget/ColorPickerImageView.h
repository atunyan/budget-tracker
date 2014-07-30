
/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/14/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>


/** 
 * @brief The class is used to display the color wheel. It contains only one 
 * image of the color picker.
 */
@interface ColorPickerImageView : UIImageView {
	UIColor* lastColor;
	id pickedColorDelegate;
}

/// The last chosen color.
@property (nonatomic, retain) UIColor* lastColor;

/// The delegate to pass back the chosen color to the view Controller.
@property (nonatomic, assign) id pickedColorDelegate;

/**
 * @brief Gets the color of the pixel at the given location.
 * @param point - the point which color should be obtained.
 * @return - the chosen color.
 */
- (UIColor*) pixelColorAtLocation:(CGPoint)point;

/**
 * @brief Creates off screen bitmap context to draw the image into. 
 * Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
 * @param inImage - @todo
 * @return - created the bitmap context. We want pre-multiplied ARGB, 8-bits 
 * per component. Regardless of what the source image format is 
 * (CMYK, Grayscale, and so on) it will be converted over to the format
 * specified here by CGBitmapContextCreate.
 */
- (CGContextRef) newARGBBitmapContextFromImage:(CGImageRef)inImage;


@end
