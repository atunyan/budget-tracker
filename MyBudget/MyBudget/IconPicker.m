
/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/19/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "IconPicker.h"
#import "Constants.h"

///the size  of icon
#define ICON_SIZE 30


@implementation IconPicker

@synthesize imageArray;
@synthesize iconPickerDelegate;

-(id) initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled =YES;
            
    }
    return  self;
}

-(int) rowsCount {
    int count =  (int)self.frame.size.height/ICON_SIZE;
    CGFloat diff= self.frame.size.height - count* ICON_SIZE;
    while (diff/(float)(count +2) < 10) {
        --count;
        diff= self.frame.size.height - count* ICON_SIZE;
    }
    return count;    
}

-(int) columnsCount {
    int count =  (int)self.frame.size.width/ICON_SIZE;
    CGFloat diff= self.frame.size.width - count* ICON_SIZE;
    while (diff/(float)(count +2) < 10) {
        --count;
        diff= self.frame.size.width - count* ICON_SIZE;
    }
    return count;
}

-(CGFloat) caluclateVerticalDistance:(int) count{
    return (self.frame.size.height - count*ICON_SIZE)/(float)(count+2);
}

-(CGFloat) caluclateHorisontalDistance:(int) count{
   return (self.frame.size.width - count*ICON_SIZE)/(float)(count+2);    
}

-(void) updateFrames:(UIInterfaceOrientation) orientation{
  
    int verticalCount = [self rowsCount];
    int horisontalCount = [self columnsCount];
    CGFloat verticalOffset = [self caluclateVerticalDistance:verticalCount];
    CGFloat horisontalOffset = [self caluclateHorisontalDistance:horisontalCount];
    CGRect rect = CGRectMake(horisontalOffset, verticalOffset, ICON_SIZE, ICON_SIZE);
    int verticalIndex = 0;
    int horisontalIndex = 0;
    [self setContentSize:self.frame.size];
    for (int i = 0 ; i < [imageArray count]; ++i) {
        if (horisontalIndex == horisontalCount) {
            int ident= (int)self.contentSize.width/(int)self.frame.size.width;
            rect = CGRectMake(horisontalOffset + (ident -1)* self.frame.size.width,
                              rect.origin.y +ICON_SIZE + verticalOffset, 
                              ICON_SIZE, 
                              ICON_SIZE);
            horisontalIndex = 0;
            ++verticalIndex;
         }
        if (verticalIndex == verticalCount) {
            verticalIndex = 0;
            [self setContentSize:CGSizeMake(self.contentSize.width + self.frame.size.width,self.frame.size.height)];
            rect= CGRectMake(self.contentSize.width - self.frame.size.width + horisontalOffset, verticalOffset,ICON_SIZE, ICON_SIZE);
        }
        UIButton* button =(UIButton*)[self viewWithTag:i + 1000];
        button.frame = rect;
        rect= CGRectOffset(rect,  ICON_SIZE + horisontalOffset,0);
        ++horisontalIndex;

    }
 
    
}

-(void) selectImage:(id) sender {
    UIButton* button = (UIButton*)sender;
    NSString* im = [imageArray objectAtIndex:(button.tag - 1000) ];
    if([iconPickerDelegate respondsToSelector:@selector(setIcon:)]){
        [iconPickerDelegate setIcon:im];
    }
    
}

-(void) setIcons:(NSArray *)array {
    int count = 0;
    self.imageArray = array;
    for (NSString* imageName in imageArray) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = count + 1000;
        [button setImage:[UIImage imageNamed:[ROOT_CATEGORY_DIR stringByAppendingPathComponent:imageName]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        [self  addSubview:button];
        ++count;
    }
    [self updateFrames:[UIApplication sharedApplication].statusBarOrientation];
    
}


-(void) dealloc {
    [imageArray release];
    [super dealloc];
}

@end
