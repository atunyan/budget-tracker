/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 02/01/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "PaymentSettings.h"

@implementation PaymentSettings

@synthesize isCalendarView;
@synthesize isRecurringPayment;
@synthesize reminderInfo;

-(id) init {
    self = [super init];
    if (self) {
        isCalendarView = YES;
        isRecurringPayment = NO;
        reminderInfo = [[ReminderInfo alloc] init];
    }
    return self;
}

-(void) dealloc {
    [reminderInfo release];
    [super dealloc];
}

@end
