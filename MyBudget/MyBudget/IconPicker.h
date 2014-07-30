/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */


#import <UIKit/UIKit.h>

@protocol IconPickerDelegate ;

/// represents view  with  icons
@interface IconPicker : UIScrollView {
 
    ///set of predefined  icons
    NSArray* imageArray;
    id<IconPickerDelegate> iconPickerDelegate;
    
}

@property (nonatomic,retain) NSArray* imageArray;

///delegate for choosing  curent  icon
@property (nonatomic,assign) id<IconPickerDelegate> iconPickerDelegate;


///update  frames  f.e.  on rotate
-(void) updateFrames:(UIInterfaceOrientation) orientation;

///sets icons array
-(void) setIcons: (NSArray*) array;

@end
/// delegate  called  when user clicks on appropriate  icon 
@protocol IconPickerDelegate <NSObject>

///sets  icon with  appropriate  image
-(void) setIcon:(NSString *)imageName;

@end
