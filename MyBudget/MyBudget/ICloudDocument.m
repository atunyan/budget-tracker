/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 3/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "ICloudDocument.h"
#import "MOUser.h"
#import "ICloudManager.h"

@implementation ICloudDocument
 
@synthesize user;

/// Called whenever the application reads data from the file system
-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError {
    if ([contents length] > 0) {        
        self.user = (MOUser*)[NSKeyedUnarchiver unarchiveObjectWithData:contents];
    } else {
        // When the note is first created, assign some default content
        self.user = nil;
    }
    return YES;
}

/// Called whenever the application (auto)saves the content of a document
-(id)contentsForType:(NSString *)typeName error:(NSError **)outError {
    self.user = [MOUser instance];
    
    return [NSKeyedArchiver archivedDataWithRootObject:self.user];
}
@end
