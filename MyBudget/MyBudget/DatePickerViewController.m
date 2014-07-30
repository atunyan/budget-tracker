 /**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 1/12/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */
#import "DatePickerViewController.h"
#import "Constants.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import "MOPayment.h"

#import <QuartzCore/QuartzCore.h>

/// the date label tag
#define DATE_LABEL_TAG 1

@implementation DatePickerViewController

@synthesize date;
@synthesize endDate;
@synthesize delegate;
@synthesize datePickerMode;

- (id)initWithDate:(NSDate*)selectedDate withEndDate:(NSDate*)anEndDate andMode:(UIDatePickerMode)mode
{
    self = [super init];
    if (self) {
        self.date = selectedDate;
        self.endDate = anEndDate;
        self.datePickerMode = mode;
        if (UIDatePickerModeDateAndTime == datePickerMode) {
            dateFormat = DATE_FORMAT_STYLE_WITH_TIME;
        } else if (UIDatePickerModeDate == datePickerMode) {
            dateFormat = DATE_FORMAT_STYLE;
        }
        // Custom initialization
    }
    return self;
}

-(void)dealloc {
    [datePicker release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"budget_bg.png"]];

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    
    UIBarButtonItem * saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveAction)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - 340, 320, 280)];
    datePicker.datePickerMode = self.datePickerMode;
    [datePicker addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventValueChanged];
    [datePicker setMaximumDate:endDate];
    
	if(date == nil) {
		self.date = [NSDate date];
	}
	[datePicker setDate:date animated:NO];
	
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20 , 30)];
    dateLabel.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.layer.cornerRadius = 5.0f;
    dateLabel.tag = DATE_LABEL_TAG;
    dateLabel.textAlignment = UITextAlignmentCenter;
    dateLabel.font = [UIFont systemFontOfSize:16.0f];

    [dateLabel setText:[formatter stringFromDate:self.date]];
    
    [formatter release];
    [self.view addSubview:dateLabel];
    [dateLabel release];
    
	[self.view addSubview:datePicker];
}

-(void)dateSelected {
    self.date = [datePicker date];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    
    UILabel *label = (UILabel *)[self.view viewWithTag:DATE_LABEL_TAG];
    [label setText:[formatter stringFromDate:date]];
    [formatter release];
   /* if([delegate respondsToSelector:@selector(datePickerControllerDidSave:)]){
        [delegate datePickerControllerDidSave:date];
    }*/
}


-(void) showAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) 
                                                        message:NSLocalizedString(@"The mention date has already passed. Please select valid date.", nil) 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}


-(void) saveAction {
    if (UIDatePickerModeDateAndTime == datePickerMode) {
        if (([date compare:[NSDate date]] == NSOrderedAscending)) {
            [self showAlert];
            return;
        }
    }
    if([delegate respondsToSelector:@selector(datePickerControllerDidSave:)]){
        [delegate datePickerControllerDidSave:date];
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

@end
