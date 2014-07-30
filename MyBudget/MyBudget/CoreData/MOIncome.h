/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/26/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MOTransfer.h"

@class MOUser;
@class MOAccount;

/**
 * @brief The class keeps the properties of Core Data Income, which are describing income, such as income's amount, name.
 */
@interface MOIncome : MOTransfer

/// Income User
@property (nonatomic, retain) MOUser *user;


@end
