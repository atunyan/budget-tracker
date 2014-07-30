/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "CategoryViewController.h"

@class MOCategory;

/// delegate  for  CategoryViewController class
@protocol CategoryListViewControllerDelegate <NSObject>

/// transfers  category  on click
-(void) didSelectCategory: (MOCategory*) category;

@end



/** 
 * @brief represents the  list of  entire  categories  with  add  and  remove
 * possibilities
 */
@interface CategoriesListViewController : UITableViewController<CategoryViewControllerDelegate, CategoryListViewControllerDelegate>{
    /// array with all existing  categories 
    NSMutableArray*  categories;
    
    /// deletable row number for the categories.
    NSIndexPath*  deletingIndexPath;
    
    ///delegate for  category view  controller
    id<CategoryListViewControllerDelegate> delegate;
    
    ///current category
    MOCategory*  currentCategory;
    
    /// current clicked category
    MOCategory* clickedCategory;
    
    /// determine  type  of category list (root  or not)
    BOOL isRootCategoriesList;
    
    
    /// flag  for  pop  to parent  view  controller  on selecting  current  category
    BOOL needToPop;
}

@property (nonatomic,retain) NSMutableArray*  categories;
@property (nonatomic,assign) id<CategoryListViewControllerDelegate> delegate;
@property (nonatomic,retain) MOCategory*  currentCategory;

/**
 * @brief  initialize category list with selected(if exists) category and with just clicked category
 * @param style - table view style
 * @param category - current choosen category
 * @param justClickedCategory - just clicked category
 * @return - initialized object
 */
- (id)initWithStyle:(UITableViewStyle)style withCategory:(MOCategory*)category withClickedCategory:(MOCategory*)justClickedCategory;

@end

