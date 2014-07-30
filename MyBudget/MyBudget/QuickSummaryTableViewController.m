/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/24/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "QuickSummaryTableViewController.h"
#import "MOUser.h"
#import "MOSetting.h"
#import "MOIncome.h"
#import "MOPayment.h"
#import "MORecurrence.h"
#import "CoreDataManager.h"

/// tag for cell sub view
#define VIEW_LABELS_TAG         10

@implementation QuickSummaryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        elements = [[NSArray arrayWithObjects:NSLocalizedString(@"Day", nil), NSLocalizedString(@"Week", nil), NSLocalizedString(@"Month", nil), NSLocalizedString(@"Year", nil), nil] retain];
        imagesNames = [[NSArray arrayWithObjects:@"Day", @"Week", @"Month", @"Year", nil] retain];
        date = [[NSDate date] retain];
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
    self.navigationItem.title = NSLocalizedString(@"Quick Summary", nil);
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
    // Return the number of sections.
    return [elements count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 31;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString* text = @"";
    switch (section) {
        case kDurationTypeDay:
            [formatter setDateFormat:@"MMM dd, yyyy"];
            text = [formatter stringFromDate:date];
            break;
        case kDurationTypeWeek: {
            NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
            NSDateComponents* comps = [calendar components:NSYearCalendarUnit | NSWeekCalendarUnit  fromDate:date];
            NSInteger thisWeek = [comps week];
            [formatter setDateFormat:@"MMM dd"];
            
            // Start date
            [comps setWeekday:1];
            [comps setWeek:thisWeek];
            NSDate *resultDate = [calendar dateFromComponents:comps];
            NSString* startDate = [formatter stringFromDate:resultDate];
            
            // End date
            [comps setWeekday:7];
            [comps setWeek:thisWeek];
            resultDate = [calendar dateFromComponents:comps];
            NSString* endDate = [formatter stringFromDate:resultDate];
            
            // Full text
            text = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
            break;
        }
        case kDurationTypeMonth:
            [formatter setDateFormat:@"MMMM yyyy"];
            text = [formatter stringFromDate:date];
            break;
        case kDurationTyepYear:
            [formatter setDateFormat:@"yyyy"];
            text = [formatter stringFromDate:date];
            break;
        default:
            break;
    }
    [formatter release];
    return [NSString stringWithFormat:@"%@: %@", [elements objectAtIndex:section], text];
}

-(UILabel*)titleLabelWithFrame:(CGRect)frame andWithText:(NSString*)text {
    UIColor* labelTextColor = [UIColor grayColor];
    UIFont* font = [UIFont boldSystemFontOfSize:14];
    
    UILabel* textLabel = [[UILabel alloc] init];
    textLabel.frame = frame;
    textLabel.text = text;
    textLabel.textColor = labelTextColor;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = font;
    return [textLabel autorelease];
}

-(UILabel*)valueLabelWithFrame:(CGRect)frame andWithValue:(NSNumber*)number {
    UIFont* font = [UIFont boldSystemFontOfSize:14];
    UIColor* valueTextColor = [UIColor blackColor];
    
    NSString *amount = [NSString stringWithFormat:@"%.2f", [number doubleValue]];
    
    UILabel* valueLabel = [[UILabel alloc] init];
    valueLabel.frame = frame;
    valueLabel.text = [NSString stringWithFormat:@"%@", amount];
    valueLabel.textAlignment = UITextAlignmentRight;
    valueLabel.textColor = valueTextColor;
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = font;
    return [valueLabel autorelease];
}

-(UILabel*)currencyLabelWithFrame:(CGRect)frame {
    UIFont* currencyFont = [UIFont systemFontOfSize:12];
    
    UILabel* currencyLabel = [[UILabel alloc] init];
    currencyLabel.frame = frame;
    currencyLabel.text = [MOUser instance].setting.currency;
    currencyLabel.font = currencyFont;
    currencyLabel.textColor = [UIColor blackColor];
    currencyLabel.textAlignment = UITextAlignmentRight;
    currencyLabel.backgroundColor = [UIColor clearColor];
    
    return [currencyLabel autorelease];
}

-(NSNumber*)amountOfSet:(NSSet*)set byDurationType:(DurationType)durationType {
    // Get the current calendar
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    // Get the components from the current date
    NSDateComponents* comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit  fromDate:date];
    NSInteger thisYear = [comps year];
    NSInteger thisMonth = [comps month];
    NSInteger thisWeek = [comps week];
    NSInteger thisDay = [comps day];
    
    double amount = 0;
    for (MOTransfer* mo in set) {
        switch (durationType) {
            case kDurationTypeDay: {
                for (MORecurrence* recurrence in mo.recurrings) {
                    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:recurrence.dateTime];
                    if (thisYear == [components year] && thisMonth == [components month] && thisDay == [components day] && [recurrence.isDone boolValue]) {
                        amount += [recurrence.amount doubleValue];
                    }
                }
            }
                break;
            case kDurationTypeWeek:
                for (MORecurrence* recurrence in mo.recurrings) {
                    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSWeekCalendarUnit fromDate:recurrence.dateTime];
                    if (thisYear == [components year] && thisWeek == [components week] && [recurrence.isDone boolValue]) {
                        amount += [recurrence.amount doubleValue];
                    }
                }
                break;
            case kDurationTypeMonth:
                for (MORecurrence* recurrence in mo.recurrings) {
                    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:recurrence.dateTime];
                    if (thisYear == [components year] && thisMonth == [components month] && [recurrence.isDone boolValue]) {
                        amount += [recurrence.amount doubleValue];
                    }
                }
                break;
            case kDurationTyepYear:
                for (MORecurrence* recurrence in mo.recurrings) {
                    NSDateComponents *components = [calendar components:NSYearCalendarUnit fromDate:recurrence.dateTime];
                    if (thisYear == [components year] && [recurrence.isDone boolValue]) {
                        amount += [recurrence.amount doubleValue];
                    }
                }
                break;
            default:
                break;
        }        
    }
    
    return [NSNumber numberWithDouble:amount];
}

-(UIView*)labelsWithFrame:(CGRect)frame byDurationType:(DurationType)durationType {
    int height = 20;
    int labelWidth = 80;
    int currencyWidth = 40;
    int valueWidth = frame.size.width - labelWidth - currencyWidth - 10;
    
    // Create content view
    UIView* labelsView = [[UIView alloc] init];
    labelsView.frame = frame;
    labelsView.backgroundColor = [UIColor clearColor];
    labelsView.tag = VIEW_LABELS_TAG;
    
    // Create labels
    [labelsView addSubview:[self titleLabelWithFrame:CGRectMake(0, 0, labelWidth, height) andWithText:NSLocalizedString(@"Income", nil)]];
    [labelsView addSubview:[self titleLabelWithFrame:CGRectMake(0, 22, labelWidth, height) andWithText:NSLocalizedString(@"Payments", nil)]];
    
    // Create values
    // Income value
    NSNumber* incomeAmount = [self amountOfSet:[MOUser instance].incomes byDurationType:durationType];    
    [labelsView addSubview:[self valueLabelWithFrame:CGRectMake(labelWidth, 0, valueWidth, height) andWithValue:incomeAmount]];
    // Payments value
    NSNumber* paymentsAmount = [NSNumber numberWithDouble:
                                [[self amountOfSet:[MOUser instance].payments byDurationType:durationType] doubleValue]];
    [labelsView addSubview:[self valueLabelWithFrame:CGRectMake(labelWidth, 22, valueWidth, height) andWithValue:paymentsAmount]];
    
    // Create currency label
    [labelsView addSubview:[self currencyLabelWithFrame:CGRectMake(labelWidth + valueWidth, 0, currencyWidth, height)]];
    [labelsView addSubview:[self currencyLabelWithFrame:CGRectMake(labelWidth + valueWidth, 22, currencyWidth, height)]];
    
    return [labelsView autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Add image
    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"QS_%@.png", [imagesNames objectAtIndex:indexPath.section]]];
    cell.imageView.image = image;
    
    // Add labels
    UIView* labelsView = [cell.contentView viewWithTag:VIEW_LABELS_TAG];
    [labelsView removeFromSuperview];
    [cell.contentView addSubview:[self labelsWithFrame:CGRectMake(50, 2, 250, cell.contentView.frame.size.height) byDurationType:indexPath.section]];
    
    return cell;
}

-(void)dealloc {
    [elements release];
    [date release];
    [super dealloc];
}

@end
