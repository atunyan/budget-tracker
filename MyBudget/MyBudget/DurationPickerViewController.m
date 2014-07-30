/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 02/02/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "DurationPickerViewController.h"
#import "Constants.h"
#import "ReminderInfo.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import "MyBudgetHelper.h"

#import <QuartzCore/QuartzCore.h>

/// start date picker button tag
#define BUTTON_START_DATE_TAG      10

/// end date button tag
#define BUTTON_END_DATE_TAG         11

/// the tag for start date picker
#define START_DATE_PICKER_TAG       12

/// the tag for end date picker
#define END_DATE_PICKER_TAG         13

@implementation DurationPickerViewController

@synthesize delegate;

- (id)initWithStartDate:(NSDate*)selectedStartDate andEndDate:(NSDate*)selectedEndDate {
    self = [super init];
    if (self) { 
        startDate = [selectedStartDate retain];
        endDate = [selectedEndDate retain];
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:DATE_FORMAT_STYLE];        
    }
    return self;
}

-(void)dealloc {
    [datePicker release];
    [formatter release];
    if (endDate) {
        [endDate release];
    }
    if (startDate) {
        [startDate release];
    }
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
        case BUTTON_START_DATE_TAG:
            datePicker.tag = START_DATE_PICKER_TAG;
            if(startDate){
                [datePicker setDate:startDate];
            }
            [datePicker setMinimumDate:nil];
            ((UIButton *)[self.view viewWithTag:BUTTON_END_DATE_TAG]).titleLabel.font = [UIFont systemFontOfSize:18.0f];
            break;
        case BUTTON_END_DATE_TAG:
            datePicker.tag = END_DATE_PICKER_TAG;
            if(endDate){
                [datePicker setDate:endDate];
            }
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.year = 1;
            NSDate* maxEndDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:startDate options:0];
            [components release];
            [datePicker setMinimumDate:startDate];
            [datePicker setMaximumDate:maxEndDate];
            ((UIButton *)[self.view viewWithTag:BUTTON_START_DATE_TAG]).titleLabel.font = [UIFont systemFontOfSize:18.0f];
            
            /// if user select start date , and it's differecne from endDate is more than one year, then automatically end date setts startDate + 1year.but user still can select end date. 
            if([self yearsCountBetweenDates] > 1){
                NSDateComponents *monthComponents = [[NSDateComponents alloc] init];
                monthComponents.year = 1;
                NSDate* tempEndDate = [[NSCalendar currentCalendar] dateByAddingComponents:monthComponents toDate:startDate options:0];
                [sender setTitle:[formatter stringFromDate:tempEndDate] forState:UIControlStateNormal];
				[monthComponents release];
                if(endDate){
                    endDate = nil;
                    [endDate release];
                }
                endDate = tempEndDate;
                [endDate retain];
            }

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
    
    // start date label and button
    UILabel* startDateLabel = [[UILabel alloc] init];
    startDateLabel.frame = CGRectMake(margin, margin, labelWidth, height);
    startDateLabel.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
    startDateLabel.text = NSLocalizedString(@"Start Date:", nil);
    startDateLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:startDateLabel];
    [startDateLabel release];
        
    UIButton* startDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startDateButton.frame = CGRectMake(margin * 2 + labelWidth, margin, self.view.frame.size.width - buttonLeftMargin, height);
    if (startDate) {
        [startDateButton setTitle:[formatter stringFromDate:startDate] forState:UIControlStateNormal];
    } else {
        [startDateButton setTitle:[formatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
        startDate = [[NSDate date] retain];
    }

    if (datePicker.tag == START_DATE_PICKER_TAG) {
        startDateButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    }
    
    UIImage* image = [MyBudgetHelper imageWithColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]]];
    [startDateButton setBackgroundImage:image forState:UIControlStateNormal];
    startDateButton.clipsToBounds = YES;
    startDateButton.layer.cornerRadius = 5.0f;
    startDateButton.tag = BUTTON_START_DATE_TAG;
    [startDateButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startDateButton];
    
    // end date label and button
    UILabel* endDateLabel = [[UILabel alloc] init];
    endDateLabel.frame = CGRectMake(margin, margin * 2 + height, labelWidth, height);
    endDateLabel.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
    endDateLabel.text = NSLocalizedString(@"End Date:", nil);
    endDateLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:endDateLabel];
    [endDateLabel release];

    UIButton* endDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    endDateButton.frame = CGRectMake(margin * 2 + labelWidth, margin * 2 + height, self.view.frame.size.width - buttonLeftMargin, height);
    if (endDate) {
        [endDateButton setTitle:[formatter stringFromDate:endDate] forState:UIControlStateNormal];
    } else {
        [endDateButton setTitle:NSLocalizedString(@"Please select", nil) forState:UIControlStateNormal];
    }
    
    if (datePicker.tag == END_DATE_PICKER_TAG) {
        endDateButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    [endDateButton setBackgroundImage:image forState:UIControlStateNormal];
    endDateButton.clipsToBounds = YES;
    endDateButton.layer.cornerRadius = 5.0f;
    endDateButton.tag = BUTTON_END_DATE_TAG;
    [endDateButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endDateButton];
}

-(void)createPickerView:(NSInteger) tag date :(NSDate *) date{
    if (datePicker) {
        [datePicker release];
        datePicker = nil;
    }
	datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - 340, 320, 280)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
    datePicker.tag = tag;
    [datePicker setMaximumDate:nil];
    [datePicker setMinimumDate:nil];
    if (date) {
        [datePicker setDate:date animated:NO];
    }
    [self.view addSubview:datePicker];    
}

-(void)dateSelected:(UIDatePicker*)dPicker {
    if (END_DATE_PICKER_TAG == dPicker.tag) {
        if (endDate) {
            [endDate release];
            endDate = nil;
        }
        endDate = [[dPicker date] retain];
        
        UIButton* endDateButton = (UIButton*)[self.view viewWithTag:BUTTON_END_DATE_TAG];
        [endDateButton setTitle:[formatter stringFromDate:endDate] forState:UIControlStateNormal];
    } else if (START_DATE_PICKER_TAG == datePicker.tag) {
        if (startDate) {
            [startDate release];
            startDate = nil;
        }
        startDate = [[dPicker date] retain];
        UIButton* startDateButton = (UIButton*)[self.view viewWithTag:BUTTON_START_DATE_TAG];
        [startDateButton setTitle:[formatter stringFromDate:startDate] forState:UIControlStateNormal];
    }
}

/// years count between start and end dates (using for check at save dates)
-(NSUInteger)yearsCountBetweenDates {
    NSCalendar *gregorian = [[NSCalendar alloc]  
                             initWithCalendarIdentifier:NSGregorianCalendar];  
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit fromDate:startDate  toDate:endDate options:0];  
    int years = [comps year];  
    [gregorian release];
    
    return years;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"budget_bg.png"]];

    UIBarButtonItem * saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveAction)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
    // Create date picker
    [self createPickerView:START_DATE_PICKER_TAG date:startDate];    
    // Create buttons
    [self createButtons];
}

-(void) saveAction {
    if (!startDate) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) 
                                                            message:NSLocalizedString(@"Start date is not selected.", nil) 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    if (!endDate) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) 
                                                            message:NSLocalizedString(@"End date is not selected.", nil) 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }

    if([self yearsCountBetweenDates] > 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) 
                                                            message:NSLocalizedString(@"End date can't be more than one year.Please select vaild end date.", nil) 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    if (NSOrderedAscending == [endDate compare:startDate]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) 
                                                            message:NSLocalizedString(@"The end date is less then start date. Please select valid duration.", nil) 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    } else {
        if([delegate respondsToSelector:@selector(didSavedWithStartDate:andWithEndDate:)]){
            [delegate didSavedWithStartDate:startDate andWithEndDate:endDate];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
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

@end
