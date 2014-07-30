/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 3/7/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "PieLegendsView.h"
#import "PieInfo.h"
#import "MOUser.h"
#import "PieView.h"

/// tag for view, that should be removed before updating
#define VIEW_COMMON_TAG       3000

/// legend's rectangle height
#define LEGEND_HEIGHT   20

@implementation PieLegendsView

- (id)initWithFrame:(CGRect)frame withPieArray:(NSArray*)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        pieArray = [array retain];
    }
    return self;
}

-(void) drawPropertyByContext:(CGContextRef)ctx point:(CGPoint)point pieInfo:(PieInfo*)pieInfo {
    int fontSize = 13;
    int height = 15;
    int leftCategory = point.x;
    int widthCategory = 120;
    int leftPayments = leftCategory + widthCategory;
    int widthPayments = 100;
    int leftCurrency = leftPayments + widthPayments;
    int widthCurrency = 35;
    
    // Category name
    UILabel* categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftCategory, point.y, widthCategory, height)];
    categoryLabel.text = pieInfo.categoryName;
    categoryLabel.font = [UIFont systemFontOfSize:fontSize];
    categoryLabel.textColor = [UIColor blackColor];
    categoryLabel.backgroundColor = [UIColor clearColor];
    categoryLabel.tag = VIEW_COMMON_TAG;
    [self addSubview:categoryLabel];
    [categoryLabel release];
    
    // Payment

    NSString *payments = [NSString stringWithFormat:@"%.2f", [pieInfo.payments doubleValue]];  
    
    UILabel* paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPayments, point.y, widthPayments, height)];
    paymentLabel.text = payments;
    paymentLabel.font = [UIFont systemFontOfSize:fontSize];
    paymentLabel.textColor = [UIColor blackColor];
    paymentLabel.textAlignment = UITextAlignmentRight;
    paymentLabel.backgroundColor = [UIColor clearColor];
    paymentLabel.tag = VIEW_COMMON_TAG;
    [self addSubview:paymentLabel];
    [paymentLabel release];
    
    // Currency
    UILabel* currencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftCurrency, point.y, widthCurrency, height)];
    currencyLabel.text = [MOUser instance].setting.currency;
    currencyLabel.font = [UIFont systemFontOfSize:fontSize - 2];
    currencyLabel.textColor = [UIColor blackColor];
    currencyLabel.textAlignment = UITextAlignmentRight;
    currencyLabel.backgroundColor = [UIColor clearColor];
    currencyLabel.tag = VIEW_COMMON_TAG;
    [self addSubview:currencyLabel];
    [currencyLabel release];
}

-(void)drawLegends:(CGRect)rect {
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    float x = 20;
    float y = 5;
    
    int drawRectWidth = 15;
    int drawRectHeight = 10;
    int drawRectLineWidth = 1;
    
    int fillRectWidth = drawRectWidth - drawRectLineWidth * 2;
    int fillRectHeight = drawRectHeight - drawRectLineWidth * 2;
    
    // set rectangle line color
    float gray = 0.8f;    
    [[UIColor colorWithRed:gray green:gray blue:gray alpha:1.0] setStroke];
    int index = 0;
    for (PieInfo* pieInfo in pieArray) {
        // draw rectangles       
        [[UIColor clearColor] setFill];
        CGRect drawRect = CGRectMake(x, y, drawRectWidth, drawRectHeight);
        drawRect = CGRectStandardize(drawRect);
        CGContextFillRect(context, drawRect);
        CGContextStrokeRectWithWidth(context, drawRect, drawRectLineWidth);
        
        [[PieView colorByIndex:index] setFill];
        CGRect fillRect = CGRectMake(x + drawRectLineWidth, y + drawRectLineWidth, fillRectWidth, fillRectHeight);
        CGContextFillRect(context, fillRect);
        
        // draw texts
        [self drawPropertyByContext:context point:CGPointMake(x + drawRectWidth + 5, y - 3) pieInfo:pieInfo];
        y += LEGEND_HEIGHT;
        
        index++;
    }
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self removeLabels];
    [self drawLegends:rect];
}

@end
