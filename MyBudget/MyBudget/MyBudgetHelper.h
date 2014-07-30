/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 06.03.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#import "MORecurrence.h"
#import "MOTransfer.h"

/// The class keeps the class methods which are used in whole project.
@interface MyBudgetHelper : NSObject {
    
}

/**
 * @brief converts UIColor to the UIImage.
 * @param color - the color to be converted to the image
 * @return - converted image
 */
+ (UIImage *)imageWithColor:(UIColor *)color;


/**
 * @brief  Gets day of date
 * @param date - date, from which shoulf be received day
 * @return - day
 */
+(NSDate*)dayFromDate:(NSDate*)date;

/**
 * @brief  Trims string
 * @param string - string, that should be trimmed
 * @return - trimmed string
 */
+(NSString*)trimString:(NSString*)string;

/**
 * @brief Returns recurrence by specified date
 * @param date - recurrence date
 * @param transfer - transfer object
 * @param format - format, by which should be compared recurrences
 * @return recurrence
 */
+(MORecurrence*)recurrenceByDate:(NSDate*)date transfer:(MOTransfer*)transfer withFormatter:(NSString*)format;

/// @return income's (green) color
+(UIColor*)incomeColor;

/// @return payment's (red) color 
+(UIColor*)paymentColor;

@end
