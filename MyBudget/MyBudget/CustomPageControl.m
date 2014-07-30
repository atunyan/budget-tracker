/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 4/6/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "CustomPageControl.h"

/// the dot diametr
#define kDotDiametr 7.0

/// space between dots
#define kDotSpacer 7.0

@implementation CustomPageControl

@synthesize currentPageIndex;

- (id)initWithFrame:(CGRect)frame withPageCount:(NSInteger)pageCount
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        dotColor = [UIColor grayColor];
        currentPageIndex = 0;
        dotCount = pageCount; 
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    CGRect dotBounds = self.bounds;
    CGFloat dotWidth = dotCount * kDotDiametr + MAX(0, dotCount - 1)*kDotSpacer;
    CGFloat originX = CGRectGetMidX(dotBounds) - dotWidth/2;
    CGFloat originY = CGRectGetMidY(dotBounds) - kDotDiametr/2;
    
    for(int i = 0; i < dotCount; i++) {
        CGRect dotRect = CGRectMake(originX, originY, kDotDiametr , kDotDiametr);
        if(i == currentPageIndex){
            CGContextSetFillColorWithColor(context, dotColor.CGColor);
            CGContextFillEllipseInRect(context, dotRect);
        }else {
            CGContextSetStrokeColorWithColor(context, dotColor.CGColor);
            CGContextStrokeEllipseInRect(context, dotRect);
        }
        originX += kDotDiametr + kDotSpacer;
    }
}

-(void)updateCurrentPageDisplay {
    [self setNeedsDisplay];
}

- (void)dealloc {
    [dotColor release];
    [super dealloc];
}

@end
