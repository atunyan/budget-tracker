/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 25/01/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "ImpressumViewController.h"
#import "CoreDataManager.h"
#import "MOUser.h"

#import <QuartzCore/QuartzCore.h>

/// scroll view tag
#define SCROLL_VIEW_TAG         200

@implementation ImpressumViewController {
    ADBannerView *_bannerView;
}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBeginBannerViewActionNotification:) name:BannerViewActionWillBegin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishBannerViewActionNotification:) name:BannerViewActionDidFinish object:nil];
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

-(void)infoPage {
    UIScrollView* scrollView = (UIScrollView*)[self.view viewWithTag:SCROLL_VIEW_TAG];
    if (!scrollView) {
        scrollView = [[UIScrollView alloc] init];
        scrollView.tag = SCROLL_VIEW_TAG;
        scrollView.frame = CGRectMake(10, 10, 300, 325);

        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"impressumBackground.png"]];
        [backgroundView setFrame:CGRectMake(10, 5, 300, 345)];
        [self.view addSubview:backgroundView];
        [backgroundView release];

        UIImageView *designImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"portfolio_v2_863small.jpg"]];
        [designImageView setFrame:CGRectMake(185, 30, 100, 100)];
        
        // title label
        UILabel* companyTitleLabel = [[UILabel alloc] init];
        companyTitleLabel.frame = CGRectMake(80, 5, 130, 20);
        companyTitleLabel.text = NSLocalizedString(@"impressum.company.name", nil);
        companyTitleLabel.font = [UIFont boldSystemFontOfSize:15];
        companyTitleLabel.backgroundColor = [UIColor clearColor];
        
        // company content1
        UILabel* companyContentLabel = [[UILabel alloc] init];
        companyContentLabel.text = NSLocalizedString(@"impressum.company.content", nil);
        companyContentLabel.font = [UIFont systemFontOfSize:12];
        companyContentLabel.backgroundColor = [UIColor clearColor];
        companyContentLabel.frame = CGRectMake(15, 25, 160, 115);
        companyContentLabel.numberOfLines = 0;
        
        // company content2
        NSString *text = NSLocalizedString(@"impressum.company.content2", nil);
        CGSize labelsize = [text sizeWithFont:companyContentLabel.font constrainedToSize:CGSizeMake(260, 2000.0) lineBreakMode:UILineBreakModeWordWrap];
        UILabel* companyContentLabel2 = [[UILabel alloc] init];
        companyContentLabel2.text = NSLocalizedString(@"impressum.company.content2", nil);
        companyContentLabel2.font = [UIFont systemFontOfSize:12];
        companyContentLabel2.backgroundColor = [UIColor clearColor];
        companyContentLabel2.frame = CGRectMake(15, 135, 260, labelsize.height);
        companyContentLabel2.numberOfLines = 0;
        
        [scrollView addSubview:designImageView];
        [designImageView release];
        [scrollView addSubview:companyTitleLabel];
        [companyTitleLabel release];
        [scrollView addSubview:companyContentLabel];
        [companyContentLabel release];
        [scrollView addSubview:companyContentLabel2];
        [companyContentLabel2 release];
        
        scrollView.contentSize = CGSizeMake(245, 155 + labelsize.height);
        [self.view addSubview:scrollView];
        [scrollView release];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"budget_bg.png"]];
    self.title = NSLocalizedString(@"impressum", nil);
    
    [self infoPage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self layoutAnimated:NO];
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
    [super dealloc];
}


@end
