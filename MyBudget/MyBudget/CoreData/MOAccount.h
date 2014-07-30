/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 2/13/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MOTransfer.h"

@class MOUser;

/// @brief MOAccount class. This class keeps all created accounts.
@interface MOAccount : MOTransfer

/// the account type (visa, savings, deby, etc.)
@property (nonatomic, retain) NSString * type;

/// the account amount
@property (nonatomic, retain) NSNumber * initialAmount;

/// the @ref MOUser object
@property (nonatomic, retain) MOUser *user;

@end
