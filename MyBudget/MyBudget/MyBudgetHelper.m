/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 06.03.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "MyBudgetHelper.h"
#import "Constants.h"
#import "CoreDataManager.h"

@implementation MyBudgetHelper


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(NSDate*)dayFromDate:(NSDate*)date {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:DATE_FORMAT_STYLE];
    
    NSString* dateString = [formatter stringFromDate:date];
    NSDate* dateByDay = [formatter dateFromString:dateString];
    return dateByDay;
}

+(NSString*)trimString:(NSString*)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+(MORecurrence*)recurrenceByDate:(NSDate*)date transfer:(MOTransfer *)transfer withFormatter:(NSString*)format {
    NSArray* recurrings = [CoreDataManager sortSet:transfer.recurrings byProperty:SORT_BY_DATE_TIME ascending:YES];
    for (MORecurrence* recurrence in recurrings) {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:format];
        if ([[formatter stringFromDate:date] isEqualToString:[formatter stringFromDate:recurrence.dateTime]]) {
            return recurrence;
        }
    }
    return nil;
}

+(UIColor*)incomeColor {
    return [UIColor colorWithRed:56.0/255.0 green:124.0/255.0 blue:50.0/255.0 alpha:1.0];
}

+(UIColor*)paymentColor {
    return [UIColor colorWithRed:192.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
}

@end
