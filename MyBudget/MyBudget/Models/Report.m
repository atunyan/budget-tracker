/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "Report.h"
#import "MOUser.h"
#import "CoreDataManager.h"
#import "MOIncome.h"
#import "MOSetting.h"
#import "Constants.h"
#import "MOPayment.h"
#import "MORecurrence.h"
#import "MOReport.h"

@implementation Report

@synthesize incomeArray;
@synthesize paymentArray;
@synthesize dateArray;
@synthesize accountArray;

-(void)prepareDateArray {
    int startDate = [[MOUser instance].setting.monthStartDate intValue];
    
    dateArray = [[NSMutableArray alloc] init];
    
    NSDate *curDate = [MOUser instance].setting.report.endDate;    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:curDate];
    NSDateComponents *monthComp = [gregorian components:NSMonthCalendarUnit fromDate:[MOUser instance].setting.report.startDate toDate:[MOUser instance].setting.report.endDate options:0];

    [comp setMonth:[comp month] - 1];
    [dateArray addObject:curDate];
    [comp setDay:startDate];
    for (int i = 0; i < [monthComp month]; ++i) {
        NSDate* date = [gregorian dateFromComponents:comp];
        if (i == 0) {
//            date = [date dateByAddingTimeInterval:60 * 60 * 24 * -1];
        }         
        [dateArray addObject:date];
        [comp setMonth:[comp month] - 1];
    }
    [dateArray addObject:[MOUser instance].setting.report.startDate];
    [gregorian release];
    
}

-(void)prepareAccounts:(MOUser*)user{
    accountArray = [[NSMutableArray alloc] init];
}

-(void)prepareIncomes:(MOUser*) user{
    incomeArray = [[NSMutableArray alloc] init];
    for (int i  =  0; i < [dateArray count]; ++i) {
        NSNumber* sum = [NSNumber numberWithDouble:0];
        for (MOIncome* income in user.incomes) {
            NSNumber* recurranceSum = [CoreDataManager sumAmountOfRecurrings:income.recurrings fromStartDate:[dateArray objectAtIndex: (([dateArray count] > 1 && i < [dateArray count] - 1) ? (i + 1) : i)] toEndDate:[dateArray objectAtIndex:i]];
            sum = [NSNumber numberWithDouble:([sum doubleValue] + [recurranceSum doubleValue])];
        }
        [incomeArray addObject:sum];
    }
}

-(void)preparePayments:(MOUser*)user{
    paymentArray = [[NSMutableArray alloc] init];
    for (int i  =  0; i < [dateArray count]; ++i) {
        NSNumber* sum = [NSNumber numberWithDouble:0];
        for (MOPayment* payment in user.payments) {
            NSNumber* recurranceSum = [CoreDataManager sumAmountOfRecurrings:payment.recurrings fromStartDate:[dateArray objectAtIndex:(i < [dateArray count] - 1)  ? (i + 1) : i ] toEndDate:[dateArray objectAtIndex:i]];
            sum = [NSNumber numberWithDouble:([sum doubleValue] + [recurranceSum doubleValue] * (-1))];
        }
        [paymentArray addObject:sum];
    }
}

-(NSString*)monthNameBefore:(int)monthDistance {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
    NSString *stringFromDate = [formatter stringFromDate:[dateArray objectAtIndex:([dateArray count] == 1 ? monthDistance - 1 : monthDistance)]];
    [formatter release];
    return stringFromDate;
}

-(NSString*)periodFromStartDate:(NSDate*)startDate toEndDate:(NSDate*)endDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy MMMM dd"];
    NSString *start = [formatter stringFromDate:startDate];
    NSString *end = [formatter stringFromDate:endDate];
    [formatter release];
    
    NSString* period = [NSString stringWithFormat:@"%@ - %@", start, end];
    return period;
}

-(id)initWithData:(MOUser*)user {
    self = [super init];
    if (self) {
        [self prepareDateArray];
        [self prepareIncomes:user];
        [self preparePayments:user];
        [self prepareAccounts:user];
    }
    return self;
}

-(void)dealloc {
    [dateArray release];
    [incomeArray release];
    [paymentArray release];
    [super dealloc];
}

@end
