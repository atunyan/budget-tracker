/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/8/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>

/// Used for reading and writing plist files
@interface ConfigManager : NSObject

/// returns the only instance of ConfigManager class
+(ConfigManager*) instance;

/**
 * @brief  gets array from plist file by specified key
 * @param fileName - plist file name
 * @param keyName - key name by which should be retreived data
 * @return - existing array
 */
-(NSArray*)arrayFromPlistFile:(NSString*)fileName byKey:(NSString*)keyName;

@end
