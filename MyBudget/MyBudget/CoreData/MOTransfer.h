/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 4/3/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOAccount; 

/// Used as parent class for income, payment, account managed objects
@interface MOTransfer : NSManagedObject

/// amount
@property (nonatomic, retain) NSNumber * amount;

/// date time
@property (nonatomic, retain) NSDate * dateTime;

/// location (for payments)
@property (nonatomic, retain) NSData * location;

/// name
@property (nonatomic, retain) NSString * name;

/// description
@property (nonatomic, retain) NSString * moDescription;

/// end date (for recurring objects)
@property (nonatomic, retain) NSDate * endDate;

/// Shows whether the object is recurring or no
@property (nonatomic, retain) NSNumber * isRecurring;

/// The periodicity of specific object
@property (nonatomic, retain) NSString* periodicity;

/// Transfer recurrings
@property (nonatomic, retain) NSMutableSet* recurrings;

/// Transfer account 
@property (nonatomic, retain) MOAccount* account;

@end
