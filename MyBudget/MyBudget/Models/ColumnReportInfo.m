/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 3/5/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "ColumnReportInfo.h"
#import "MOAccount.h"

@implementation ColumnReportInfo

@synthesize incomeValue;
@synthesize incomeColor;
@synthesize paymentValue;
@synthesize paymentColor;
@synthesize account;
@synthesize accountColor;

-(id)initWithIncome:(NSNumber*)income payment:(NSNumber*)payment account:(MOAccount*)anAccount {
    if ((self = [super init])) {
        self.incomeValue = income;
        self.paymentValue = payment;
        self.account = anAccount;
        self.incomeColor = [UIColor greenColor];
        self.paymentColor = [UIColor redColor];
        self.accountColor = [UIColor orangeColor];
    }
    return self;
}

-(void)dealloc {
    [incomeValue release];
    [incomeColor release];
    [paymentValue release];
    [paymentColor release];
    [account release];
    [accountColor release];
    [super dealloc];
}

@end
