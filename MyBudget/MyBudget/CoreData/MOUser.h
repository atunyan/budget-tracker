/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/26/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MOSetting.h"

@class MOCategory, MOIncome, MOPayment, MOSearchSettings;

/**
 * @brief The class keeps the properties of Core Data User, which are describing user, such as user's nickname, password.
 */
@interface MOUser : NSManagedObject

/// User account number
@property (nonatomic, retain) NSString * accountNumber;

/// User email
@property (nonatomic, retain) NSString * eMail;

/// User first name
@property (nonatomic, retain) NSString * firstName;

/// User last name
@property (nonatomic, retain) NSString * lastName;

/// User nickname
@property (nonatomic, retain) NSString * nickname;

/// User password
@property (nonatomic, retain) NSString * password;

/// User phone number
@property (nonatomic, retain) NSString * phoneNumber;

/// User status
@property (nonatomic, retain) NSNumber *isLogged;

/// User categories
@property (nonatomic, retain) NSMutableSet *categories;

/// User incomes
@property (nonatomic, retain) NSMutableSet *incomes;

/// User payments
@property (nonatomic, retain) NSMutableSet *payments;

///User accounts
@property (nonatomic, retain) NSMutableSet* accounts;

/// User setting
@property (nonatomic, retain) MOSetting *setting;

/// User search setting
@property (nonatomic, retain) MOSearchSettings *searchSettings;

/// Sets the only instance of User class
+(void)setInstance:(MOUser*)instance;

/// returns the only instance of User class
+(MOUser*) instance;

/// Resets the only instance of User class
+(void) resetUserData;

/// Sets the only instance of User logged in state
+(void)setKeepMeLoggedIn:(BOOL)loggedIn;

/// returns the only instance of User logged in state
+(BOOL)keepMeLoggedIn;

/// Sets the last logged user name
+(void)setLastLoggedUserName:(NSString*)userName;

/// returns last logged user name
+(NSString*)lastLoggedUserName;

@end

//@interface User (CoreDataGeneratedAccessors)
//
//- (void)addUserCategoriesObject:(Category *)value;
//- (void)removeUserCategoriesObject:(Category *)value;
//- (void)addUserCategories:(NSSet *)values;
//- (void)removeUserCategories:(NSSet *)values;
//- (void)addUserIncomesObject:(Income *)value;
//- (void)removeUserIncomesObject:(Income *)value;
//- (void)addUserIncomes:(NSSet *)values;
//- (void)removeUserIncomes:(NSSet *)values;
//@end
