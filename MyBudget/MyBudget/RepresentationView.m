/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/29/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "RepresentationView.h"
#import "Report.h"
#import "MOUser.h"
#import "MOSetting.h"
#import "MOReport.h"

/// title view tag
#define TITLE_VIEW_TAG      5000

@implementation RepresentationView

-(void)createTitle:(NSString*)title {
    UIView* headerView = [self viewWithTag:TITLE_VIEW_TAG];
    if (headerView) {
        [headerView removeFromSuperview];
    }
    
    // Create header view
    headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 320, 50);
    headerView.backgroundColor = [UIColor clearColor];
    headerView.tag = TITLE_VIEW_TAG;
    
    // Create header view
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 320, 30);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [headerView addSubview:titleLabel];
    [titleLabel release];
    
    // Create period view
    UILabel* periodLabel = [[UILabel alloc] init];
    periodLabel.frame = CGRectMake(0, 30, 320, 20);
    periodLabel.backgroundColor = [UIColor clearColor];
    periodLabel.font = [UIFont systemFontOfSize:14];
    periodLabel.textAlignment = UITextAlignmentCenter;
    //int nPeriod = [self periodMonthNumber];
    periodLabel.text = [report periodFromStartDate:[MOUser instance].setting.report.startDate 
                                         toEndDate:[MOUser instance].setting.report.endDate];
    [headerView addSubview:periodLabel];
    [periodLabel release];
    
    [self addSubview:headerView];
    [headerView release];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(int) periodMonthNumber {
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags = NSMonthCalendarUnit ;
	
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:[MOUser instance].setting.report.startDate
												  toDate:[MOUser instance].setting.report.endDate options:0];
    
    int periodNumber = [components month];
    [gregorian release];

    return ( periodNumber == 0 ) ? 1 : periodNumber;
}

-(void)updateView {
    
}

-(void) drawPropertyByContext:(CGContextRef)ctx point:(CGPoint)point string:(NSString*)string {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, 70, 15)];
    label.text = string;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    label.tag = VIEW_COMMON_TAG;
    [self addSubview:label];
    [label release];
}

-(UIColor*)propertyColorByIndex:(int)index {
    NSAssert(false, @"Should be implemented in derived classes.");
    return nil;
}

-(void)drawLegends:(CGRect)rect titleArray:(NSArray*)titleArray {
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    float x = rect.origin.x;
    float y = rect.origin.y;
    
    int drawRectWidth = 15;
    int drawRectHeight = 10;
    int drawRectLineWidth = 2;
    
    int fillRectWidth = drawRectWidth - drawRectLineWidth * 2;
    int fillRectHeight = drawRectHeight - drawRectLineWidth * 2;
    
    // set rectangle line color
    float gray = 0.8f;    
    [[UIColor colorWithRed:gray green:gray blue:gray alpha:1.0] setStroke];   
    
    for (int i = 0; i < [titleArray count]; ++i) {
        // draw rectangles       
        [[UIColor clearColor] setFill];
        CGRect drawRect = CGRectMake(x, y, drawRectWidth, drawRectHeight);
        drawRect = CGRectStandardize(drawRect);    
        CGContextFillRect(context, drawRect);
        CGContextStrokeRectWithWidth(context, drawRect, drawRectLineWidth);
        
        [[self propertyColorByIndex:i] setFill];
        CGRect fillRect = CGRectMake(x + drawRectLineWidth, y + drawRectLineWidth, fillRectWidth, fillRectHeight);
        CGContextFillRect(context, fillRect);
        
        // draw texts
        NSString*  property = [titleArray objectAtIndex:i];
        [self drawPropertyByContext:context point:CGPointMake(x + drawRectWidth + 5, y - 3) string:property];
        x += rect.size.width / [titleArray count];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc {
    [report release];
    [super dealloc];
}

@end
