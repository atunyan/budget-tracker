/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 02/02/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "DataPickerViewController.h"
#import "Constants.h"
#import "ReminderInfo.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import "MyBudgetHelper.h"

#import <QuartzCore/QuartzCore.h>

/// periodicity picker button tag
#define BUTTON_PERIODICITY_TAG      10

/// end date button tag
#define BUTTON_END_DATE_TAG         11

@implementation DataPickerViewController

@synthesize delegate;

- (id)initWithPeriodicity:(NSString*)selectedPeriodicity andWithEndDate:(NSDate*)selectedEndDate andWithStartDate:(NSDate*)selectedStartDate {
    self = [super init];
    if (self) {
        arrayOfRepeatDays = [[ReminderInfo possiblePeriods] retain];
        periodicity = selectedPeriodicity ? selectedPeriodicity : [arrayOfRepeatDays objectAtIndex:0];
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:DATE_FORMAT_STYLE];
        
        startDate = [selectedStartDate retain];
        endDate = selectedEndDate ? [selectedEndDate retain] : [[NSDate date] retain];
        if ([endDate compare:startDate] == NSOrderedAscending) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *stringFromDate = [dateFormatter stringFromDate:startDate];
            endDate = [[dateFormatter dateFromString:stringFromDate] retain];
            [dateFormatter release];
        }
    }
    return self;
}

-(void)dealloc {
    [periodicityPicker release];
    [endDatePicker release];
    [arrayOfRepeatDays release];
    [formatter release];
    [endDate release];
    [startDate release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)buttonClicked:(UIButton*)sender {
    switch (sender.tag) {
        case BUTTON_PERIODICITY_TAG:
            [periodicityPicker setHidden:NO];
            [endDatePicker setHidden:YES];
            ((UIButton *)[self.view viewWithTag:BUTTON_END_DATE_TAG]).titleLabel.font = [UIFont systemFontOfSize:18.0f];
            break;
        case BUTTON_END_DATE_TAG:
            [periodicityPicker setHidden:YES];
            [endDatePicker setHidden:NO];
            ((UIButton *)[self.view viewWithTag:BUTTON_PERIODICITY_TAG]).titleLabel.font = [UIFont systemFontOfSize:18.0f];
            break;            
        default:
            break;
    }
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
}

-(void)createButtons {
    int labelWidth = 90;
    int height = 30;
    int margin = 10;
    int buttonLeftMargin = margin * 3 + labelWidth;
    // periodicity label and button
    UILabel* periodicityLabel = [[UILabel alloc] init];
    periodicityLabel.frame = CGRectMake(margin, margin, labelWidth, height);
    periodicityLabel.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
    periodicityLabel.text = NSLocalizedString(@"Periodicity", nil);
    periodicityLabel.backgroundColor = [UIColor clearColor];
    periodicityLabel.font = [UIFont boldSystemFontOfSize:16.0];
    periodicityLabel.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:periodicityLabel];
    [periodicityLabel release];
        
    UIButton* periodicityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    periodicityButton.frame = CGRectMake(margin * 2 + labelWidth, margin, self.view.frame.size.width - buttonLeftMargin, height);
    [periodicityButton setTitle:NSLocalizedString(periodicity, nil) forState:UIControlStateNormal];
    [periodicityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage* image = [MyBudgetHelper imageWithColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]]];
    [periodicityButton setBackgroundImage:image forState:UIControlStateNormal];
    periodicityButton.clipsToBounds = YES;
    periodicityButton.layer.cornerRadius = 5.0f;
    periodicityButton.tag = BUTTON_PERIODICITY_TAG;
    [periodicityButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:periodicityButton];

    periodicityButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    
    // end date label and button
    UILabel* endDateLabel = [[UILabel alloc] init];
    endDateLabel.frame = CGRectMake(margin, margin * 2 + height, labelWidth, height);
    endDateLabel.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
    endDateLabel.text = NSLocalizedString(@"End Date", nil);
    endDateLabel.backgroundColor = [UIColor clearColor];
    endDateLabel.font = [UIFont boldSystemFontOfSize:16.0];
    endDateLabel.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:endDateLabel];
    [endDateLabel release];

    UIButton* endDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    endDateButton.frame = CGRectMake(margin * 2 + labelWidth, margin * 2 + height, self.view.frame.size.width - buttonLeftMargin, height);
    [endDateButton setTitle:[formatter stringFromDate:endDate] forState:UIControlStateNormal];
    [endDateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [endDateButton setBackgroundImage:image forState:UIControlStateNormal];
    endDateButton.clipsToBounds = YES;
    endDateButton.layer.cornerRadius = 5.0f;
    endDateButton.tag = BUTTON_END_DATE_TAG;
    [endDateButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endDateButton];
}

-(void)updateEndDate {
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    if ([periodicity isEqualToString:PERIODICITY_DAILY]) {
        components.month = 3;
    } else if ([periodicity isEqualToString:PERIODICITY_WORKDAYS]) {
        components.month = 6;
    } else if ([periodicity isEqualToString:PERIODICITY_WEEKLY]) {
        components.month = 6;
    } else if ([periodicity isEqualToString:PERIODICITY_MONTHLY]) {
        components.year = 1;
    } else if ([periodicity isEqualToString:PERIODICITY_QUARTERLY]) {
        components.year = 1;
    }
    NSDate* monthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:startDate options:0];
    [endDatePicker setMaximumDate:monthFromNow];
}

-(void)createPickerViews {
    // periodicity picker view
	periodicityPicker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - 340, 320, 280)];
    periodicityPicker.delegate = self;
    periodicityPicker.dataSource = self;
    [periodicityPicker setShowsSelectionIndicator:YES];
    [periodicityPicker reloadAllComponents];
    [periodicityPicker selectRow:[arrayOfRepeatDays indexOfObject:periodicity] inComponent:0 animated:NO];
    [self.view addSubview:periodicityPicker];
    
    // end date picker view
    endDatePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - 340, 320, 280)];
    endDatePicker.datePickerMode = UIDatePickerModeDate;
    [endDatePicker addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
	[endDatePicker setDate:endDate animated:NO];
    [endDatePicker setHidden:YES];
    [endDatePicker setMinimumDate:startDate ? startDate : [NSDate date]];
    [self updateEndDate];
    [self.view addSubview:endDatePicker];
}

-(void)dateSelected:(UIDatePicker*)datePicker {
    endDate = [[datePicker date] retain];
    
    UIButton* endDateButton = (UIButton*)[self.view viewWithTag:BUTTON_END_DATE_TAG];
    [endDateButton setTitle:[formatter stringFromDate:endDate] forState:UIControlStateNormal];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"budget_bg.png"]];

    UIBarButtonItem * saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveAction)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
    // Create periodicty picker
    [self createPickerViews];
    
    // Create buttons
    [self createButtons];
}

-(void) saveAction {
    if (([endDate compare:startDate] != NSOrderedDescending)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) 
                                                            message:NSLocalizedString(@"The end date is less then start date. Please select valid end date.", nil) 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    if([delegate respondsToSelector:@selector(didSavedWithPeriodicity:andWithEndDate:)]){
        [delegate didSavedWithPeriodicity:periodicity andWithEndDate:endDate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrayOfRepeatDays count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return NSLocalizedString([arrayOfRepeatDays objectAtIndex:row], nil);
} 

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    periodicity = [arrayOfRepeatDays objectAtIndex:row];
    UIButton* button = (UIButton *)[self.view viewWithTag:BUTTON_PERIODICITY_TAG];
    [button setTitle:NSLocalizedString(periodicity, nil) forState:UIControlStateNormal];
    
    [self updateEndDate];
}

@end
