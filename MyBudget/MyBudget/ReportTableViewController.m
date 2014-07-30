/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/22/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "ReportTableViewController.h"
#import "TableReportViewCell.h"
#import "MOUser.h"
#import "MOSetting.h"
#import "MOReport.h"

@implementation ReportTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setScrollEnabled:NO];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(report){
        [report release];
    }
    report = [[Report alloc] initWithData:[MOUser instance]];

    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

-(int) periodNumber {
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags = NSMonthCalendarUnit ;
	
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:[MOUser instance].setting.report.startDate
												  toDate:[MOUser instance].setting.report.endDate options:0];
    
    int periodNumber = [components month];
    [gregorian release];
    return ( periodNumber == 0 ) ? 1 : periodNumber;
} 

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Create header view
    UIView* headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 320, [self tableView:tableView heightForHeaderInSection:section]);
    headerView.backgroundColor = [UIColor clearColor];
    
    // Create header view
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 320, 30);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(@"Table view", nil);
    [headerView addSubview:titleLabel];
    [titleLabel release];
    
    // Create period view
    UILabel* periodLabel = [[UILabel alloc] init];
    periodLabel.frame = CGRectMake(0, 30, 320, 20);
    periodLabel.backgroundColor = [UIColor clearColor];
    periodLabel.font = [UIFont systemFontOfSize:14];
    periodLabel.textAlignment = UITextAlignmentCenter;
    periodLabel.text = [report periodFromStartDate:[MOUser instance].setting.report.startDate 
                                             toEndDate:[MOUser instance].setting.report.endDate];
    [headerView addSubview:periodLabel];
    [periodLabel release];
    
    return [headerView autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self periodNumber] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 20;
        default:
            return 20;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TableReportViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    if (cell == nil) {
        cell = [[[TableReportViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    if (indexPath.row == 0) {
        [cell setCellType:kCellTypeHeader];
    } else {
        [cell setCellType:kCellTypeCommon];
        cell.monthTitle = [report monthNameBefore:indexPath.row];
        if([report.incomeArray count]>0){
            cell.income = [report.incomeArray objectAtIndex:indexPath.row - 1];
        }
        if([report.paymentArray count] > 0){
            cell.payment = [report.paymentArray objectAtIndex:indexPath.row - 1];
        }
    } 
    
    // Configure the cell...
    
    return cell;
}

@end
