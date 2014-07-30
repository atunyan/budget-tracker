//
//  ICloudManager.m
//  MyBudget
//
//  Created by user on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICloudManager.h"
#import "MOUser.h"
#import "CoreDataManager.h"

/// User entity name
#define ENTITY_USER             @"MOUser"

static ICloudManager* iCloudManager = nil;

@implementation ICloudManager

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;
@synthesize fileName;

+(ICloudManager*) instance {
	if(iCloudManager == nil){
		iCloudManager = [[ICloudManager alloc] init];
	}
	return iCloudManager;
}

- (BOOL)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *objectContext = self.managedObjectContext;
    if (objectContext != nil)
    { 
        if ([objectContext hasChanges] && ![objectContext save:&error])
        {
            // add error handling here
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
            return NO;
        }
    }
    return YES;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    if (!fileName) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // REMOVE APP FROM SIMULATOR :)
        abort();
    }
    
    return persistentStoreCoordinator;
}

-(MOUser*)userByNickname:(NSString*)nickname andPassword:(NSString*)password {
    // create fetch object, this object fetch's the objects out of the database
    if (nickname && password) {
        NSError* error;
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:ENTITY_USER inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nickname like %@ AND password like %@", nickname, password];
        [fetchRequest setPredicate:predicate];
        
        NSArray* fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        [fetchRequest release];
        
        if ([fetchedObjects count] > 0) {
            return [fetchedObjects objectAtIndex:0];
        }
    }    
    return nil;
}

-(void)restoreDataFromFile:(NSString*)aFileName {
//    persistentStoreCoordinator = nil;
//    self.fileName = aFileName;
//    
//    MOUser* userRestore = [[ICloudManager instance] userByNickname:[MOUser instance].nickname andPassword:[MOUser instance].password];
//    
//    
//    [[CoreDataManager instance] deleteData:[MOUser instance] alsoFromPersitentStore:YES];
//    [[CoreDataManager instance] saveContext];
//    MOUser* user = [[CoreDataManager instance] user];
//    [[CoreDataManager instance] saveContext];
//    NSLog(@"%@", [MOUser instance].nickname);
//    NSLog(@"%@", [MOUser instance].password);
//    
//    NSLog(@"%@", user.nickname);
//    NSLog(@"%@", user.password);
//    
//    NSLog(@"%@", userRestore.nickname);
//    NSLog(@"%@", userRestore.password);
//    
//    user = userRestore;
//    [[CoreDataManager instance] saveContext];
//    [MOUser setInstance:user];
//    
//    NSLog(@"%@", [MOUser instance].nickname);
//    NSLog(@"%@", [MOUser instance].password);
//    
//    NSLog(@"%@", user.nickname);
//    NSLog(@"%@", user.password);
//    
//    NSLog(@"%@", userRestore.nickname);
//    NSLog(@"%@", userRestore.password);
//    
//    
//    [[CoreDataManager instance] saveContext];    
//    
//    NSLog(@"%@", [MOUser instance].nickname);
//    NSLog(@"%@", [MOUser instance].password);
//    
//    NSLog(@"%@", user.nickname);
//    NSLog(@"%@", user.password);
//    
//    NSLog(@"%@", userRestore.nickname);
//    NSLog(@"%@", userRestore.password);
//    
//    MOUser* testUser = [[CoreDataManager instance] userByNickname:[MOUser instance].nickname andPassword:[MOUser instance].password];
//    NSLog(@"%@", testUser.nickname);
//    NSLog(@"%@", testUser.password);
}

@end
