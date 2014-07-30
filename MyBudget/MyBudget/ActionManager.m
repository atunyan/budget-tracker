 /**
 *   @file 
 *   My Budget
 *
 *   Created by Arevik Tunyan on 23/04/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "ActionManager.h"
#import "Constants.h"
#import "CoreDataManager.h"
#import "MyBudgetHelper.h"
#import "MOAccount.h"
#import "MOUser.h"
#import "MOIncome.h"
#import "MOPayment.h"

/// name action sheet tag
#define ACTION_SHEET_NAME_TAG1         1000

/// name action sheet tag
#define ACTION_SHEET_NAME_TAG2         1001

@implementation ActionManager

+(void)cancelingNotificationForMO:(MOTransfer*)transfer {
    NSArray* notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification* localNotif in notifications) {
        NSString* stringID = [localNotif.userInfo objectForKey:LOCAL_NOTIF_OBJECT_ID];
        if (stringID) {
            NSURL *url = [NSURL URLWithString:stringID];
            NSManagedObjectID *moID = nil;
            @try {
                moID = [[[CoreDataManager instance].managedObjectContext persistentStoreCoordinator] managedObjectIDForURIRepresentation:url];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
                return;
            }
            @finally {
                NSLog(@"finally");
            }
            
            NSManagedObject *myOldMo = nil;
            if (moID) {
                myOldMo = [[CoreDataManager instance].managedObjectContext existingObjectWithID:moID error:nil];
            }
            
            if (myOldMo && [myOldMo isEqual:transfer]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
                break;
            }
        }
    }
}

+ (void)scheduleNotificationWithFireDate:(NSDate*)fireDate transfer:(MOTransfer *) transfer{
    // save, for getting managed object correct ID
    [[CoreDataManager instance] saveContext];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (!localNotif) {
        return;
    }
    if (fireDate) {
        localNotif.fireDate = fireDate;
    } else {
        localNotif.fireDate = [NSDate date];
        
        // for testing add 30 second
        //        localNotif.fireDate = [localNotif.fireDate dateByAddingTimeInterval:30];
    }
    
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    NSString* transferType = @"";
    if ([transfer isKindOfClass:[MOPayment class]]) {
        transferType = NSLocalizedString(@"Payment", nil);
    } else if ([transfer isKindOfClass:[MOIncome class]]) {
        transferType = NSLocalizedString(@"Income", nil);
    }
    
    localNotif.alertBody = [NSString stringWithFormat:@"%@ %@.", NSLocalizedString(@"Please take care of pending", nil), transferType];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    if ([transfer.isRecurring boolValue]) {
        if ([transfer.periodicity isEqualToString:PERIODICITY_DAILY]) {
            localNotif.repeatInterval = kCFCalendarUnitDay;
        } else if ([transfer.periodicity isEqualToString:PERIODICITY_WORKDAYS]) {
            localNotif.repeatInterval = kCFCalendarUnitWeekday;
        } else if ([transfer.periodicity isEqualToString:PERIODICITY_WEEKLY]) {
            localNotif.repeatInterval = kCFCalendarUnitWeek;
        } else if ([transfer.periodicity isEqualToString:PERIODICITY_MONTHLY]) {
            localNotif.repeatInterval = kCFCalendarUnitMonth;
        } else if ([transfer.periodicity isEqualToString:PERIODICITY_QUARTERLY]) {
            localNotif.repeatInterval = kCFCalendarUnitQuarter;
        } else {
            localNotif.repeatInterval = kCFCalendarUnitEra;
        }
    }
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
    
    NSManagedObjectID* moID = [transfer objectID];
    NSURL *uriID = [moID URIRepresentation];
    NSString *stringID = [uriID absoluteString];
	
    [infoDict setObject:stringID forKey:LOCAL_NOTIF_OBJECT_ID];
    
    localNotif.userInfo = infoDict;
    [infoDict release];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
}

+(BOOL) deleteNonRecurringItem:(MOTransfer *)transfer {
    NSAssert(1 >= [transfer.recurrings count], @"There should be only one recurring");
    for (MORecurrence* recurrence in transfer.recurrings) {
        if ([recurrence.isDone boolValue]) {
            transfer.account.amount = [NSNumber numberWithDouble:[transfer.account.amount doubleValue] - [recurrence.amount doubleValue]];
        }
        
        if ([[CoreDataManager instance] deleteData:recurrence alsoFromPersitentStore:YES]) {
            [transfer.recurrings removeObject:recurrence];
        }
    }
    [ActionManager cancelingNotificationForMO:transfer];
    [[CoreDataManager instance] deleteData:transfer alsoFromPersitentStore:YES];
    
    return YES;
}

+(BOOL) deleteTransfer:(MOTransfer *)transfer  view :(UIView*) view delegate :(id) delegate {
    if([transfer isKindOfClass:[MOAccount class]] && [[CoreDataManager instance] isAccountUsed:(MOAccount*)transfer]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"The account is used and you can not delete it", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return NO;
    }
    if ([transfer.isRecurring boolValue]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:delegate
                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Delete only this", nil), NSLocalizedString(@"Delete this and after all", nil), nil];
        actionSheet.tag = ACTION_SHEET_NAME_TAG1;
        [actionSheet showInView:view];
        [actionSheet release];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"Do you realy want to delete it?"
                                      delegate:delegate
                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Delete", nil), nil];
        actionSheet.tag = ACTION_SHEET_NAME_TAG2;
        [actionSheet showInView:view];
        [actionSheet release];
    }
    return NO;
}

+(void) removeAllRecurrings:(MOTransfer *) transfer date :(NSDate *) selectedMonth{
    NSArray* recurrings = [CoreDataManager sortSet:transfer.recurrings byProperty:SORT_BY_DATE_TIME ascending:YES];
    for (MORecurrence* recurrence in recurrings) {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"MMMM YYY"];
        if ([[formatter stringFromDate:selectedMonth] isEqualToString:[formatter stringFromDate:recurrence.dateTime]]) {
            if ([recurrence.isDone boolValue]) {
                transfer.account.amount = [NSNumber numberWithDouble:[transfer.account.amount doubleValue] - [recurrence.amount doubleValue]];
            }
          
            if ([[CoreDataManager instance] deleteData:recurrence alsoFromPersitentStore:YES]) {
                [transfer.recurrings removeObject:recurrence];
            }
        }
    }
    [ActionManager cancelingNotificationForMO:transfer];
    [[CoreDataManager instance] deleteData:transfer alsoFromPersitentStore:YES];
}


+(BOOL) deleteRecurrencesOf:(MOTransfer *) transfer 
                    index :(NSInteger) buttonIndex 
                     date :(NSDate *) selectedMonth {
    
    if (0 == buttonIndex) {
        MORecurrence* recurrence = [MyBudgetHelper recurrenceByDate:selectedMonth transfer:transfer withFormatter:DATE_FORMAT_MONTH];
        if ([recurrence.isDone boolValue]) {
            transfer.account.amount = [NSNumber numberWithDouble:[transfer.account.amount doubleValue] - [recurrence.amount doubleValue]];
        }
        
        NSLog(@"BOOL vaule: %d", [[CoreDataManager instance] deleteData:recurrence alsoFromPersitentStore:YES] ? 1 : 0);
        
        if ([[CoreDataManager instance] deleteData:recurrence alsoFromPersitentStore:YES]) {
            [transfer.recurrings removeObject:recurrence];

            // if there is no recurrences, then delete transfer
            if ([transfer.recurrings count] == 0) {
                [ActionManager cancelingNotificationForMO:transfer];
                [[CoreDataManager instance] deleteData:transfer alsoFromPersitentStore:YES];
            }
            return YES;
        } else {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"There is problem while deleting Payment.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
    } else if (1 == buttonIndex) {
        [ActionManager removeAllRecurrings:transfer date:selectedMonth];
        return YES;
    }
    return NO;
}

+(void)addRecurring:(NSDate*)date 
             amount:(NSNumber*)amount 
             isDone:(BOOL)isDone 
           transfer:(MOTransfer *) transfer {
    MORecurrence* reccurring = [[CoreDataManager instance] recurring];
    reccurring.amount = amount;
    reccurring.dateTime = date;
    reccurring.isDone = [NSNumber numberWithBool:isDone];
    reccurring.transfer = transfer;
    [transfer.recurrings addObject:reccurring];
}


+(void)updateAccountAmount:(MOTransfer *)transfer {
    transfer.account.amount = [NSNumber numberWithDouble:([transfer.account.amount doubleValue] + [transfer.amount doubleValue])];
}

+(BOOL)isUpdatedAccountAmountByNow:(NSDate*)now andByDateTime:(NSDate*)dateTime
                     andByFireDate:(NSDate*)fireDate
                         transfer :(MOTransfer *) transfer {
    NSDate* nowByDay = [MyBudgetHelper dayFromDate:now];
    
    if ([nowByDay compare:dateTime] == NSOrderedDescending) {
        [ActionManager updateAccountAmount:transfer];
        return YES;
    } else if ([nowByDay compare:dateTime] == NSOrderedSame) {
        if (fireDate) {
            NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:now];
            NSInteger nowHour = [nowComponents hour];
            NSInteger nowMinute = [nowComponents minute];
            NSInteger nowSecond = [nowComponents second];
            
            NSDateComponents *fireComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:fireDate];
            NSInteger fireHour = [fireComponents hour];
            NSInteger fireMinute = [fireComponents minute];
            NSInteger fireSecond = [fireComponents second];
            
            if (nowHour > fireHour || (nowHour == fireHour && nowMinute > fireMinute) || (nowHour == fireHour && nowMinute == fireMinute && nowSecond > fireSecond)) {
                [ActionManager updateAccountAmount:transfer];
                return YES;
            }
        } else {
            [ActionManager updateAccountAmount:transfer];
            return YES;
        }
    }
    return NO;
}

+(void)addRecurringsBySelectedDate:(NSDate*)fireDate 
                          transfer:(MOTransfer *) transfer {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_STYLE];
    
    NSDate* dateTime = fireDate ? fireDate : transfer.dateTime;
    
    NSDate* now = [NSDate date];
    
    if ([[transfer isRecurring] boolValue] == YES) {
        while ([dateTime compare:transfer.endDate] != NSOrderedDescending) {
            if ([transfer.periodicity isEqualToString:PERIODICITY_WORKDAYS]) {
                int weekday = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:dateTime] weekday];
                if (weekday != 1 && weekday != 7) {
                    BOOL isDone = [ActionManager isUpdatedAccountAmountByNow:now andByDateTime:dateTime andByFireDate:dateTime transfer:transfer];
                    [ActionManager addRecurring:dateTime amount:transfer.amount isDone:isDone transfer:transfer];
                }
                dateTime = [dateTime dateByAddingTimeInterval:60 * 60 * 24];
            } else {
                BOOL isDone = [ActionManager isUpdatedAccountAmountByNow:now andByDateTime:dateTime andByFireDate:dateTime transfer:transfer];
                [ActionManager addRecurring:dateTime amount:transfer.amount isDone:isDone transfer:transfer];
                
                if ([transfer.periodicity isEqualToString:PERIODICITY_DAILY]) {
                    dateTime = [dateTime dateByAddingTimeInterval:60 * 60 * 24];
                } else if ([transfer.periodicity isEqualToString:PERIODICITY_WEEKLY]) {
                    dateTime = [dateTime dateByAddingTimeInterval:60 * 60 * 24 * 7];
                } else if ([transfer.periodicity isEqualToString:PERIODICITY_MONTHLY]) {
                    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
                    components.month = 1;
                    dateTime = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:dateTime options:0];
                } else if ([transfer.periodicity isEqualToString:PERIODICITY_QUARTERLY]) {
                    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
                    components.month = 3;
                    dateTime = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:dateTime options:0];
                }
            }
        }
    } else {
        BOOL isDone = [self isUpdatedAccountAmountByNow:now andByDateTime:dateTime andByFireDate:dateTime transfer:transfer];
        [ActionManager addRecurring:dateTime amount:transfer.amount isDone:isDone transfer:transfer];
    }
    [formatter release];
}

+(void) addToAccount:(MOTransfer *) transfer selectedDate :(NSDate *) selectedDate {
    MORecurrence* recurrence = [MyBudgetHelper recurrenceByDate:selectedDate transfer:transfer withFormatter:DATE_FORMAT_STYLE];
    if (![recurrence.isDone boolValue]) {
        recurrence.isDone = [NSNumber numberWithBool:YES];
        transfer.account.amount = [NSNumber numberWithDouble:[transfer.account.amount doubleValue] + [recurrence.amount doubleValue]];
    }    
    [[CoreDataManager instance] saveContext];
}

+(NSNumber *) totalAmountOfAccountPayments:(MOAccount *) currentAccount {
    NSSet* paymentsSet = [MOUser instance].payments;
    NSArray* accountPaymentsArray = [[CoreDataManager subSetOf:paymentsSet filteredByAccount:currentAccount] allObjects];
    
    double amount = 0.00;
    for (MOTransfer* transfer in accountPaymentsArray) {
        amount += [[CoreDataManager sumAmountOfDoneSet:transfer.recurrings] doubleValue];
    }
    return [NSNumber numberWithDouble:amount];
}

+(NSNumber *) totalAmountOfAccountIncomes:(MOAccount *) currentAccount {
    NSSet* incomesSet = [MOUser instance].incomes;
    NSArray* accountIncomesArray = [[CoreDataManager subSetOf:incomesSet filteredByAccount:currentAccount] allObjects];
    
    double amount = 0.00;
    for (MOTransfer* transfer in accountIncomesArray) {
        amount += [[CoreDataManager sumAmountOfDoneSet:transfer.recurrings] doubleValue];
    }
    return [NSNumber numberWithDouble:amount];
}

@end
