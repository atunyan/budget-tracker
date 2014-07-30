/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/22/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */
#import "ReportViewController.h"
#import "ReportView.h"
#import "PieView.h"
#import "ColumnView.h"
#import "ReportViewSettings.h"
#import "ReportViewTypes.h"
#import "ReportTableViewController.h"
#import "MOUser.h"
#import "MOSetting.h"
#import "MOReport.h"
#import "CoreDataManager.h"

@implementation ReportViewController {
    ADBannerView *_bannerView;
}

-(id) init {
    self  = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBeginBannerViewActionNotification:) name:BannerViewActionWillBegin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishBannerViewActionNotification:) name:BannerViewActionDidFinish object:nil];
    }
    return self;
}


-(void) createRightBarButtonItems {
    UIBarButtonItem* payBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStyleDone target:self action:@selector(openSettingsPage:)];
    self.navigationItem.rightBarButtonItem = payBarButtonItem;
    [payBarButtonItem release];
}

- (void)openSettingsPage:(UIButton *)item
{
    DurationPickerViewController *durationPickerViewController = [[DurationPickerViewController alloc] initWithStartDate:[MOUser instance].setting.report.startDate andEndDate:[MOUser instance].setting.report.endDate];
    durationPickerViewController.delegate = (id)self;
    durationPickerViewController.title = NSLocalizedString(@"Duration", nil);
    [self.navigationController pushViewController:durationPickerViewController animated:YES];
    [durationPickerViewController release];
}

-(void)didSavedWithStartDate:(NSDate *)startDate andWithEndDate:(NSDate *)endDate {
    if (startDate && endDate) {
        [MOUser instance].setting.report.startDate = startDate;
        [MOUser instance].setting.report.endDate = endDate;
        [[CoreDataManager instance] saveContext];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)showOnlySelectedView {
    int selectedRepresentationType = [[MOUser instance].setting.report.representation intValue];

    [tableViewController.tableView setHidden:YES];
    [graphicView setHidden:YES];
    [pieView setHidden:YES];
    [columnView setHidden:YES];
    
    switch (selectedRepresentationType) {
        case kReportViewTypeTable:
            [tableViewController.tableView setHidden:NO];
            [tableViewController.tableView reloadData];
            break;
        case kReportViewTypeColumn:
            [columnView setHidden:NO];
            [columnView setNeedsDisplay];
            [columnView updateView];
            break;
        case kReportViewTypePie:
            [pieView setHidden:NO];
            [pieView setNeedsDisplay];
            [pieView updateView];
            break;
        case kReportViewTypeGraphic:
            [graphicView setHidden:NO];
            [graphicView setNeedsDisplay];
            [graphicView updateView];
            break;
        default:
            break;
    }
}

-(void)createReportViews {
    int selectedRepresentationType = [[MOUser instance].setting.report.representation intValue];
    
    switch (selectedRepresentationType) {
        case kReportViewTypeTable:
            tableViewController = [[ReportTableViewController alloc] initWithStyle:UITableViewStylePlain];
            tableViewController.tableView.frame = CGRectMake(0, 0, 320, tableViewController.tableView.frame.size.height);
            [self.view addSubview:tableViewController.tableView];
            break;
        case kReportViewTypeColumn:
            columnView = [[ColumnView alloc] initWithFrame:CGRectMake(0, 0, 320, 365)];
            [self.view addSubview:columnView];
            break;
        case kReportViewTypePie:
            pieView = [[PieView alloc] initWithFrame:CGRectMake(0, 0, 320, 365)];
            [self.view addSubview:pieView];
            break;
        case kReportViewTypeGraphic:
            graphicView = [[ReportView alloc] initWithFrame:CGRectMake(0, 0, 320, 365)];
            [self.view  addSubview:graphicView];
            break;
        default:
            break;
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Report", nil);
    [self createRightBarButtonItems];
    
    [self createReportViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self layoutAnimated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showOnlySelectedView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)layoutAnimated:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        _bannerView.frame = CGRectMake(0, self.view.frame.size.height - bannerFrame.size.height, bannerFrame.size.width, bannerFrame.size.height);
        [UIView commitAnimations];

    }else {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        _bannerView.frame = CGRectMake(0, self.view.frame.size.height + bannerFrame.size.height, bannerFrame.size.width, bannerFrame.size.height);
        [UIView commitAnimations];
    }
}

- (void)showBannerView:(ADBannerView *)bannerView animated:(BOOL)animated
{
    _bannerView = bannerView;
    [self layoutAnimated:animated];
    [self.view addSubview:_bannerView];
}

- (void)hideBannerView:(ADBannerView *)bannerView animated:(BOOL)animated
{
    _bannerView = nil;
    [self layoutAnimated:animated];
}

- (void)willBeginBannerViewActionNotification:(NSNotification *)notification
{
}

- (void)didFinishBannerViewActionNotification:(NSNotification *)notification
{
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [tableViewController release];
    [graphicView release];
    [pieView release];
    [columnView release];
    [super dealloc];
}

@end
