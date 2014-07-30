/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/14/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "TransferListViewController.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import "Constants.h"
#import "MOIncome.h"
#import "MOPayment.h"
#import "MOCategory.h"
#import "MOAccount.h"
#import "MOTransfer.h"
#import "ListView.h"
#import "TransferViewController.h"
#import "LocationInfo.h"
#import "MORecurrence.h"
#import "ActionManager.h"
#import "MyBudgetHelper.h"


@implementation TransferListViewController {
    UIBarButtonItem *monthName;
}

@synthesize tableView;
@synthesize isAccountSelected;
@synthesize selectedMonth;
@synthesize filteredItems;

-(void) filterByMonth {
    [filteredItems removeAllObjects];
    for (id item in listOfItems) {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"MMMM YYY"];
        if ([[formatter stringFromDate:selectedMonth] isEqualToString:[formatter stringFromDate:[item dateTime]]]) {
            [filteredItems addObject:item];
        }
    }
}

-(void) sortByDate {
    NSSet* sortSet = [[NSSet alloc] initWithArray:filteredItems];
    if (!filteredItems) {
        [filteredItems release];
        filteredItems = nil;
    }
    filteredItems = [[NSMutableArray alloc] initWithArray:[CoreDataManager sortSet:sortSet byProperty:SORT_BY_DATE_TIME ascending:NO]];
    [sortSet release];
}

-(void)addSelectedDateByMonth:(int)monthCount
{
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    components.month = monthCount;
    self.selectedMonth = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:selectedMonth options:0];
}

-(void)navigate {
    [self filterByMonth];
    [self sortByDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM YYY"];
    ((UILabel*)monthName.customView).text = [formatter stringFromDate:selectedMonth];
    [formatter release];
    [tableView reloadData];
}

-(void)navigationToLeft
{
    [self addSelectedDateByMonth:-1];
    [self navigate];
}

-(void)navigationToRight
{
    [self addSelectedDateByMonth:1];
    [self navigate];
}

-(void) initializeMonthName {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM YYY"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    UILabel* monthNameView = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 160, 30)];
    monthNameView.text = stringFromDate;
    monthNameView.textAlignment = UITextAlignmentCenter;
    monthNameView.textColor = [UIColor whiteColor];
    monthNameView.backgroundColor = [UIColor clearColor];
    
    monthName = [[UIBarButtonItem alloc] initWithCustomView:monthNameView];
    
    [monthNameView release];
    [formatter release];
}

-(void) createToolbar
{
    toolbarHeight = 40;
    UIToolbar* toolbar = [UIToolbar new];
    toolbar.tag = 288;
    toolbar.barStyle = UIBarStyleBlack;
    
    // size up the toolbar and set its frame
    [toolbar sizeToFit];
    [toolbar setFrame:CGRectMake(0, self.view.frame.size.height - 2*toolbarHeight-4, 320, toolbarHeight)];

    UIImage *backwardImage = [UIImage imageNamed:@"whiteBackward.png"];
    UIBarButtonItem *navigateLeft = [[UIBarButtonItem alloc] initWithImage:backwardImage style:UIBarButtonItemStylePlain target:self action:@selector(navigationToLeft)];
    
    [self initializeMonthName];
    UIImage *forwardImage = [UIImage imageNamed:@"whiteForward.png"];
    UIBarButtonItem *navigateRight = [[UIBarButtonItem alloc] initWithImage:forwardImage style:UIBarButtonItemStylePlain target:self action:@selector(navigationToRight)];

    UIBarButtonItem* flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray* items = [NSArray arrayWithObjects:flex, navigateLeft, flex, monthName, flex, navigateRight, flex, nil];
    [toolbar setItems:items];
    [navigateLeft release];
    
    [navigateRight release];
    
    [self.view addSubview:toolbar];
    
    [toolbar release];
    [flex release];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.selectedMonth = [NSDate date];
        filteredItems = [[NSMutableArray alloc] init];
        // Custom initialization
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

-(void)addEntity {
    NSAssert(false, @"Should be implemented in derived classes.");
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEntity)];
    NSArray* arrayOfButtons = [[NSArray alloc] initWithObjects:addBarButton, nil];
    self.navigationItem.rightBarButtonItems = arrayOfButtons;
    [arrayOfButtons release];
    [addBarButton release];
    
    [self createToolbar];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - toolbarHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    if (!tableView) {
        [tableView release];
        tableView = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self filterByMonth];
    [self sortByDate];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [filteredItems count];
}

//-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {	
//	return UITableViewCellEditingStyleDelete;
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.navigationController.navigationBar  viewWithTag:ACTIVITY_INDICATOR_TAG];
//	[activityIndicator startAnimating];
//	[tableView setAllowsSelection:YES];
//	[tableView setAllowsSelectionDuringEditing:YES];
//	//[tableView reloadData];
//}
//
//-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//	[tableView setAllowsSelection:NO];
//	[tableView setAllowsSelectionDuringEditing:NO];	
//	[self.navigationItem setRightBarButtonItem:nil animated:NO];
//}
//
//-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//	[tableView setAllowsSelection:YES];
//	[tableView setAllowsSelectionDuringEditing:YES];
//	//[self.navigationItem setRightBarButtonItem:self.editUIBarButton animated:NO];
//}

-(void) addTitleAndSubtitle:(NSInteger) index cell:(UITableViewCell *) cell {
}

-(void) addAccountLabelText:(NSInteger) index cell:(UITableViewCell *) cell {
    
}

-(void) addStatusLabelText:(NSInteger) index cell:(UITableViewCell *) cell {
    [ListView addStatusLabelText:[filteredItems objectAtIndex:index] cell:cell isInEditingMode:isInEditingMode selectedDate:selectedMonth];
}

/// creates table view cell location label
-(void) createLocationLabel:(NSInteger)index cell:(UITableViewCell *)cell {
    [ListView createLocationLabel:[filteredItems objectAtIndex:index] cell:cell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        if(!isAccountSelected){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        [self createAccountLabel:cell];
        [ListView createTitleLabel:cell];
        [ListView createSubtitleLabel:cell];
        [ListView createStatusLabel:cell];
    }
    [self createSubsubTitleLabel:indexPath.row cell:cell];
    [self addTitleAndSubtitle:indexPath.row cell:cell];
    [self addAccountLabelText:indexPath.row cell:cell];
    [self addStatusLabelText:indexPath.row cell:cell];
    [self createAmountLabel:cell index:indexPath.row];
    [self createLocationLabel:indexPath.row cell:cell];

    // Configure the cell...
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateEntity:indexPath.row];
}

/// creates table view cell amount label
-(void) createAmountLabel:(UITableViewCell *)cell index:(NSInteger)index {
    [ListView createAmountLabel:cell filteredData:[filteredItems objectAtIndex:index] isInEditingMode:isInEditingMode accordingDate:selectedMonth];
}


/// creates table view cell amount label
-(void) createAccountLabel:(UITableViewCell *)cell {
    [ListView createAccountLabel:cell];
}

/// creates table view cell amount label
-(void) createSubsubTitleLabel:(NSInteger)index cell:(UITableViewCell *)cell {
    [ListView createSubsubTitleLabel:[filteredItems objectAtIndex:index] cell:cell accordingDate:selectedMonth];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if(editing) {
        isInEditingMode = YES;
        tableView.editing = YES;
    } else {
        //[[CoreDataManager instance] saveContext];
        isInEditingMode = NO;
        tableView.editing = NO;
    }
    [self.tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [filteredItems count]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UIView* amountLabel = [cell.contentView viewWithTag:AMOUNT_LABEL_TAG];
        if (amountLabel) {
            amountLabel.hidden = YES;
        }            
        UIView* accountLabel = [cell.contentView viewWithTag:ACCOUNT_LABEL_TAG];
        if (accountLabel) {
            accountLabel.hidden = YES;
        }   
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView_ commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        transfer = [[filteredItems objectAtIndex:indexPath.row] retain];
        [ActionManager deleteTransfer:transfer view:self.view.window delegate:self];
    } 
}

-(void)updateEntity:(NSInteger)indexPathRow {
    NSAssert(false, @"Should be implemented in derived classes.");
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // update list
    if ([ActionManager deleteRecurrencesOf:transfer index:buttonIndex date:selectedMonth]) {
        [tableView reloadData];
    }
}

#pragma mark - TransferViewControllerDelegate

// add in list
-(void)didSavedTransfer:(NSManagedObject *)managedObject {
    if (managedObject) {
        [listOfItems addObject:managedObject];
    }
    [tableView reloadData];
}

-(void) dealloc {
    [listOfItems release];
    [filteredItems release];
    [tableView release];
    if (transfer) {
        [transfer release];
    }
    if (monthName) {
        [monthName release];
        monthName = nil;
    }
    [super dealloc];
}

@end
