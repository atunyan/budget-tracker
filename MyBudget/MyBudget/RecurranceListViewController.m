/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 4/4/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "RecurranceListViewController.h"
#import "CoreDataManager.h"

/// forward button tag
#define FORWARD_BUTTON_TAG      2100

/// backward button tag
#define BACKWARD_BUTTON_TAG     2101

@implementation RecurranceListViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) addCalendarView {
    kalViewController = [[KalViewController alloc] init];
    kalViewController.view.tag = KAL_VIEW_TAG;
    kalViewController.dataSource = dataSource;
    kalViewController.delegate = self;
    [kalViewController.view setFrame:CGRectMake(0, 0, 320, 415)];
    [kalViewController.view setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCalendarView];
    
    // forward button
    UIButton* forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(285, 330, 30, 30)];
    forwardButton.tag = FORWARD_BUTTON_TAG;
    [forwardButton addTarget:self action:@selector(forwardButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIImage *forwardImage = [UIImage imageNamed:@"forward1.png"];
    [forwardButton setBackgroundImage:forwardImage forState:UIControlStateNormal];
    [self.view addSubview:forwardButton];
    [forwardButton release];
     
    // backward button
    UIButton* backwardButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 375, 30, 30)];
    backwardButton.tag = BACKWARD_BUTTON_TAG;
    [backwardButton addTarget:self action:@selector(backwardButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIImage *backwardImage = [UIImage imageNamed:@"backward1.png"];
    [backwardButton setBackgroundImage:backwardImage forState:UIControlStateNormal];
    [backwardButton setHidden:YES];
    [self.view addSubview:backwardButton];
    [backwardButton release];
}

-(void)addEntity {
    NSAssert(false, @"Should be implemented in derived classes.");
}

-(void) backwardButtonAction
{
    UIToolbar* toolbar = (UIToolbar*)[self.view viewWithTag:288];
    toolbar.hidden = NO;
    
    [kalViewController.view setHidden:YES];
    [[self.view viewWithTag:BACKWARD_BUTTON_TAG] setHidden:YES];
    
    [self.view bringSubviewToFront:[self.view viewWithTag:FORWARD_BUTTON_TAG]];
    [[self.view viewWithTag:FORWARD_BUTTON_TAG] setHidden:NO];
    
    //Show edit bar button item.
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEntity)];
    NSArray* arrayOfButtons = [[NSArray alloc] initWithObjects:addBarButton, nil];
    self.navigationItem.rightBarButtonItems = arrayOfButtons;
    [arrayOfButtons release];
    [addBarButton release];
}

-(void) forwardButtonAction
{
    UIToolbar* toolbar = (UIToolbar*)[self.view viewWithTag:288];
    toolbar.hidden = YES;
    
    [kalViewController.view setHidden:NO];
    [kalViewController reloadData];
    if ([self.view viewWithTag:KAL_VIEW_TAG]) {
        [self.view bringSubviewToFront:kalViewController.view];
    } else {
        [self.view addSubview:kalViewController.view];
    }
    
    [[self.view viewWithTag:FORWARD_BUTTON_TAG] setHidden:YES];
    [self.view bringSubviewToFront:[self.view viewWithTag:BACKWARD_BUTTON_TAG]];
    [[self.view viewWithTag:BACKWARD_BUTTON_TAG] setHidden:NO];
    
    //Hide edit bar button item.
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - TransferViewControllerDelegate

// add in list
-(void)didSavedTransfer:(NSManagedObject *)managedObject {
    if (managedObject) {
        [listOfItems addObject:managedObject];
    }
    [tableView reloadData];
    [kalViewController reloadData];
}

-(void)didDeletedTransfer {
    [tableView reloadData];
    [kalViewController reloadData];
}

@end
