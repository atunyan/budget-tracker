/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/14/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "ColorPickerViewController.h"
#import "MOSetting.h"
#import "CoreDataManager.h"
#import "MOUser.h"

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/CoreAnimation.h>


@implementation ColorPickerViewController

@synthesize colorWheel;

-(void) saveTheme {
    MOSetting* theme = [[CoreDataManager instance] setting];
    theme.defaultColor = [NSKeyedArchiver archivedDataWithRootObject:self.view.backgroundColor];
    [MOUser instance].setting = theme;
    
    [[CoreDataManager instance] saveContext];
	[self.view setNeedsDisplay];
    [self.navigationController popViewControllerAnimated:YES];
}

/// creates pay bar button
-(void) createSaveBarButton {
    UIBarButtonItem* saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveTheme)];
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    [saveBarButtonItem release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSaveBarButton];
    
    self.view.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
    UIImage* image = [UIImage imageNamed:@"colorWheel.png"];
    colorWheel = [[ColorPickerImageView alloc] initWithImage:image];
	colorWheel.pickedColorDelegate = self;
    colorWheel.userInteractionEnabled = YES;
    colorWheel.frame = CGRectMake((self.view.frame.size.width - image.size.width )/2, 30, image.size.width, image.size.height);
    [self.view addSubview:colorWheel];
}

- (void) pickedColor:(UIColor*)color {
	self.view.backgroundColor = color;
}

@end
