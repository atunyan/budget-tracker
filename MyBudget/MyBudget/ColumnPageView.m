/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 3/6/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "ColumnPageView.h"
#import "ColumnReportInfo.h"
#import "MOAccount.h"
#import "MOUser.h"
#import "MOSetting.h"

/// tag for view, that should be removed before updating
#define VIEW_COMMON_TAG         3000

/// top margin
#define TOP_MARGIN              15

/// label's width
#define LABEL_WIDTH             45

/// line's left margin
#define LINE_LEFT_MARGIN        (LABEL_WIDTH + 5)

@implementation ColumnPageView

-(id)initWithFrame:(CGRect)frame withInfoArray:(NSArray*)array withYAxisValueArray:(NSArray*)yArray
{
    self = [super initWithFrame:frame];
    if (self) {
        infoArray = [array retain];
        yAxisValueArray = [yArray retain];
        zeroYPosition = 0;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) drawGrid:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    
    // crdeate currency label
    NSString* currency = [MOUser instance].setting.currency;
    UILabel* currencyLabel = [[UILabel alloc] init];
    currencyLabel.frame = CGRectMake(1, 1, LABEL_WIDTH, 10);
    currencyLabel.text = currency;
    currencyLabel.textAlignment = UITextAlignmentRight;
    currencyLabel.font = [UIFont systemFontOfSize:8];
    currencyLabel.tag = VIEW_COMMON_TAG;
    [self addSubview:currencyLabel];
    [currencyLabel release];
    
    // draw lines
    int count = [yAxisValueArray count];
    CGFloat offset = (rect.size.height - 30) / count;
    CGPoint startPoint = CGPointZero;
    for (int i = 0; i < count; ++i) {
        startPoint = CGPointMake(LINE_LEFT_MARGIN, rect.origin.y + i * offset + TOP_MARGIN);
        if ([@"0" isEqualToString:[yAxisValueArray objectAtIndex:i]]) {
            zeroYPosition = startPoint.y;
            float minValue = [[yAxisValueArray lastObject] floatValue];
            if (minValue < 0) {
                CGContextSetLineWidth(context, 2.0);
            }            
        } else {
            CGContextSetLineWidth(context, 1.0);
        }
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, startPoint.x + rect.size.width - 70, startPoint.y);
        CGContextStrokePath(context);
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(1, startPoint.y - 4, LABEL_WIDTH, 10)];
        label.text = [yAxisValueArray objectAtIndex:i];
        label.font = [UIFont boldSystemFontOfSize:9];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = [UIColor darkGrayColor];
        label.tag = VIEW_COMMON_TAG;
        [self addSubview:label];
        [label release];
    }
    
    NSString* maxString = [((NSString*)[yAxisValueArray objectAtIndex:0])  stringByReplacingOccurrencesOfString:@"K" withString:@"000"];
    float maxValue = [maxString floatValue];
    
    NSString* minString = [((NSString*)[yAxisValueArray lastObject])  stringByReplacingOccurrencesOfString:@"K" withString:@"000"];
    float minValue = [minString floatValue];
    if (maxValue != 0 && maxValue > fabsf(minValue)) {
        factor = (zeroYPosition - (rect.origin.y + TOP_MARGIN)) / maxValue;
    } else if (minValue != 0 && fabsf(minValue) > maxValue) {
        factor = (startPoint.y - zeroYPosition) / minValue * -1;
    }
    
    CGContextStrokePath(context);
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

-(void)drawTextInRect:(CGRect)rect withText:(NSString*)text {
    UILabel* textLabel = [[UILabel alloc] init];
    textLabel.frame = rect;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = text;
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.tag = VIEW_COMMON_TAG;
    [self addSubview:textLabel];
    [textLabel release];
}

-(void)drawColumnInRect:(CGRect)rect withInfo:(ColumnReportInfo*)info {
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    int drawRectWidth = 15;

    // draw income column
    float value = [info.incomeValue floatValue];
    float y = zeroYPosition - factor * value;
    [info.incomeColor setFill];
    CGRect drawRect = CGRectMake(rect.origin.x, y, drawRectWidth, factor * value);
    drawRect = CGRectStandardize(drawRect);
    CGContextFillRect(context, drawRect);

    // draw payment column
    value = [info.paymentValue floatValue];
    y = zeroYPosition - factor * value;
    [info.paymentColor setFill];
    drawRect = CGRectMake(rect.origin.x + drawRectWidth + 5, y, drawRectWidth, factor * value);
    drawRect = CGRectStandardize(drawRect);
    CGContextFillRect(context, drawRect);

    // draw account column
    value = [info.account.amount floatValue];
    y = zeroYPosition - factor * value;
    [info.accountColor setFill];
    drawRect = CGRectMake(rect.origin.x + (drawRectWidth + 5) * 2, y, drawRectWidth, factor * value);
    drawRect = CGRectStandardize(drawRect);
    CGContextFillRect(context, drawRect);

    // draw account name
    CGRect textRect = CGRectMake(rect.origin.x - 30, rect.size.height - 30, rect.size.width - 10, 20);
    [self drawTextInRect:textRect withText:info.account.name];
}

-(void)drawColumns:(CGRect)rect {
    int count = [infoArray count];
    int componentWidth = 125;
    for (int i = 0; i < count; ++i) {
        CGRect componentViewRect = CGRectMake(i * componentWidth +  LINE_LEFT_MARGIN + 35, TOP_MARGIN, componentWidth, rect.size.height);
        [self drawColumnInRect:componentViewRect withInfo:[infoArray objectAtIndex:i]];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self removeLabels];
    [self drawGrid:rect];
    [self drawColumns:rect];
}

-(void)dealloc {
    [infoArray release];
    [yAxisValueArray release];
    [super dealloc];
}

@end
