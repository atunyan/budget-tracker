/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/26/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>

/// Indicates Category type
typedef enum {
    /// common type (always visible)
    kCategoryTypeCommon = 0,
    
    /// Payment type (only these visible in Payment page)
    kCategoryTypePayment = 1,
} CategoryType;

@class CoreDataHelper;
@class MOUser;
@class MOIncome;
@class MOCategory;
@class UserInfo;
@class MOPayment;
@class MOAccount;
@class MORecurrence;
@class MOSetting;
@class MOReport;
@class MOSearchSettings;

/// Handles Core Data requests
@interface CoreDataManager : NSObject {
    NSManagedObjectContext* managedObjectContext;
    NSManagedObjectModel* managedObjectModel;
    NSPersistentStoreCoordinator* persistentStoreCoordinator;
    
    /// Root categories array
    NSArray* rootCategories;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;

/**
 * @brief  Returns the URL to the application's Documents directory.
 * @return - the URL to the application's Documents directory
 */
- (NSURL *)applicationDocumentsDirectory;

/**
 * @brief  saves context into Core Data
 * @return - indicates is context saved
 */
- (BOOL)saveContext;

/// returns the only instance of CoreDataManager class
+(CoreDataManager*) instance;

/**
 * @brief  saves new created User
 * @param user - User's property class object
 * @return - indicates is object saved
 */
-(BOOL)saveUserData:(UserInfo*)user;

/**
 * @brief  returns User by specified nickname and password
 * @param nickname - user's nickname
 * @param password - user's password
 * @return - returns initialized User object
 */
-(MOUser*)userByNickname:(NSString*)nickname andPassword:(NSString*)password;

/// returns new Income object
-(MOIncome*)income;

/// returns new Category object
-(MOCategory*)category;

/// returns new Payment object
-(MOPayment*)payment;

/// return new Account object
-(MOAccount*)account;

/// return new Recurring object
-(MORecurrence*)recurring;

/// return new Setting object
-(MOSetting*)setting;

/// returns new search setting
-(MOSearchSettings*) searchSettings;

/// return new Report object
-(MOReport*)report;

/// return new User object
-(MOUser*)user;

/**
 * @brief  deletes managed object from context or from persistent store too
 * @param data - object, that should be deleted
 * @param isFromPS - i delete from persistent store
 * @return - indicates is object deleted
 */
-(BOOL)deleteData:(NSManagedObject*)data alsoFromPersitentStore:(BOOL)isFromPS;

/**
 * @brief  Sorts nSSet by specified property
 * @param nsSet - NSSet object, that should be sorted
 * @param propertyName - property name, by which should be sorted NSSet
 * @param ascending - indicates, sort by ascending or descending
 * @return - sorted array
 */
+(NSArray*)sortSet:(NSSet*)nsSet byProperty:(NSString*)propertyName ascending:(BOOL)ascending;

/** 
 * @brief  deletes old data (Payment, Incomes) by delete after months value
 * @return - indicates is operation ended successfully
 */
-(BOOL)deleteOldData;

/**
 * @brief  Gets filtered recurrings by specified start and end dates
 * @param set - set, which should be filtered
 * @param startDate - start date
 * @param endDate - end date
 * @return - filtered set
 */
+(NSSet*)filteredRecurrings:(NSSet*)set fromStartDate:(NSDate*)startDate toEndDate:(NSDate*)endDate;

/**
 * @brief  Gets sum amount of recurrings by specified start/end dates
 * @param set - set, which should be received amount
 * @param startDate - start date
 * @param endDate - end date
 * @return - sum amount
 */
+(NSNumber*)sumAmountOfRecurrings:(NSSet*)set fromStartDate:(NSDate*)startDate toEndDate:(NSDate*)endDate;

/**
 * @brief  Gets the sub set filtered via name.
 * @param set - the set from which the subset should be filtered.
 * @param name - the filter criteria
 * @return - the filtered subset
 */
+(NSSet*)subSetOf:(NSSet*)set filteredByName:(NSString *)name;

/**
 * @brief  Gets sum amount of done(payed) recurrances
 * @param set - set, which should be received amount
 * @return - sum amount
 */
+(NSNumber*)sumAmountOfDoneSet:(NSSet*)set;

/**
 * @brief  Gets the sub set filtered via account.
 * @param set - the set from which the subset should be filtered.
 * @param account - account
 * @return - the filtered subset
 */
+(NSSet*)subSetOf:(NSSet*)set filteredByAccount:(MOAccount*)account;

/**
 * @brief  Gets the sub set filtered via category.
 * @param set - the set from which the subset should be filtered.
 * @param category - category
 * @return - the filtered subset
 */
+(NSSet*)subSetOf:(NSSet*)set filteredByCategory:(MOCategory*)category;

/**
 * @brief  Checks is nickname busy or free for registering new user
 * @param nickname - nickname, that should be checked
 * @return - returns is nickname busy or not
 */
-(BOOL)isNicknameBusy:(NSString *)nickname;

/**
 * @brief  Checks is name busy or free for registering new account
 * @param set - set, in which should be checked
 * @param name - the filter criteria
 * @return - returns is account name busy or not
 */
-(BOOL)isInSet:(NSSet*)set nameBusy:(NSString*)name;

/**
 * @brief  Checks is category used or free for deleting
 * @param category - category, that should be checked
 * @return - returns is category used or not
 */
-(BOOL)isCategoryUsed:(MOCategory*)category;

/**
 * @brief  Gets Pie elements for drawing Pie report view
 * @param startMonth - start month date
 * @param endMonth - end month date
 * @return - returns PieInfo array
 */
-(NSArray*)piesForReportFromStartMonth:(NSDate*)startMonth toEndMonth:(NSDate*)endMonth;

/**
 * @brief Gets the lists of image names from the resources
 * @return - the image names.
 */
+(NSArray*)imageNameArray;

/**
 * @brief  Indicates is account used or not
 * @param account - account
 * @return - is account used
 */
-(BOOL)isAccountUsed:(MOAccount*)account;

/**
 * @brief  Returns elements filtered by done
 * @param array - array, from which should be received data
 * @return - filtered data
 */
+(NSArray*)arrayWithDoneStatus:(NSArray*)array;

/**
 * @brief Gets all the user categories.
 * @return - the set of user categories
 */
-(NSMutableSet*)userCategories;

/**
 * @brief Gets the category by name from the  given set
 * @param categoryName - the name of category
 * @param categorySet - the set from which the category should be found
 * @return - the found category
 */
-(MOCategory*)categoryByName:(NSString*)categoryName fromSet:(NSSet*)categorySet;

/**
 * @brief Shows whether in data base are registered users or NO.
 * @return YES, if there are registered users, otherwise NO.
 */
-(BOOL)existRegisteredUsers;

@end
