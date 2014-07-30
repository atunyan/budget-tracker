/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/2/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MOTransfer.h"

@class MOUser;
@class MOCategory;
@class MOAccount;

/// The Payment class keeps the properties of the Payment. The class inherits from Transfer.
@interface MOPayment : MOTransfer

/// The user of the payment.
@property (nonatomic, retain) MOUser *user;

/// Payment category
@property (nonatomic, retain) MOCategory *category;

/// the date for firing reminder
@property (nonatomic, retain) NSDate* fireDate;

@end
