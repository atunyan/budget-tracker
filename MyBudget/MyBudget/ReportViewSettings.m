/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/11/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "ReportViewSettings.h"
#import "Constants.h"
#import "MOReport.h"
#import "MOUser.h"
#import "MOSetting.h"
#import "CoreDataManager.h"

@implementation ReportViewSettings

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        report = [[MOUser instance].setting.report retain];
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
    self.title = NSLocalizedString(@"Report period", nil);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Report period", nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.detailTextLabel.text = @"";
    int monthsNumber = [report.period intValue];
    switch (indexPath.row) {
        case 0:
            // Start screen
            cell.accessoryType = (monthsNumber == 3) ?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
            cell.textLabel.text = NSLocalizedString(@"3 months", nil);
            break;
        case 1:
            ///@todo  needs to  define  default months  count
            cell.accessoryType = (monthsNumber == 6 || monthsNumber == 0) ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
            cell.textLabel.text = NSLocalizedString(@"6 months", nil);
            break;
        case 2:
            // Start screen
            cell.accessoryType = (monthsNumber == 12 ) ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
            cell.textLabel.text = NSLocalizedString(@"12 months", nil);
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            // Start screen
            report.period = [NSNumber numberWithInt:3];
            break;
        case 1:
            // Start screen
            report.period = [NSNumber numberWithInt:6];
            break;
            
        case 2:
            // Start screen
            report.period = [NSNumber numberWithInt:12];
            break;
        default:
            break;
    }
    [[CoreDataManager instance] saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc {
    [report release];
    [super dealloc];
}

@end
