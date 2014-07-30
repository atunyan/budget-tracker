/**
 *   TransferDataSource.h
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/10/12.
 *   Copyright (c) 2012 MyBudget. All rights reserved.
 *
 */

#import "TransferDataSource.h"
#import "CoreDataManager.h"
#import "Constants.h"
#import "MOTransfer.h"
#import "MOIncome.h"
#import "MOPayment.h"
#import "MORecurrence.h"

static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
    return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

/**
 * @brief The interface declaration of @ref TransferDataSource class, 
 * for declaring the private members.
 */
@interface TransferDataSource ()

/**
 * @brief  Filters items for the specified range.
 * @param fromDate - start date
 * @param toDate - end date
 * @return - returns an filtered array of items specified for the range.
 */
- (NSArray *)itemsFrom:(NSDate *)fromDate to:(NSDate *)toDate;

/**
 * @brief  Marks the dates for the specified range in calendar view.
 * @param fromDate - start date
 * @param toDate - end date
 * @return - returns an array of marked items specified for the range.
 */
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;

@end

@implementation TransferDataSource

@synthesize itemsSelectedByDay;
@synthesize allItems;
@synthesize rawItems;

+ (TransferDataSource *)dataSource
{
    return [[[[self class] alloc] init] autorelease];
}

- (id)initWithItems:(NSSet*)aRawItems
{
    if ((self = [super init])) {
        allItems = [[NSMutableArray alloc] init];
        itemsSelectedByDay = [[NSMutableArray alloc] init];
        self.rawItems = aRawItems;
    }
    return self;
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"      %@", [[itemsSelectedByDay objectAtIndex:indexPath.row] name]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemsSelectedByDay count];
}

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    // asynchronous callback on the main thread
    [allItems removeAllObjects];
    NSArray* tmpTransferArray = [[CoreDataManager sortSet:rawItems byProperty:SORT_BY_DATE_TIME ascending:NO] retain];
    [allItems setArray:tmpTransferArray];
    [tmpTransferArray release];
    [delegate loadedDataSource:self];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    // synchronous callback on the main thread
    NSMutableArray *matches = [NSMutableArray array];
    NSArray* transferArray = [self itemsFrom:fromDate to:toDate];
    for (MOTransfer *transfer in transferArray) {
        NSArray* recurrings = [transfer.recurrings allObjects];
        
        for (MORecurrence* recurrence in recurrings) {
            if (IsDateBetweenInclusive(recurrence.dateTime, fromDate, toDate)) {
                [matches addObject:recurrence.dateTime];
            }
        }
    }
    
    return matches;
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    // synchronous callback on the main thread
    NSArray* transferArray = [self itemsFrom:fromDate to:toDate];
    for (MOTransfer *transfer in transferArray) {
        NSArray* recurrings = [transfer.recurrings allObjects];
        for (MORecurrence* recurrence in recurrings) {
            if (IsDateBetweenInclusive(recurrence.dateTime, fromDate, toDate)) {
                [itemsSelectedByDay addObject:transfer];
                break;
            }
        }
    }
}

- (void)removeAllItems
{
    // synchronous callback on the main thread
    [itemsSelectedByDay removeAllObjects];
}

#pragma mark -
- (NSArray *)itemsFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    NSMutableArray *matches = [NSMutableArray array];
    for (MOTransfer *transfer in allItems) {
        NSArray* recurrings = [transfer.recurrings allObjects];
        for (MORecurrence* recurrence in recurrings) {
            if (IsDateBetweenInclusive(recurrence.dateTime, fromDate, toDate)) {
                [matches addObject:transfer];
                break;
            }
        }
    }
    
    return matches;
}

- (void)dealloc
{
    [itemsSelectedByDay release];
    [allItems release];
    [rawItems release];
    [super dealloc];
}

@end
