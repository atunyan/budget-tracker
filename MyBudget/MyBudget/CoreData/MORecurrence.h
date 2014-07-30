/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 3/15/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOTransfer;

/// Describes payment's recurring
@interface MORecurrence : NSManagedObject

/// recurring date time
@property (nonatomic, retain) NSDate * dateTime;

/// recurring amount
@property (nonatomic, retain) NSNumber * amount;

/// indicates is recurrance payed or not
@property (nonatomic, retain) NSNumber * isDone;

/// transfer
@property (nonatomic, assign) MOTransfer *transfer;

@end
