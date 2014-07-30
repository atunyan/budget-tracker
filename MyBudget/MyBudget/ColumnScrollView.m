/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 3/5/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "ColumnScrollView.h"
#import "Report.h"
#import "MOUser.h"
#import "MOSetting.h"
#import "MOReport.h"
#import "MOAccount.h"
#import "MOIncome.h"
#import "MOPayment.h"
#import "ColumnReportInfo.h"
#import "CoreDataManager.h"
#import "ColumnPageView.h"
#import "Constants.h"

/// tag for view, that should be removed before updating
#define VIEW_COMMON_TAG             3000

/// horizontal lines count
#define HORIZONTAL_LINES_COUNT      10

@implementation ColumnScrollView

@synthesize report;

-(id)initWithFrame:(CGRect)frame withReport:(Report*)aReport {
    if ((self = [super initWithFrame:frame])) {
        yAxisValueArray =[[NSMutableArray alloc] init];
        columnReportInfoArray = [[NSMutableArray alloc] init];
        
        columnPageArray = [[NSMutableArray alloc] init];
        report = [aReport retain];
        
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        [self updateScrollView];
    }
    return self;
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

-(NSString*)trimValue:(NSString*)str {
    BOOL needToStop = FALSE;
    while (!needToStop && ([str characterAtIndex:[str length] - 1] == '0' || (needToStop = [str characterAtIndex:[str length] - 1] == '.'))) {
        str = [str substringToIndex:[str length] - 1];
    }
    return str;
}

-(float) findMaximumValue {
    float maxValue = 0;
    
    for (ColumnReportInfo* info in columnReportInfoArray) {
        float val = [info.incomeValue floatValue];
        maxValue = (maxValue > val) ? maxValue : val;
        
        val = [info.paymentValue floatValue];
        maxValue = (maxValue > val) ? maxValue : val;
        
        val = [info.account.amount floatValue];
        maxValue = (maxValue > val) ? maxValue : val;
    }
    return maxValue;
}

-(float) findMinimumValue {
    float minValue = 0;
    
    for (ColumnReportInfo* info in columnReportInfoArray) {
        float val = [info.account.amount floatValue];
        minValue = (minValue < val) ? minValue : val;
    }
    return minValue;
}

-(void)calculateFactor:(CGRect)rect {
    float maxValue =  [self findMaximumValue];
    float minValue = [self findMinimumValue];
    int scale = 1;
    
    float maxAbsValue = maxValue;
    BOOL isMaxBig = YES;
    if (maxValue < fabsf(minValue)) {
        maxAbsValue = fabsf(minValue);
        isMaxBig = NO;
    }
    
    while (maxAbsValue > 10) {
        maxAbsValue /= 10;
        scale *= 10;
    }
    float multiplier = maxAbsValue + maxAbsValue * 5/ 100;
    
    [yAxisValueArray removeAllObjects];
    
    int count = HORIZONTAL_LINES_COUNT;
    if (maxValue > 0) {        
        if (!isMaxBig && maxValue > 0) {
            for (int i = 1; i <= HORIZONTAL_LINES_COUNT; ++i) {
                float div = (i / (float)HORIZONTAL_LINES_COUNT);
                float val = (multiplier * scale) * div;
                if (val > maxValue) {
                    count = i;
                    break;
                }
            }
        }
        for (int i = 0 ; i < count; ++i) {
            float div = ((count - i) / (float)HORIZONTAL_LINES_COUNT);
            float val = roundf((multiplier * scale) * div);
            int intVal = val;
            
            if(val > 1000000){
                [yAxisValueArray addObject:[NSString stringWithFormat:@"%dK",intVal/1000]];            
            } else {
                NSString* str = [NSString stringWithFormat:@"%f", val];
                [yAxisValueArray addObject:[self trimValue:str]];
            }
        }
    }
    
    [yAxisValueArray addObject:@"0"];
    
    if (minValue < 0) {
        count = HORIZONTAL_LINES_COUNT;
        if (isMaxBig) {
            for (int i = 1; i <= HORIZONTAL_LINES_COUNT; ++i) {
                float div = (i / (float)HORIZONTAL_LINES_COUNT);
                float val = (multiplier * scale) * div;
                if (val > fabsf(minValue)) {
                    count = i;
                    break;
                }
            }
        }
        for (int i = 1 ; i <= count; ++i) {
            float div = (i / (float)HORIZONTAL_LINES_COUNT) ;
            float val = roundf((multiplier * scale) * div);
            int intVal = val;
            
            if(val > 1000000){
                [yAxisValueArray addObject:[NSString stringWithFormat:@"%dK", intVal * -1 /1000]];            
            } else {
                NSString* str = [NSString stringWithFormat:@"%f", val * -1];
                [yAxisValueArray addObject:[self trimValue:str]];
            }
        }
    }
}

-(void) drawGrid:(CGRect) rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);

    int count = [yAxisValueArray count];
    CGFloat offset = rect.size.height / count;
    for (int i = 0; i < count; ++i) {
        CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y + i * offset);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, startPoint.x + rect.size.width, startPoint.y);
        CGContextStrokePath(context);

        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(1, startPoint.y - 4, 40, 10)];
        label.text = [yAxisValueArray objectAtIndex:i];
        label.font = [UIFont boldSystemFontOfSize:8];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = [UIColor darkGrayColor];
        label.tag = VIEW_COMMON_TAG;
        [self addSubview:label];
        [label release];
    }
    CGContextStrokePath(context);
}

-(void)createInfoArray {
    [columnReportInfoArray removeAllObjects];
    
//    int nPeriod = [self periodMonthNumber];
    
    NSArray* accounts = [CoreDataManager sortSet:[MOUser instance].accounts byProperty:SORT_BY_NAME ascending:YES];
    for (MOAccount* account in accounts) {
        NSNumber* incomeValue = [NSNumber numberWithDouble:0];
        for (MOIncome* income in [MOUser instance].incomes) {
            if ([income.account.name isEqualToString:account.name]) {
                NSNumber* temp = [CoreDataManager sumAmountOfRecurrings:income.recurrings fromStartDate:[MOUser instance].setting.report.startDate toEndDate:[MOUser instance].setting.report.endDate];
                incomeValue = [NSNumber numberWithDouble:([incomeValue doubleValue] + [temp doubleValue])];
            }
        }

        
        NSNumber* paymentValue = [NSNumber numberWithDouble:0];
        for (MOPayment* payment in [MOUser instance].payments) {
            if ([payment.account.name isEqualToString:account.name]) {
                NSNumber* temp = [CoreDataManager sumAmountOfRecurrings:payment.recurrings fromStartDate:[MOUser instance].setting.report.startDate toEndDate:[MOUser instance].setting.report.endDate];
                paymentValue = [NSNumber numberWithDouble:([paymentValue doubleValue] + [temp doubleValue] * (-1))];
            }
        }
        
        paymentValue = [NSNumber numberWithFloat:([paymentValue floatValue])];
        
        ColumnReportInfo* columnReportInfo = [[ColumnReportInfo alloc] initWithIncome:incomeValue payment:paymentValue account:account];
        [columnReportInfoArray addObject:columnReportInfo];
        [columnReportInfo release];
    }
}

-(void)createPageViews {
    [columnPageArray removeAllObjects];
    
    int pageNumber = 0;
    int elementsCountInEachPage = 2;
    int count = [columnReportInfoArray count];
    
    for (int i = 0; i < count; i += elementsCountInEachPage) {
        CGRect frame = CGRectMake(320 * pageNumber, 0, 320, self.frame.size.height);
        
        int subCount = count >= elementsCountInEachPage * (pageNumber + 1) ? elementsCountInEachPage : (elementsCountInEachPage * (pageNumber + 1) - count);
        
        NSArray* subArray = [columnReportInfoArray subarrayWithRange:NSMakeRange(pageNumber * elementsCountInEachPage, subCount)];
        ColumnPageView* columnPageView = [[ColumnPageView alloc] initWithFrame:frame withInfoArray:subArray withYAxisValueArray:yAxisValueArray];
        columnPageView.tag = VIEW_COMMON_TAG;
        [self addSubview:columnPageView];
        [columnPageView release];
        pageNumber++;
    }
}

-(void)updateScrollView {
    
    int pageCount = ceil([[MOUser instance].accounts count] / 2.0f); 
    self.pagingEnabled = YES;
    self.contentSize = CGSizeMake(pageCount * self.frame.size.width, self.frame.size.height);
    
    if(report){
        [report release];
    }
     report = [[Report alloc] initWithData:[MOUser instance]];
    
    [self createInfoArray];
    
    [self calculateFactor:self.frame];
    
    [self createPageViews];
}

-(void)dealloc {
    [columnReportInfoArray release];
    [report release];
    [yAxisValueArray release];
    [super dealloc];
}

@end
