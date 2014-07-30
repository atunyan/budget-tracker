/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 3/20/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>

/// Used for iCloud backup/restore date to/from sqlite file
@interface ICloudManager : NSObject {
    NSManagedObjectContext* managedObjectContext;
    NSManagedObjectModel* managedObjectModel;
    NSPersistentStoreCoordinator* persistentStoreCoordinator;
    
    NSString* fileName;
}

/// managed object context
@property (nonatomic, retain, readonly) NSManagedObjectContext* managedObjectContext;

/// mnaged object model
@property (nonatomic, retain, readonly) NSManagedObjectModel* managedObjectModel;

/// persistent store coordinator
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;

/// backup file name
@property (nonatomic, retain) NSString* fileName;

/// returns the only instance of ICloudManager class
+(ICloudManager*) instance;

/**
 * @brief  saves context into Core Data
 * @return - indicates is context saved
 */
- (BOOL)saveContext;

/**
 * @brief  restores data from file
 * @param aFileName - backup file name
 */
-(void)restoreDataFromFile:(NSString*)aFileName;

@end
