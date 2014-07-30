/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 02/01/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * @brief The class contains the info on Reminder, such as reminder time, 
 * whether alerts and/or budgets should be shown or no.
 */
@interface ReminderInfo : NSObject {    
    
    NSDate* reminderTime;
    
    NSString* periodicity;
    
    NSDate* endDateTime;
}

/// The date and time of the reminder.
@property (nonatomic, retain) NSDate* reminderTime;

/// The reminder periodicity.
@property (nonatomic, assign) NSString* periodicity;

/// The end date of the periodicity.
@property (nonatomic, retain) NSDate* endDateTime;

/**
 * @brief the possible period values
 * @return - the list of periods.
 */
+(NSArray *) possiblePeriods;

@end
