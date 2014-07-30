/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/29/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>

/// Used as Pie reporting model file
@interface PieInfo : NSObject {
    NSString* categoryName;
    NSNumber* payments;
    float percent;
}

/// category names for Pie vew
@property (nonatomic, retain) NSString* categoryName;

/// payments for Pie view
@property (nonatomic, retain) NSNumber* payments;

/// persent for each pie
@property (nonatomic, assign) float percent;

@end
