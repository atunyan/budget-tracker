/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 4/10/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "ReportViewTypes.h"
#import "MOReport.h"
#import "MOUser.h"
#import "MOSetting.h"
#import "CoreDataManager.h"
#import "ReportViewController.h"

@implementation ReportViewTypes {
    ADBannerView *_bannerView;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        report = [[MOUser instance].setting.report retain];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBeginBannerViewActionNotification:) name:BannerViewActionWillBegin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishBannerViewActionNotification:) name:BannerViewActionDidFinish object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Report view types", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutAnimated:NO];
    [self.tableView reloadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - iAd banner methods
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Representation", nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"reportTable.png"];
            cell.textLabel.text = NSLocalizedString(@"Table view", nil);
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"reportColumn.png"];
            cell.textLabel.text = NSLocalizedString(@"Column view", nil);
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"reportPie.png"];
            cell.textLabel.text = NSLocalizedString(@"Pie view", nil);
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"reportGraphic.png"];
            cell.textLabel.text = NSLocalizedString(@"Graphic view", nil);
            break;
        default:
            break;
    }
//    cell.accessoryType = indexPath.row == [report.representation intValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([report.representation intValue] != indexPath.row) {
        report.representation = [NSNumber numberWithInt:indexPath.row];
        [[CoreDataManager instance] saveContext];
    }
    ReportViewController* reportViewController = [[ReportViewController alloc] init];
    [self.navigationController pushViewController:reportViewController animated:YES];
    [reportViewController release];
}

-(void)dealloc {
    [report release];
    [super dealloc];
}

@end
