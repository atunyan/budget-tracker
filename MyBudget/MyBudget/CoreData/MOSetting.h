/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/8/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOUser;
@class MOReport;

/**
 * @brief describes user's settings
 */
@interface MOSetting : NSManagedObject

/// current currency
@property (nonatomic, retain) NSString * currency;

/// current language
@property (nonatomic, retain) NSString * language;

/// current start screen
@property (nonatomic, retain) NSString * startScreen;

/// month start date
@property (nonatomic, retain) NSString *monthStartDate;

/// month start date
@property (nonatomic, retain) NSString *deleteAfterMonths;

/// Report view
@property (nonatomic, retain) MOReport *report;

/// Settings's User
@property (nonatomic, retain) MOUser *user;

/// The default color of the app.
@property (nonatomic, retain) NSData* defaultColor;

@end
