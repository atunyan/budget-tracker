/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 02/01/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "ReminderInfo.h"
#import "Constants.h"

@implementation ReminderInfo
@synthesize reminderTime;
@synthesize periodicity;
@synthesize endDateTime;


-(id) init {
    self = [super init];
    if (self) {
        reminderTime = [[NSDate alloc] init];
        periodicity = [[ReminderInfo possiblePeriods] objectAtIndex:0];
    }
    return self;
}

+(NSArray *) possiblePeriods {
    return [[[NSArray alloc] initWithObjects:PERIODICITY_DAILY,
                         PERIODICITY_WORKDAYS, PERIODICITY_WEEKLY, PERIODICITY_MONTHLY, PERIODICITY_QUARTERLY, nil] autorelease];
}

-(void) dealloc {
    [reminderTime release];
    [super dealloc];
}

@end
