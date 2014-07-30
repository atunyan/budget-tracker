/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/9/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>

/// Used as parent class for all selectable models
@interface SelectingInfo : NSObject {
    NSArray* elementArray;
    NSString* currentElement;
}

/// holds all elements
@property (nonatomic, retain) NSArray* elementArray;

/// holds current selected element
@property (nonatomic, retain) NSString* currentElement;

@end
