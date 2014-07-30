/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "IconPicker.h"

@class MOCategory;
@protocol CategoryViewControllerDelegate ;

/// class  for  adding new category
@interface CategoryViewController : UIViewController <IconPickerDelegate, UITextFieldDelegate>{
    /// refers  to the current image
    NSString*  currentImageName;
    
    id<CategoryViewControllerDelegate> delegate;
    
    /// parent category
    MOCategory* parentCategory;
}

/// the current  image object
@property (nonatomic, retain) NSString*  currentImageName;

/// The delegate of @ref CategoryViewControllerDelegate protocol
@property (nonatomic, assign) id<CategoryViewControllerDelegate> delegate;

/**
 * @brief  creates category with parent category
 * @param category - parent category
 * @return - initialized object
 */
-(id)initWithParentCategory:(MOCategory*)category;

@end

/// delegate  called  when user adds  new  category 
@protocol CategoryViewControllerDelegate <NSObject>

/// adds new  category  to existing
-(void) addNewCategory:(MOCategory*)category;

@end
