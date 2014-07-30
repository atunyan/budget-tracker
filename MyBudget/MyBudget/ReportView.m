/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */
#import "ReportView.h"
#import "Constants.h"
#import "Report.h"
#import "MOUser.h"
#import "MOReport.h"

#import <Foundation/NSAttributedString.h>

/// view title
#define VIEW_TITLE      @"Graphic view"

@implementation ReportView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        factor = 1;
        pointArray =[[NSMutableArray alloc] init];
        tagsArray =[[NSMutableArray alloc] init];
        yAxisValueArray =[[NSMutableArray alloc] init];
        labelTag = 3000;
        legendsTitleArray = [[NSArray arrayWithObjects:NSLocalizedString(@"Incomes", nil), NSLocalizedString(@"Payments", nil), nil] retain];
    }
    return self;
}

-(void)updateView {
    if(report){
        [report release];
    }
    report = [[Report alloc] initWithData:[MOUser instance]];
    
    [self createTitle:NSLocalizedString(VIEW_TITLE, nil)];
}

-(float) findMaximumValue {
    float maxValue = 0; 
    int nPeriod = [self periodMonthNumber];
    for (int i = 0 ; i <= nPeriod; ++i) {
        float val = [[report.incomeArray objectAtIndex:i] floatValue];
        maxValue = (maxValue > val) ? maxValue : val;
        val = [[report.paymentArray objectAtIndex:i] floatValue];
        maxValue = (maxValue > val) ? maxValue : val;
    }
    return maxValue;
}

-(void) drawGrid:(CGRect) rect {    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    
    // crdeate currency label
    NSString* currency = [MOUser instance].setting.currency;
    UILabel* currencyLabel = [[UILabel alloc] init];
    currencyLabel.frame = CGRectMake(1, rect.origin.y - 15, 40, 10);
    currencyLabel.text = currency;
    currencyLabel.textAlignment = UITextAlignmentRight;
    currencyLabel.font = [UIFont systemFontOfSize:8];
    currencyLabel.tag = VIEW_COMMON_TAG;
    [self addSubview:currencyLabel];
    [currencyLabel release];
    
    // draw lines
    CGFloat gridNumber = [self periodMonthNumber];
    CGFloat offset =  rect.size.width / gridNumber; 
    CGPoint startPoint;
    [pointArray  removeAllObjects];
    for (int i = 0; i <= gridNumber; ++i) {
        startPoint =CGPointMake(rect.origin.x + i*offset, rect.origin.y);
        [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(rect.origin.x + i*offset, rect.origin.y + rect.size.height + 5)]];
        CGContextMoveToPoint(context,startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, startPoint.x ,  startPoint.y + rect.size.height);
        CGContextStrokePath(context);
    }
    offset =  rect.size.height / 4; ///@todo needs  to  determine  row count ... 
    for (int i = 0; i <= 4; ++i) {
        startPoint =CGPointMake(rect.origin.x, rect.origin.y + i*offset);
        CGContextMoveToPoint(context,startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, startPoint.x + rect.size.width,  startPoint.y );
        CGContextStrokePath(context);
        ///
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(1, startPoint.y - 4, 40, 10)];
        label.text = [yAxisValueArray objectAtIndex:i];            
        label.font = [UIFont boldSystemFontOfSize:8];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = [UIColor darkGrayColor];
        
        NSNumber* number = [[NSNumber alloc] initWithInt:labelTag];
        label.tag = labelTag++;
        [tagsArray addObject:number];
        [number release];
        [self addSubview:label];
        ///
    }
    CGContextStrokePath(context);
}

-(void) drawNode:(CGPoint) point color:(CGColorRef) color {
    CGRect circleRect = CGRectMake(point.x - 3, point.y - 3, 6, 6);
    CGContextRef context = UIGraphicsGetCurrentContext();   
    CGContextSetLineWidth(context, 1.5);
  
    CGContextSetRGBFillColor(context, 255, 255,  255, 1);
    CGContextFillEllipseInRect(context, circleRect);
        
    CGContextSetRGBStrokeColor(context, CGColorGetComponents(color)[0], CGColorGetComponents(color)[1], CGColorGetComponents(color)[2], CGColorGetAlpha(color));
    CGContextStrokeEllipseInRect(context, circleRect);
    CGContextSetLineWidth(context, 2);
}

-(void)drawLinesInRect:(CGRect)rect byArray:(NSArray*)array byColor:(UIColor*)color {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    int gridNumber = [self periodMonthNumber];
    CGFloat offset = rect.size.width / gridNumber;
    CGPoint startPoint;

    float floatValue = [[array objectAtIndex:gridNumber] floatValue];
    startPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - factor * floatValue);
    NSMutableArray* nodeArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < gridNumber; ++i) {
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        float val = [[array objectAtIndex:gridNumber - i - 1] floatValue];
        CGContextAddLineToPoint(context, startPoint.x + offset, rect.origin.y + rect.size.height - factor * val);
        CGContextStrokePath(context);
        startPoint = CGPointMake(startPoint.x + offset, rect.origin.y + rect.size.height - factor * val);
        [nodeArray addObject:[NSValue valueWithCGPoint:startPoint]];
    }
    for (NSValue* value in nodeArray) {
        CGPoint p = [value CGPointValue];
        [self drawNode:p color:color.CGColor];
    }
    [nodeArray release];
}

-(void) drawIncome:(CGRect)rect {
    [self drawLinesInRect:rect byArray:report.incomeArray byColor:[UIColor greenColor]];
}

-(void) drawPayments:(CGRect)rect {
    [self drawLinesInRect:rect byArray:report.paymentArray byColor:[UIColor magentaColor]];
}

-(void) removeLables {
    for (NSNumber* val in tagsArray) {
        UILabel* label = (UILabel*)[self viewWithTag:[val integerValue]];
        [label removeFromSuperview];
    }
    [tagsArray removeAllObjects];
    labelTag = 3000;
}

-(void) drawTextCentered:(CGContextRef)ctx point:(CGPoint)point string:(NSString*)string {
    float fontSize = ([self periodMonthNumber] == 12)? 8:11;
    CGSize textSize = [string sizeWithFont: [UIFont boldSystemFontOfSize:fontSize] constrainedToSize: self.frame.size lineBreakMode: UILineBreakModeWordWrap];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(point.x - (textSize.width + 1)/2, point.y, textSize.width +2, textSize.height)];
    label.text = string;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor darkGrayColor];
    
    NSNumber* number = [[NSNumber alloc] initWithInt:labelTag];
    label.tag = labelTag++;
    [tagsArray addObject:number];
    [number release];
    [self addSubview:label];
    [label release];
}

-(void) drawGraphicSign:(CGRect) rect {
    CGContextRef  context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < [pointArray count]; ++i) {
        NSString*  string =[report monthNameBefore:[self periodMonthNumber] - i];
        [self drawTextCentered:context point:[[pointArray objectAtIndex:i] CGPointValue] string:string];
    }
}

-(void) drawGraphic:(CGRect)rect {
    [self drawIncome:rect];
    [self drawPayments:rect];
    [self drawGraphicSign:rect];
}

-(NSString*) trimValue:(NSString*) str {
    BOOL needToStop = FALSE;
    while (!needToStop &&([str characterAtIndex:[str length]  -1] == '0' ||(needToStop = [str characterAtIndex:[str length]  -1] == '.'))) {
        str = [str substringToIndex:[str length]  -1 ];
    }
    return str;
}

-(float) calculateFactor:(CGRect)rect {
    float maxVal =  [self findMaximumValue];
    int _factor = 1;
    while (maxVal > 10) {
        maxVal/= 10;
        _factor *=10;
    }
    
    int multiplier = maxVal + 1;
    factor = rect.size.height/(multiplier * _factor );
    [yAxisValueArray removeAllObjects];
    for (int i = 0 ; i < 4; ++i) {
        float div = ((4 - i)/(float)4) ;
        float val = (multiplier * _factor)*div;
        int intVal = val;
        
        if(val > 10000000){
            [yAxisValueArray addObject:[NSString stringWithFormat:@"%dK", intVal/1000]];            
        } else {
            NSString* str = [NSString stringWithFormat:@"%.2f", val];
            [yAxisValueArray addObject:[self trimValue:str]];
        }        
    }
    [yAxisValueArray addObject:@"0"];

    return factor;
}

-(UIColor*)propertyColorByIndex:(int)index {
    UIColor* color = [UIColor greenColor];
    switch (index) {
        case 0:
            color = [UIColor greenColor];     //  Incomes
            break;
        case 1:
            color = [UIColor magentaColor];   //  Payments
            break;
        default:
            break;
    }
    return color;
}

- (void)drawRect:(CGRect)rect {
    CGRect graphicRect = CGRectMake(45, 80, rect.size.width - 60, rect.size.height - 130);
    factor = [self calculateFactor:graphicRect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
    CGContextFillRect(context, rect);
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    
    CGContextFillRect(context, graphicRect);
    [self removeLables];
    [self drawGrid:graphicRect];
    [self drawGraphic:graphicRect];
    
    CGRect legendsRect = CGRectMake(45, graphicRect.origin.y + graphicRect.size.height + 30, 320, 20);
    [self drawLegends:legendsRect titleArray:legendsTitleArray];
}

-(void) dealloc {
    [pointArray release];
    [tagsArray release];
    [yAxisValueArray release];
    [legendsTitleArray release];
    [super dealloc];
}

@end
