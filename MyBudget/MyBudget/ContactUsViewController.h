/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 24/01/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MailManager.h"
#import "MyBudgetAppDelegate.h"

/**
 * @brief The class contains the information on how the users can contact to the 
 * applications' development team.
 */
@interface ContactUsViewController : UIViewController <MailManagerDelegate, ADBannerViewDelegate, BannerViewContainer> {
}

@end
