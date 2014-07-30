/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 3/1/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 */

#import "TransactionListTableViewController.h"
#import "IncomeViewController.h"
#import "PaymentViewController.h"
#import "Constants.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import "MOIncome.h"
#import "ListView.h"
#import "MOTransfer.h"
#import "MyBudgetHelper.h"

/// The category label tag
#define CATEGORY_LABEL_TAG 1

///The date label tag
#define DATE_LABEL_TAG 2

@implementation TransactionListTableViewController

- (id)initWithStyle:(UITableViewStyle)style withAccount:(MOAccount*)account
{
    self = [super initWithStyle:style];
    if (self) {
        currentTransAccount = account;
        
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
    [transactionItems release];
    [super dealloc];
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    transactionItems = [[NSMutableArray alloc] init];
    
    // incomes
    NSSet* incomesSet = [CoreDataManager subSetOf:[MOUser instance].incomes filteredByAccount:currentTransAccount];

    NSArray* incomesArray = [CoreDataManager sortSet:incomesSet byProperty:SORT_BY_DATE_TIME ascending:NO];
    
    for (MOTransfer* transfer in incomesArray) {
        NSArray* recurrences = [CoreDataManager sortSet:transfer.recurrings byProperty:SORT_BY_DATE_TIME ascending:NO];
        recurrences = [CoreDataManager arrayWithDoneStatus:recurrences];
        [transactionItems addObjectsFromArray:recurrences];
    }
    
    // payments
    NSSet* paymentsSet = [CoreDataManager subSetOf:[MOUser instance].payments filteredByAccount:currentTransAccount];
    
    NSArray* paymentsArray = [CoreDataManager sortSet:paymentsSet byProperty:SORT_BY_DATE_TIME ascending:NO];
    
    for (MOTransfer* transfer in paymentsArray) {
        NSArray* recurrences = [CoreDataManager sortSet:transfer.recurrings byProperty:SORT_BY_DATE_TIME ascending:NO];
        recurrences = [CoreDataManager arrayWithDoneStatus:recurrences];
        [transactionItems addObjectsFromArray:recurrences];
    }
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

/// this method creates transaction amount label
-(void) createAmountLabel:(UITableViewCell *)cell withCurrentObject:(MORecurrence*)currentObject withColor:(UIColor*)textColor {
    UILabel* amountLabel = (UILabel *) [cell.contentView viewWithTag:AMOUNT_LABEL_TAG];
    if (!amountLabel) {
        amountLabel = [[[UILabel alloc] init] autorelease];
        amountLabel.textColor = textColor;
        amountLabel.font = [UIFont boldSystemFontOfSize:12.0];
        amountLabel.tag = AMOUNT_LABEL_TAG;
        amountLabel.textAlignment = UITextAlignmentRight;
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.frame = CGRectMake(170, cell.contentView.frame.origin.y + 20, cell.contentView.frame.size.width - 180, 20);
        [cell.contentView addSubview:amountLabel];
    }
    NSString* string = [NSString stringWithFormat:@"%.2f", [currentObject.amount doubleValue]]; 
    amountLabel.text = [string stringByAppendingString:[NSString stringWithFormat:@" %@", [MOUser instance].setting.currency]]; 
}

/// This method creates date label
-(void) createDateLabel:(MORecurrence *)currentObject cell:(UITableViewCell *)cell {
    UILabel* dateLabel = (UILabel *) [cell.contentView viewWithTag:DATE_LABEL_TAG];
    if (!dateLabel) {
        dateLabel = [[[UILabel alloc] init] autorelease];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont boldSystemFontOfSize:18.0];
        dateLabel.tag = DATE_LABEL_TAG;
        dateLabel.textAlignment = UITextAlignmentLeft;
        dateLabel.backgroundColor = [UIColor clearColor];     
        dateLabel.text = @"";
        dateLabel.frame = CGRectMake(60, cell.contentView.frame.origin.y, 110, 25);
        [cell.contentView addSubview:dateLabel];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_STYLE];
    dateLabel.text = [formatter  stringFromDate:[currentObject dateTime]];
    [formatter release];
}

/// this method creates category label with category image
-(void) createCategoryTitleLabelForCell:(UITableViewCell *)cell withCurrentObject:(MOPayment*)currentObject {
    UIImage* image = [UIImage imageNamed:[currentObject category].categoryImageName];
    cell.imageView.image = image;
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:TITLE_LABEL_TAG];
    label.frame = CGRectMake(60, cell.contentView.frame.origin.y + 43, cell.contentView.frame.size.width - 80, 16);
    label.font = [UIFont systemFontOfSize:13.0];
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%@/%@", [currentObject category].parentCategory.name, [currentObject category].name];
    
    label = (UILabel*)[cell.contentView viewWithTag:SUBTITLE_LABEL_TAG];
    label.text = [currentObject name];
    label.textColor = [UIColor blackColor];
}

/// This method creates incomes title and date label for transaction page
-(void) createIncomeTitleLabel:(MORecurrence *)currentObject cell:(UITableViewCell *)cell {
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:TITLE_LABEL_TAG];
    label.frame = CGRectMake(20, cell.contentView.frame.origin.y + 40, cell.contentView.frame.size.width - 30, 25);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:12.0];
    label.text = [(MOIncome *)currentObject.transfer name];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_STYLE];
    label = (UILabel*)[cell.contentView viewWithTag:SUBTITLE_LABEL_TAG];
    label.text = [formatter  stringFromDate:[currentObject dateTime]];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.frame = CGRectMake(20, cell.contentView.frame.origin.y + 20, 140, 20);
    [formatter release];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [transactionItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"IncomeCell";
    static NSString *CellIdentifier3 = @"PaymentCell";
    
    UITableViewCell *cellIncome = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cellIncome == nil) {
        cellIncome = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
        cellIncome.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        cellIncome.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        cellIncome.selectionStyle = UITableViewCellSelectionStyleNone;
        [ListView createTitleLabel:cellIncome];
        [ListView createSubtitleLabel:cellIncome];
    }
    UITableViewCell *cellPayment = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
    if (cellPayment == nil) {
        cellPayment = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3] autorelease];
        cellPayment.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        cellPayment.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        cellPayment.selectionStyle = UITableViewCellSelectionStyleNone;
        [ListView createTitleLabel:cellPayment];
        [ListView createSubtitleLabel:cellPayment];
    }
    
    MORecurrence* recurrence = [transactionItems objectAtIndex:indexPath.row];
    
    UIColor* amountTextColor; 
    if([recurrence.transfer isKindOfClass:[MOIncome class]]){
        amountTextColor = [MyBudgetHelper incomeColor];
        [self createIncomeTitleLabel:recurrence cell:cellIncome];
        [self createAmountLabel:cellIncome withCurrentObject:recurrence withColor:amountTextColor];
        return cellIncome;
    } else {
        amountTextColor = [MyBudgetHelper paymentColor];
        [self createDateLabel:recurrence cell:cellPayment];
        [self createCategoryTitleLabelForCell:cellPayment withCurrentObject:(MOPayment*)recurrence.transfer];
        [ListView createLocationLabel:(MOPayment*)recurrence.transfer cell:cellPayment];
        [self createAmountLabel:cellPayment withCurrentObject:recurrence withColor:amountTextColor];
        return cellPayment;
    }
    
    // Configure the cell...
    return nil;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
 
@end
