/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 10.01.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MyBudgetAppDelegate.h"
#import "HomeButtonsViewController.h"
#import "LoginViewController.h"
#import "SettingsTableViewController.h"

/** 
 * @brief the class is the main view of the @b MyBudget project. All the 
 * related pages are available from this view. One can go to Income, Payment
 * page and etc.
 */
@interface MyBudgetViewController : HomeButtonsViewController <ADBannerViewDelegate, BannerViewContainer, LoginViewControllerDelegate> {
    /// entered page name
    NSString* pageName;
}

/// Opens login page
-(void)openLoginPage;

@end
