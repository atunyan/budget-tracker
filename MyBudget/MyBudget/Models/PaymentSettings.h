/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 02/01/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "ReminderInfo.h"

/// Tha class keeps the settings of the payment
@interface PaymentSettings : NSObject {
    BOOL isCalendarView;
    BOOL isRecurringPayment;
    ReminderInfo* reminderInfo;
}

/// Shows whether the Payments page is in calendarView or listing view.
@property (nonatomic, assign) BOOL isCalendarView;

/// Shows whether the payment is recurring or no.
@property (nonatomic, assign) BOOL isRecurringPayment;

/// The reminderInfo of specific payment.
@property (nonatomic, retain) ReminderInfo* reminderInfo;

@end
