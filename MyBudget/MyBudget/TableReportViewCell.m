/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/22/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "TableReportViewCell.h"


/// month header label type
#define MONTH_LABEL_TAG     4005

/// income header label type
#define INCOME_LABEL_TAG    4006

/// payment header label type
#define BILL_LABEL_TAG      4008

/// balance header label type
#define BALANCE_LABEL_TAG   4009

/// columns count
#define COLUMN_COUNT        4

@implementation TableReportViewCell

@synthesize monthTitle;
@synthesize payment;
@synthesize income;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        headerTitles = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Month", nil), NSLocalizedString(@"Incomes", nil), NSLocalizedString(@"Payments", nil), NSLocalizedString(@"Balance", nil), nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) setCellType:(CellType) cType{
    cellType = cType;
}

-(void) drawVerticalLines {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    for(int i = 0; i <= COLUMN_COUNT; ++i) {
        CGContextMoveToPoint(context, tableRect.origin.x + i * tableRect.size.width / COLUMN_COUNT, 0);
        CGContextAddLineToPoint(context, tableRect.origin.x + i * tableRect.size.width / COLUMN_COUNT, tableRect.size.height);
        CGContextStrokePath(context);
    }
}

-(void) drawHorisontalLines {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, tableRect.origin.x, tableRect.size.height);
    CGContextAddLineToPoint(context, tableRect.origin.x + tableRect.size.width, tableRect.size.height);
    CGContextStrokePath(context);    
}

-(void) removeTitles {
    for (int i = 4000; i < 4000 + COLUMN_COUNT; ++i) {
        UILabel* lab = (UILabel*)[self viewWithTag:i];
        [lab removeFromSuperview];
    }
}

-(void) drawHeaderTitles {
    [self removeTitles];
    int tag = 4000;
    for (int i = 0; i < COLUMN_COUNT; ++i) {
        CGRect labelRect = CGRectMake(tableRect.origin.x + i * tableRect.size.width / COLUMN_COUNT, 0, tableRect.size.width / COLUMN_COUNT, tableRect.size.height);
        UILabel*  label  = [[UILabel alloc] initWithFrame:labelRect];
        label.text = [headerTitles objectAtIndex:i];
        label.tag = tag;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = UITextAlignmentRight;
        if (i == 0) {
            label.textAlignment = UITextAlignmentCenter;
        }
        [self addSubview:label];
        [label release];
        tag++;
    }
}

-(void) drawValue:(NSString*)value onOriginX:(CGFloat)originX byTag:(int)tag {
    UILabel*  label = (UILabel*)[self viewWithTag:tag];
    if (label) {
        [label removeFromSuperview];
    }
    CGRect labelRect = CGRectMake(originX, 0, tableRect.size.width / COLUMN_COUNT, tableRect.size.height);
    label  = [[UILabel alloc] initWithFrame:labelRect];
    label.text = value;
    label.tag = tag;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = UITextAlignmentRight;
    if (tag == MONTH_LABEL_TAG) {
        label.textAlignment = UITextAlignmentCenter;
    }
    [self addSubview:label];
    [label release];
}

-(void) drawMonthValue {
    [self drawValue:monthTitle onOriginX:tableRect.origin.x byTag:MONTH_LABEL_TAG];
}

-(void) drawIncomeValue {
    NSString* value = [income floatValue] > 0 ? [NSString stringWithFormat:@"%.2f",[income floatValue]] : @"";
    [self drawValue:value onOriginX:(tableRect.origin.x + tableRect.size.width / COLUMN_COUNT) byTag:INCOME_LABEL_TAG];
}

-(void) drawPaymentValue{
    NSString* value = [payment floatValue] > 0 ? [NSString stringWithFormat:@"%.2f",[payment floatValue]] : @"";
    [self drawValue:value onOriginX:(tableRect.origin.x + 2 * tableRect.size.width / COLUMN_COUNT) byTag:BILL_LABEL_TAG];
}

-(void) drawBalanceValue {
    float balance = [income floatValue] - [payment floatValue];
    NSString* value = @"";
    if ([income floatValue] > 0 || [payment floatValue] > 0) {
        value = [NSString stringWithFormat:@"%.2f", balance];
    }
    [self drawValue:value onOriginX:(tableRect.origin.x + 3 * tableRect.size.width / COLUMN_COUNT) byTag:BALANCE_LABEL_TAG];
}

-(void) drawData{
    [self drawMonthValue];
    [self drawIncomeValue];
    [self drawPaymentValue];
    [self drawBalanceValue];
}

-(void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    tableRect = CGRectMake(2, 0, rect.size.width - 4, rect.size.height);
    if (cellType == kCellTypeHeader) {
        CGContextSetGrayFillColor(context, 0.87, 1);
        CGContextFillRect(context, CGRectMake(tableRect.origin.x, 1, tableRect.size.width, rect.size.height - 2));
        CGContextMoveToPoint(context, tableRect.origin.x, 0);
        CGContextAddLineToPoint(context, tableRect.origin.x + tableRect.size.width, 0);
        CGContextStrokePath(context);
        [self drawHeaderTitles];
    }
    [self drawVerticalLines];
    [self drawHorisontalLines];
    if (cellType == kCellTypeCommon) {
        [self drawData];
    }
}

-(void) dealloc  {
    [income release];
    [payment release];
    [monthTitle release];
    [super dealloc];
}
@end
