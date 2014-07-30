/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 2/10/12.
 *  Copyright (c) 2012 MyBudget. All rights reserved.
 *
 */

#import "PaymentsListViewController.h"
#import "PaymentViewController.h"
#import "Constants.h"
#import "UserInfo.h"
#import "LoginViewController.h"
#import "CoreDataManager.h"
#import "MOCategory.h"
#import "MOSetting.h"
#import "MOPayment.h"
#import "MOUser.h"
#import "MORecurrence.h"
#import "ListView.h"

#import <QuartzCore/QuartzCore.h>

/// tag for displaying the icon imageView
#define ICON_IMAGEVIEW_TAG 100

/// tag for displaying the category name label
#define CATEGORY_NAME_LABEL_TAG 101

@implementation PaymentsListViewController

#pragma mark - View lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        // Get data from database        
        NSSet* paymentsSet = [MOUser instance].payments;
        NSArray* tmpPaymentsArray = [[CoreDataManager sortSet:paymentsSet byProperty:SORT_BY_DATE_TIME ascending:NO] retain];
        listOfItems = [[NSMutableArray alloc] initWithArray:tmpPaymentsArray];
        [tmpPaymentsArray release];
        
        dataSource = [[TransferDataSource alloc] initWithItems:paymentsSet];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Payments", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableView reloadData];
}

-(void) addTitleAndSubtitle:(NSInteger) index cell:(UITableViewCell *) cell {
    [ListView addTitleAndSubtitleForPayment:[filteredItems objectAtIndex:index] cell:cell];
}

-(void) addAccountLabelText:(NSInteger) index cell:(UITableViewCell *) cell {
    [ListView addAccountLabelText:[filteredItems objectAtIndex:index] cell:cell isInEditingMode:isInEditingMode];
}

#pragma mark - target methods

/// the target method, wich calls when need to add/change payment
-(void)addEntity {
    PaymentViewController * paymentViewController = [[PaymentViewController alloc] initWithTransfer:nil isOpenedFromCalendar:NO];
    if (!kalViewController.view.hidden) {
        paymentViewController.initialDate = kalViewController.selectedDate;
    }
    paymentViewController.title = NSLocalizedString(@"Add Payment", nil);
    paymentViewController.delegate = self;
    [self.navigationController pushViewController:paymentViewController animated:YES];
    [paymentViewController release];
}

/// the target method, wich calls when need to add/change payment
-(void)updateEntity:(NSInteger)indexPathRow {
    PaymentViewController * paymentViewController;
    if (!kalViewController.view.hidden) {
        paymentViewController = [[PaymentViewController alloc] initWithTransfer:[dataSource.itemsSelectedByDay objectAtIndex:indexPathRow] isOpenedFromCalendar:YES];
        paymentViewController.selectedDate = kalViewController.selectedDate;
    } else {
        paymentViewController = [[PaymentViewController alloc] initWithTransfer:[filteredItems objectAtIndex:indexPathRow] isOpenedFromCalendar:NO];
        paymentViewController.selectedDate = selectedMonth;
    }
    paymentViewController.delegate = self;
    paymentViewController.title = BILL_PAGE_TITLE;
    [self.navigationController pushViewController:paymentViewController animated:YES];
    [paymentViewController release];
}

#pragma mark - drawing methods

/// create table view category name label
-(void)createNameLabel:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    UILabel* categoryName = (UILabel *) [cell.contentView viewWithTag:(indexPath.row + CATEGORY_NAME_LABEL_TAG)];
    if (!categoryName) {
        categoryName = [[[UILabel alloc] initWithFrame:CGRectMake(30, cell.contentView.frame.origin.y, cell.contentView.frame.size.width - 200, cell.contentView.frame.size.height)] autorelease];
        categoryName.textColor = [UIColor blackColor];
        categoryName.font = [UIFont boldSystemFontOfSize:14.0];
        categoryName.tag = indexPath.row + CATEGORY_NAME_LABEL_TAG;
    }
    MOCategory* category = ((MOPayment*)[filteredItems objectAtIndex:indexPath.row]).category;
    
    categoryName.text = category.name;
    [cell.contentView addSubview:categoryName];
}

-(void) filterByMonth {
    [filteredItems removeAllObjects];
    for (MOPayment* payment in listOfItems) {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"MMMM YYYY"];
        
        NSArray* recurrings = [CoreDataManager sortSet:payment.recurrings byProperty:SORT_BY_DATE_TIME ascending:YES];
        for (MORecurrence* recurrence in recurrings) {
            if ([[formatter stringFromDate:selectedMonth] isEqualToString:[formatter stringFromDate:recurrence.dateTime]]) {
                [filteredItems addObject:payment];
                break;
            }
        }
    }
}

@end
