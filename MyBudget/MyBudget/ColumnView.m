/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/29/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "ColumnView.h"
#import "ColumnScrollView.h"

/// view title
#define VIEW_TITLE      @"Column view"

@implementation ColumnView

-(void)createScrollView {
    [columnScrollView removeFromSuperview];
    columnScrollView = [[ColumnScrollView alloc] initWithFrame:CGRectMake(0, 60, 320, 270) withReport:report];
    [self addSubview:columnScrollView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        legendsTitleArray = [[NSArray arrayWithObjects:NSLocalizedString(@"Incomes", nil), NSLocalizedString(@"Payments", nil), NSLocalizedString(@"Account", nil), nil] retain];
        [self updateView];
    }
    return self;
}

-(void)updateView {

    [self createTitle:NSLocalizedString(VIEW_TITLE, nil)];
    [self createScrollView];
}

-(UIColor*)propertyColorByIndex:(int)index {
    UIColor* color = [UIColor greenColor];
    switch (index) {
        case 0:
            color = [UIColor greenColor];     //  Incomes
            break;
        case 1:
            color = [UIColor redColor];       //  Payments
            break;
        case 2:
            color = [UIColor orangeColor];    //  Current
            break;
        default:
            break;
    }
    return color;
}

-(void)removeLabels {
    // remove labels
    NSArray* views = self.subviews;
    for (UIView* view in views) {
        if (view.tag == VIEW_COMMON_TAG) {
            [view removeFromSuperview];
        }
    }
}

- (void)drawRect:(CGRect)rect
{    
    [self removeLabels];
    
    CGRect legendsRect = CGRectMake(20, columnScrollView.frame.origin.y + columnScrollView.frame.size.height + 10, 320, 20);
    [self drawLegends:legendsRect titleArray:legendsTitleArray];
}

-(void)dealloc {
    [legendsTitleArray release];
    [super dealloc];
}

@end
