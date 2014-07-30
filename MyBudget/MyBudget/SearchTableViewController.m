/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 29.02.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "SearchTableViewController.h"
#import "SearchData.h"
#import "MOUser.h"
#import "MOIncome.h"
#import "MOPayment.h"
#import "MOAccount.h"
#import "MOCategory.h"
#import "SearchManager.h"
#import "IncomeViewController.h"
#import "PaymentViewController.h"
#import "CategoryViewController.h"
#import "AccountDetailViewController.h"
#import "CoreDataManager.h"
#import "Constants.h"

#import "SearchSettingsTableViewController.h"
#import "ListView.h"

#import <QuartzCore/QuartzCore.h>


@implementation SearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        searchData = [SearchData instance];
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

-(void) openSettingsPage:(UIButton *) sender {
    SearchSettingsTableViewController* settingsView = [[SearchSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:settingsView animated:YES];      
    [settingsView release];
}

-(void) createSearchBar:(UIView *) headerView {
    if (searchBar) {
        [searchBar release]; 
        searchBar = nil;
    }
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    searchBar.delegate = self;
    searchBar.tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
    
    searchBar.placeholder = NSLocalizedString(@"Search", nil);
    
    [headerView addSubview:searchBar];
        
    if (lsearchController) {
        [lsearchController release];
        lsearchController = nil;
    }
    lsearchController = [[UISearchDisplayController alloc]
                         initWithSearchBar:searchBar contentsController:self];
    lsearchController.delegate = self;
    lsearchController.searchResultsDataSource = self;	
    lsearchController.searchResultsDelegate = self;    
}


/// creates pay bar button
-(void) createSettingsButton {
    UIBarButtonItem* settingsBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Refine", nil) style:UIBarButtonItemStyleDone target:self action:@selector(openSettingsPage:)];
    self.navigationItem.rightBarButtonItem = settingsBarButton;
    [settingsBarButton release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Search", nil);
    [self createSettingsButton];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 45)];
    self.tableView.tableHeaderView = headerView;
    [self createSearchBar:self.tableView.tableHeaderView];

    [headerView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) filterSearchLists {
    if (incomeFilteredData) {
        [incomeFilteredData release];
        incomeFilteredData = nil;
    }
    incomeFilteredData = [[SearchManager listFilteredByKeyword:searchBar.text array:searchData.searchIncomesList] retain];
    
    if (paymentFilteredData) {
        [paymentFilteredData release];
        paymentFilteredData = nil;
    }
    paymentFilteredData = [[SearchManager listFilteredByKeyword:searchBar.text array:searchData.searchPaymentsList] retain];
    
    if (accountFilteredData) {
        [accountFilteredData release];
        accountFilteredData = nil;
    }
    accountFilteredData = [[SearchManager listFilteredByKeyword:searchBar.text array:searchData.searchAccountsList] retain];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[SearchData instance] initializeSearchLists];
    [self filterSearchLists];
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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
} 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [incomeFilteredData count]; 
        case 1:
            return [paymentFilteredData count];  
        case 2:
            return [accountFilteredData count];  
        default:
            break;
    }
    return 0;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if ([incomeFilteredData count] > 0) {
                return NSLocalizedString(@"Incomes", nil); 
            }
            break;
        case 1:
            if ([paymentFilteredData count] > 0) {
                return NSLocalizedString(@"Payments", nil);
            }
            break;
        case 2:
            if ([accountFilteredData count] > 0) {
                return NSLocalizedString(@"Accounts", nil);
            }
            break;
        default:
            break;
    }
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"IncomeCell";
    static NSString *CellIdentifier3 = @"PaymentCell";
    static NSString *CellIdentifier4 = @"AccountCell";

    UITableViewCell *cellIncome = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cellIncome == nil) {
        cellIncome = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
        cellIncome.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        cellIncome.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cellIncome.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        [ListView createAccountLabel:cellIncome];
        [ListView createTitleLabel:cellIncome];
        [ListView createSubtitleLabel:cellIncome];
        [ListView createStatusLabel:cellIncome];
    }
    UITableViewCell *cellPayment = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
    if (cellPayment == nil) {
        cellPayment = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3] autorelease];
        cellPayment.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        cellPayment.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cellPayment.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        [ListView createAccountLabel:cellPayment];
        [ListView createTitleLabel:cellPayment];
        [ListView createSubtitleLabel:cellPayment];
        [ListView createStatusLabel:cellPayment];
    }
    UITableViewCell *cellAccount = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
    if (cellAccount == nil) {
        cellAccount = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier4] autorelease];
        cellAccount.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        cellAccount.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cellAccount.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        [ListView createAccountLabel:cellAccount];
        [ListView createTitleLabel:cellAccount];
        [ListView createSubtitleLabel:cellAccount];
    }
    switch (indexPath.section) {
        case 0:
            [ListView createAmountLabel:cellIncome filteredData:[incomeFilteredData objectAtIndex:indexPath.row] isInEditingMode:NO accordingDate:((MOIncome *)[incomeFilteredData objectAtIndex:indexPath.row]).dateTime];
            [ListView addTitleAndSubtitleForIncome:[incomeFilteredData objectAtIndex:indexPath.row] cell:cellIncome accordingDate:((MOIncome *)[incomeFilteredData objectAtIndex:indexPath.row]).dateTime];
            [ListView addAccountLabelText:[incomeFilteredData objectAtIndex:indexPath.row] cell:cellIncome isInEditingMode:NO];
            [ListView addStatusLabelText:[incomeFilteredData objectAtIndex:indexPath.row] cell:cellIncome isInEditingMode:NO selectedDate:((MOIncome *)[incomeFilteredData objectAtIndex:indexPath.row]).dateTime];
            return cellIncome;
        case 1:
            [ListView createSubsubTitleLabel:[paymentFilteredData objectAtIndex:indexPath.row] cell:cellPayment accordingDate:((MOPayment *)[paymentFilteredData objectAtIndex:indexPath.row]).dateTime];
            [ListView createAmountLabel:cellPayment filteredData:[paymentFilteredData objectAtIndex:indexPath.row] isInEditingMode:NO accordingDate:((MOPayment *)[paymentFilteredData objectAtIndex:indexPath.row]).dateTime];
            [ListView addTitleAndSubtitleForPayment:[paymentFilteredData objectAtIndex:indexPath.row] cell:cellPayment];
            [ListView addAccountLabelText:[paymentFilteredData objectAtIndex:indexPath.row] cell:cellPayment isInEditingMode:NO];
            [ListView createLocationLabel:(MOPayment *)[paymentFilteredData objectAtIndex:indexPath.row] cell:cellPayment];
            [ListView addStatusLabelText:[paymentFilteredData objectAtIndex:indexPath.row] cell:cellPayment isInEditingMode:NO selectedDate:((MOPayment *)[paymentFilteredData objectAtIndex:indexPath.row]).dateTime];
            return cellPayment;
        case 2:
            [ListView addTitleAndSubtitleForAccount:[accountFilteredData objectAtIndex:indexPath.row] cell:cellAccount];
            [ListView createAccountTypeLabel:cellAccount filteredData:[accountFilteredData objectAtIndex:indexPath.row] isInEditingMode:NO];
            return cellAccount;
        default:
            break;
    }
    // Configure the cell...  
    return nil;
}

-(void) navigateToIncomeDetails:(NSInteger) index {
    IncomeViewController* incomeViewController = [[IncomeViewController alloc] initWithTransfer:[incomeFilteredData objectAtIndex:index] isOpenedFromCalendar:NO];
    incomeViewController.title = NSLocalizedString(@"Income Details", nil);
    [self.navigationController pushViewController:incomeViewController animated:YES];
    [incomeViewController release];
}

-(void) navigateToPaymentDetails:(NSInteger) index {
    PaymentViewController* paymentViewController = [[PaymentViewController alloc] initWithTransfer:[paymentFilteredData objectAtIndex:index] isOpenedFromCalendar:NO];
    paymentViewController.title = NSLocalizedString(@"Payment Details", nil);
    [self.navigationController pushViewController:paymentViewController animated:YES];
    [paymentViewController release];
}

-(void) navigateToAccountDetails:(NSInteger) index {
    AccountDetailViewController* accountDetailViewController = [[AccountDetailViewController alloc] initWithAccount:[accountFilteredData objectAtIndex:index]];
    accountDetailViewController.title = [[accountFilteredData objectAtIndex:index] name];
    [self.navigationController pushViewController:accountDetailViewController animated:YES];
    [accountDetailViewController release];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            [self navigateToIncomeDetails:indexPath.row];
            break;
        case 1:
            [self navigateToPaymentDetails:indexPath.row];
            break;
        case 2:
            [self navigateToAccountDetails:indexPath.row];
            break;
        default:
            break;
    }
}

#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterSearchLists];
    [self.tableView reloadData];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)sBar {
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
	
	NSLog(@"unload table");
}


- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
	NSLog(@"hide table");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sBar {
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[SearchData instance] initializeSearchLists];
    incomeFilteredData = [[SearchData instance].searchIncomesList retain];
    paymentFilteredData = [[SearchData instance].searchPaymentsList retain];
    accountFilteredData = [[SearchData instance].searchAccountsList retain];
    [self.tableView reloadData];
}

-(void) dealloc {
    if (lsearchController) {
        [lsearchController release];
        lsearchController = nil;
    }
    [searchBar release];
    [incomeFilteredData release];
    [paymentFilteredData release];
    [accountFilteredData release];
    [super dealloc];
}

@end
