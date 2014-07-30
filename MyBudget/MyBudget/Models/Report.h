/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class MOUser;

///class  represents data source  for  report preview
@interface Report : NSObject{
    NSMutableArray* incomeArray;
    NSMutableArray* paymentArray;
    NSMutableArray* dateArray;
    NSMutableArray* accountArray;
}

///data  for  income
@property (nonatomic, retain) NSMutableArray* incomeArray;

/// source data for payment graphic
@property (nonatomic, retain) NSMutableArray* paymentArray;

/// source data for dates
@property (nonatomic, retain) NSMutableArray* dateArray;

/// source data for accounts
@property (nonatomic, retain) NSMutableArray* accountArray;

/// inits  with current user
-(id)initWithData:(MOUser*)user;

/// addes dates to the dateArray
-(void)prepareDateArray;

/// returns  the name  of month before current  month   with  monthDistance time
-(NSString*)monthNameBefore:(int)monthDistance;

/**
 * @brief  returns period text from start date to end date
 * @param startDate - start date
 * @param endDate - end date
 * @return - period text
 */
-(NSString*)periodFromStartDate:(NSDate*)startDate toEndDate:(NSDate*)endDate;

@end
