/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 1/12/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "IncomesListTableViewController.h"
#import "IncomeViewController.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import "MORecurrence.h"
#import "ListView.h"

@implementation IncomesListTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Get data from database
        NSSet* incomesSet = [[MOUser instance].incomes retain];

        NSArray* tmpListOfIncomes = [[CoreDataManager sortSet:incomesSet byProperty:SORT_BY_DATE_TIME ascending:NO] retain];
        listOfItems = [[NSMutableArray alloc] initWithArray:tmpListOfIncomes];
        [tmpListOfIncomes release];
        
        dataSource = [[TransferDataSource alloc] initWithItems:incomesSet];
        [incomesSet release];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Incomes", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [tableView reloadData];
}

#pragma mark - Table view data source

#pragma mark - target methods

-(void)addEntity {
    IncomeViewController* incomeViewController = [[IncomeViewController alloc] initWithTransfer:nil isOpenedFromCalendar:NO];
    if (!kalViewController.view.hidden) {
        incomeViewController.initialDate = kalViewController.selectedDate;
    }
    incomeViewController.title = NSLocalizedString(@"Add Income", nil);
    incomeViewController.delegate = self;
    [self.navigationController pushViewController:incomeViewController animated:YES];
    [incomeViewController release];
}

-(void)updateEntity:(NSInteger)indexPathRow {
    IncomeViewController * incomeViewController;
    if (!kalViewController.view.hidden) {
        incomeViewController = [[IncomeViewController alloc] initWithTransfer:[dataSource.itemsSelectedByDay objectAtIndex:indexPathRow] isOpenedFromCalendar:YES];
        incomeViewController.selectedDate = kalViewController.selectedDate;
    } else {
        incomeViewController = [[IncomeViewController alloc] initWithTransfer:[filteredItems objectAtIndex:indexPathRow] isOpenedFromCalendar:NO];
        incomeViewController.selectedDate = selectedMonth;
    }
    incomeViewController.delegate = self;
    incomeViewController.title = NSLocalizedString(@"Income Details", nil);
    [self.navigationController pushViewController:incomeViewController animated:YES];
    [incomeViewController release];
}

-(void) addTitleAndSubtitle:(NSInteger) index cell:(UITableViewCell *) cell {
    [ListView addTitleAndSubtitleForIncome:[filteredItems objectAtIndex:index] cell:cell accordingDate:selectedMonth];
}

-(void) addAccountLabelText:(NSInteger) index cell:(UITableViewCell *) cell {
    [ListView addAccountLabelText:[filteredItems objectAtIndex:index] cell:cell isInEditingMode:isInEditingMode];
}

-(void) createLocationLabel:(NSInteger)index cell:(UITableViewCell *)cell{
}

-(void) createSubsubTitleLabel:(NSInteger)index cell:(UITableViewCell *)cell {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

-(void) filterByMonth {
    [filteredItems removeAllObjects];
    for (MOIncome* income in listOfItems) {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"MMMM YYYY"];
        
        NSArray* recurrings = [CoreDataManager sortSet:income.recurrings byProperty:SORT_BY_DATE_TIME ascending:YES];
        for (MORecurrence* recurrence in recurrings) {
            if ([[formatter stringFromDate:selectedMonth] isEqualToString:[formatter stringFromDate:recurrence.dateTime]]) {
                [filteredItems addObject:income];
                break;
            }
        }
    }
}

@end
