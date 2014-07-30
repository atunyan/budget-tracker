/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 3/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "MOUser.h"

@class MOUser;

/// Used for Backup/Restore in iCloud
@interface ICloudDocument : UIDocument

/// data, that should be backuped/restored
@property (nonatomic, retain) MOUser* user;

@end
