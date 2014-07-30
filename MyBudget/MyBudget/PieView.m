/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/29/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "PieView.h"
#import "Report.h"
#import "MOUser.h"
#import "MOSetting.h"
#import "MOReport.h"
#import "CoreDataManager.h"
#import "PieInfo.h"
#import "PieLegendsView.h"

/// view title
#define VIEW_TITLE      @"Pie view"

/// legend's rectangle height
#define LEGEND_HEIGHT   20

/// Converts degrees to radians
static inline float radians(double degrees) { return degrees * M_PI / 180; }

@implementation PieView

-(void)calculatePercents {
    NSNumber *sumPayments = [pieArray valueForKeyPath:@"@sum.payments"];
    
    for (PieInfo* pieInfo in pieArray) {
        float percent = [pieInfo.payments floatValue] * 100 / [sumPayments floatValue];
        pieInfo.percent = percent;
    }
}

-(void)createLegendsView {
    int height = LEGEND_HEIGHT * [pieArray count];
    CGSize contentSize = CGSizeMake(320, height);
    
    [legendsScrollView removeFromSuperview];
    CGRect legendsScrollViewFrame = CGRectMake(0, 205, 320, 160);
    legendsScrollView = [[UIScrollView alloc] initWithFrame:legendsScrollViewFrame];
    legendsScrollView.backgroundColor = [UIColor clearColor];
    legendsScrollView.contentSize = contentSize;
    
    CGRect legendsViewFrame = CGRectMake(0, 0, 320, contentSize.height);
    PieLegendsView* legendsView = [[PieLegendsView alloc] initWithFrame:legendsViewFrame withPieArray:pieArray];
    [legendsScrollView addSubview:legendsView];
    [legendsView release];
    
    [self addSubview:legendsScrollView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self updateView];
    }
    return self;
}

-(void)correctingParcentsPies {
    float sum = 0;
    for (PieInfo* pieInfo in pieArray) {
        float percent = round(pieInfo.percent);
        if (percent == 0) {
            percent = 1;
        }
        pieInfo.percent = percent;
        
        sum += percent;
    }
    
    if (sum != 100) {    // if sum != 100, then find max percent
        PieInfo* pieInfo = [[PieInfo alloc] init];
        float max = 0;
        for (PieInfo* info in pieArray) {
            if (info.percent > max) {
                max = info.percent;
                if (pieInfo) {
                    [pieInfo release];
                    pieInfo = nil;
                }
                pieInfo = [info retain];
            }
        }
        if (sum > 100) {    // if sum > 100, decrease max percent
            pieInfo.percent = pieInfo.percent - abs(sum - 100);
        } else if (sum < 100) {      // if sum < 100, increase max percent
            pieInfo.percent = pieInfo.percent + abs(sum - 100);
        }        
        [pieInfo release];
    }
}

-(void)correctingSequencePies {
    NSMutableArray* smallPercentsArray = [[NSMutableArray alloc] init];
    NSMutableArray* bigPercentsArray = [[NSMutableArray alloc] init];
    
    int count = [pieArray count];
    for (int i = 0; i < count; ++i) {
        PieInfo* pieInfo = [pieArray objectAtIndex:i];
        if (pieInfo.percent <= 3) {
            [smallPercentsArray addObject:[NSNumber numberWithInt:i]];
        } else {
            [bigPercentsArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    NSMutableArray* newArray = [[NSMutableArray alloc] init];
    
    int smallCount = [smallPercentsArray count];
    int bigCount = [bigPercentsArray count];
    int maxCount = bigCount > smallCount ? bigCount : smallCount;
    for (int i = 0; i < maxCount; ++i) {
        if (i < smallCount) {
            PieInfo* pieInfo = [pieArray objectAtIndex:[[smallPercentsArray objectAtIndex:i] intValue]];
            [newArray addObject:pieInfo];
        }
        if (i < bigCount) {
            PieInfo* pieInfo = [pieArray objectAtIndex:[[bigPercentsArray objectAtIndex:i] intValue]];
            [newArray addObject:pieInfo];
        }
    }
    pieArray = [newArray retain];
    [newArray release];    
    [smallPercentsArray release];
    [bigPercentsArray release];
}

-(void)updateView {
    
    if(report){
        [report release];
    }
    report = [[Report alloc] initWithData:[MOUser instance]];
    
    [self createTitle:NSLocalizedString(VIEW_TITLE, nil)];
    
    if (pieArray) {
        [pieArray release];
        pieArray = nil;
    }
    //int nPeriod = [self periodMonthNumber];
    pieArray = [[[CoreDataManager instance] piesForReportFromStartMonth:[MOUser instance].setting.report.startDate  toEndMonth:[MOUser instance].setting.report.endDate] retain];
    [self calculatePercents];
    [self correctingParcentsPies];
    [self correctingSequencePies];
    
    // add legends view
    [self createLegendsView];
}

+(UIColor*)colorByIndex:(int)index {
    UIColor* color = nil;
    
    switch (index) {
        case 0:
            color = [UIColor blueColor];
            break;
        case 1:
            color = [UIColor redColor];
            break;
        case 2:
            color = [UIColor orangeColor];
            break;
        case 3:
            color = [UIColor cyanColor];
            break;
        case 4:
            color = [UIColor magentaColor];
            break;
        case 5:
            color = [UIColor brownColor];
            break;
        case 6:
            color = [UIColor greenColor];
            break;
        case 7:
            color = [UIColor purpleColor];
            break;

        default: {
            float red = ((index * 100) % 256 / 255.0);
            float green = ((index * 5) % 256 / 255.0);
            float blue = ((index * 200) % 256 / 255.0);
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        }
            break;
    }
    
    return color;
}

-(float)degreeByPercent:(float)percent {
    float degree = 360 * percent / 100;
    return degree;
}

-(CGPoint)percentPositionByCenter:(CGPoint)center byRadius:(CGFloat)radius byStartDegree:(double)startDegree byDegree:(double)degree {
    float halfDegree = degree / 2 + startDegree;

    int x = 0;
    int y = 0;
    if (halfDegree >= 0 && halfDegree <= 90) {                          //  1st quarter
        x = center.x + radius * cos(radians(halfDegree));
        y = center.y + radius * sin(radians(halfDegree));
        if (halfDegree <= 45) {
            x += 5;
            y -= 2;
        } else {
            x += 2;
            y += 2;
        }
    } else if (halfDegree > 90 && halfDegree <= 180) {                  //  2nd quarter
        x = center.x - radius * cos(radians(180 - halfDegree));
        y = center.y + radius * sin(radians(180 - halfDegree));
        if (halfDegree <= 135) {
            x -= 15;
            y += 5;
        } else {
            x -= 35;
        }
    } else if (halfDegree > 180 && halfDegree <= 270) {                 //  3th quarter
        x = center.x - radius * cos(radians(halfDegree - 180));
        y = center.y - radius * sin(radians(halfDegree - 180));
        if (halfDegree <= 225) {
            if (degree < 35) {
                x -= 35;
            } else {
                x -= 40;
            }
            y -= 10;
        } else {
            x -= 15;
            y -= 20;
        }
    } else if (halfDegree > 270 && halfDegree <= 360) {                 //  4th quarter
        x = center.x + radius * cos(radians(360 - halfDegree));
        y = center.y - radius * sin(radians(360 - halfDegree));
        if (halfDegree <= 315) {
            x += 0;
            y -= 15;
        } else {
            x += 10;
            y -= 2;
        }
    }
    CGPoint position = CGPointMake(x, y);
    return position;
}

-(void)createPercentLabelInPosition:(CGPoint)point percent:(float)percent {
    UILabel* percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, 35, 15)];
    int intPercent = percent;
    percentLabel.text = [NSString stringWithFormat:@"%i%%", intPercent];
    percentLabel.font = [UIFont systemFontOfSize:12];
    percentLabel.textColor = [UIColor blackColor];
    percentLabel.backgroundColor = [UIColor clearColor];
    percentLabel.tag = VIEW_COMMON_TAG;
    [self addSubview:percentLabel];
    [percentLabel release];
}

-(void)drawPies:(CGRect)rect {
	CGFloat x = CGRectGetWidth(rect) / 2;
	CGFloat y = rect.origin.y + CGRectGetHeight(rect) / 2;
    float radius = 60;
    
    // Get the graphics context and clear it
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextClearRect(ctx, rect);
    
	// define stroke color
	CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
    
	// define line width
	CGContextSetLineWidth(context, 1.0);
    
    // need some values to draw pie charts 
    double startDegree = 0;
    double degree = 0;

    // DON'T REMOVE - FOR TEST
//    for (int i = 0; i <= 360; i += 45) {
//        CGPoint percentPosition = [self percentPositionByCenter:CGPointMake(x, y) byRadius:radius byStartDegree:startDegree byDegree:45];
//        [self createPercentLabelInPosition:percentPosition percent:45];
//        startDegree = i;
//    }

    int index = 0;
    for (PieInfo* pieInfo in pieArray) {
        degree = [self degreeByPercent:pieInfo.percent];
        
        CGContextSetFillColor(context, CGColorGetComponents([[PieView colorByIndex:index] CGColor]));
        
        CGContextMoveToPoint(context, x, y);
        CGContextAddArc(context, x, y, radius, radians(startDegree), radians(startDegree + degree), 0);
        
        CGContextClosePath(context); 
        CGContextFillPath(context);
        
        // draw percent text
        CGPoint percentPosition = [self percentPositionByCenter:CGPointMake(x, y) byRadius:radius byStartDegree:startDegree byDegree:degree];
        [self createPercentLabelInPosition:percentPosition percent:pieInfo.percent];
        
        startDegree += degree;
        index++;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{    
    // remove labels
    NSArray* views = self.subviews;
    for (UIView* view in views) {
        if (view.tag == VIEW_COMMON_TAG) {
            [view removeFromSuperview];
        }
    }
    
    if ([pieArray count] > 0) { 
        // draw pies
        CGRect pieRect = CGRectMake(0, 55, 320, 150);
        [self drawPies:pieRect];
    } else {
        // There are no payments
        UILabel* label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 200, 320, 30);
        label.text = NSLocalizedString(@"There are no payments", nil);
        label.tag = VIEW_COMMON_TAG;
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
        [self addSubview:label];
        [label release];
    }
}

-(void)dealloc {
    [pieArray release];
    [super dealloc];
}

@end
