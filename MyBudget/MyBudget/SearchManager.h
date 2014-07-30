/**
 *   @file 
 *   My Budget
 *
 *   Created by Arevik Tunyan on 01/03/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

/// The class is responsible for performing search with advances settings.
@interface SearchManager : NSObject {
    
}

/**
 * @brief Returns the list of items filtered according to specified keyword.
 * @param array - the list of items on which filtering should be done.
 * @return - the filtered list of items 
 */
+(NSMutableArray *) listFilteredByKeyword :(NSString *) keyword array :(NSMutableArray *) array;

@end
