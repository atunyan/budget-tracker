/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/8/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "ConfigManager.h"

static ConfigManager* configManager = nil;

@implementation ConfigManager

+(ConfigManager*) instance{
	if(configManager == nil){
		configManager = [[ConfigManager alloc] init];
	}
	return configManager;
}

-(NSArray*)arrayFromPlistFile:(NSString*)fileName byKey:(NSString*)keyName {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *mainConfigPath = [path stringByAppendingPathComponent:fileName];
    NSDictionary *mainConfigDictionary = [NSDictionary dictionaryWithContentsOfFile:mainConfigPath];
    
    NSArray* array = [mainConfigDictionary valueForKey:keyName];
    
    return  array;
}

@end
