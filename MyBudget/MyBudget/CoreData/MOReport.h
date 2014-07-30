/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/27/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOSetting;

/// Describes report views
@interface MOReport : NSManagedObject

/// Report period
@property (nonatomic, retain) NSNumber * period;

/// Report represantation (view style)
@property (nonatomic, retain) NSNumber * representation;

/// Report start date
@property (nonatomic, retain) NSDate* startDate;

/// Report end date
@property (nonatomic, retain) NSDate* endDate;

/// User settings
@property (nonatomic, retain) MOSetting *setting;


@end
