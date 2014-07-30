/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 06.04.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

#import "MailManager.h"

/** 
 * @brief the class is the main view of the @b MyBudget project. The main
 * buttons are created in this view which are available from home and settings page. 
 */
@interface AboutViewController : UIViewController<MailManagerDelegate> {
    
    /**
     * @brief The number of columns, depends on the device orientation. 
     * For portrait mode it is 3, for the landscape mode it is 4.
     */
    NSUInteger numberOfColumns;
}

@end
