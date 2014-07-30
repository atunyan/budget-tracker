/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/10/12.
 *   Copyright (c) 2012 MyBudget. All rights reserved.
 *
 */

#import "Kal.h"
#import <dispatch/dispatch.h>

/**
 * @brief This class is responsible for displaying all items with Calendar view.
 */
@interface TransferDataSource : NSObject <KalDataSource>
{
    NSMutableArray *itemsSelectedByDay;
    
    NSMutableArray *allItems;
    
    NSSet* rawItems;
}

/// The list of items corresponding to the currently selected day in the calendar. These items are used to configure cells vended by the UITableView below the calendar month view.
@property (nonatomic, retain) NSMutableArray* itemsSelectedByDay;

/// The list of all objects (sorted by date) corresponding the specified user.
@property (nonatomic, retain) NSMutableArray* allItems;

/// The set of all raw (not sorted) objects corresponding the specified user. 
@property (nonatomic, retain) NSSet* rawItems;

/**
 @brief  Initialized object with raw items
 @param aRawItems - raw items
 @return - initialized object
 */
- (id)initWithItems:(NSSet*)aRawItems;

/// Returns new allocated dataSource pointer.
+ (TransferDataSource *)dataSource;

@end
