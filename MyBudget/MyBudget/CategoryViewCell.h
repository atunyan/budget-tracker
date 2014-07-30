/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "MOCategory.h"
/** 
 * @brief The  custom  implementation for UITableViewCell,which represents the  
 * category
 */
@interface CategoryViewCell : UITableViewCell {
    ///appropriate  category
    MOCategory *  category;
}
/// appropriate  category property 
@property (nonatomic,retain) MOCategory*  category;
/// setter for related  data
-(void) setData:(MOCategory*) _category;
@end
