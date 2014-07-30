/**
 *   @file
 *   My Budget
 *
 *   Created by Arevik Tunyan 27.04.12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>

/// The clas creates test information in database, in order to test app while developing.
@interface TestInfo : NSObject {
    
}

/// Creates test users with corresponding items.
+(void)saveTemporaryData;

@end
