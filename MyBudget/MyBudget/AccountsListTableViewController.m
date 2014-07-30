/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 2/9/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "AccountsListTableViewController.h"
#import "AccountViewController.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import "Constants.h"
#import "AccountDetailViewController.h"
#import "IncomeViewController.h"

#import "ListView.h"

/// negative amount alert view tag
#define ALERT_VIEW_TAG          1000

@implementation AccountsListTableViewController

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        NSSet* accountsNSSet = [MOUser instance].accounts;
        NSArray* tmpListOfIncomes = [[CoreDataManager sortSet:accountsNSSet byProperty:SORT_BY_NAME ascending:NO] retain];
        listOfItems = [[NSMutableArray alloc] initWithArray:tmpListOfIncomes];
        [tmpListOfIncomes release];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Accounts", nil);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) createSubsubTitleLabel:(NSInteger)index cell:(UITableViewCell *)cell {
}

-(void) addTitleAndSubtitle:(NSInteger) index cell:(UITableViewCell *) cell {
    [ListView addTitleAndSubtitleForAccount:[filteredItems objectAtIndex:index] cell:cell];
}

-(void) addStatusLabelText:(NSInteger) index cell:(UITableViewCell *) cell {    
}

/// creates table view cell amount label
-(void) createAmountLabel:(UITableViewCell *)cell index:(NSInteger)index {
    [ListView createAccountTypeLabel:cell filteredData:(MOAccount *)[filteredItems objectAtIndex:index] isInEditingMode:isInEditingMode];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)addEntity {
    AccountViewController * accountViewController = [[AccountViewController alloc] initWithTransfer:nil];
    accountViewController.title = NSLocalizedString(@"Account Details", nil);
    [self.navigationController pushViewController:accountViewController animated:YES];
    [accountViewController release];
}

-(void)updateEntity:(NSInteger)indexPathRow {
    AccountDetailViewController* accountDetailViewController = [[AccountDetailViewController alloc] initWithAccount:[filteredItems objectAtIndex:indexPathRow]];
    accountDetailViewController.delegate = self;
    accountDetailViewController.title = [[filteredItems objectAtIndex:indexPathRow] name];
    [self.navigationController pushViewController:accountDetailViewController animated:YES];
    [accountDetailViewController release];
}

-(void)selectAccount {
    if([delegate respondsToSelector:@selector(didSelectAccount:)]){
        [delegate didSelectAccount:account];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!isAccountSelected){
        [self updateEntity:indexPath.row];
    } else {
        account = [[filteredItems objectAtIndex:indexPath.row] retain];
        NSNumber* amount = account.amount;
        if ([amount doubleValue] < 0 && ![delegate isKindOfClass:[IncomeViewController class]]) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"The account is negative.", nil) message:NSLocalizedString(@"Do you really want to assign it?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:NSLocalizedString(@"NO", nil), nil];
            alertView.tag = ALERT_VIEW_TAG;
            [alertView show];
            [alertView release];
        } else {
            [self selectAccount];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_VIEW_TAG:
            if(buttonIndex == 0){
                [self selectAccount];
            }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

-(void) createToolbar {
    toolbarHeight = 0;
}

-(void) filterByMonth {
    NSSet* accountsNSSet = [MOUser instance].accounts;
    NSArray* tmpListOfIncomes = [[CoreDataManager sortSet:accountsNSSet byProperty:SORT_BY_NAME ascending:NO] retain];
    if (listOfItems) {
        [listOfItems release];
        listOfItems = nil;
    }
    listOfItems = [[NSMutableArray alloc] initWithArray:tmpListOfIncomes];
    filteredItems = [listOfItems retain];
    [tmpListOfIncomes release];
}

-(void)dealloc {
    if (account) {
        [account release];
    }
    [super dealloc];
}

@end
