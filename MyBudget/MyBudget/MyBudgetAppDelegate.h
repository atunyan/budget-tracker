/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 10.01.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


#import "MOTransfer.h"

/// The protocol is responsible for showing and hiding the iAd banner.
@protocol BannerViewContainer <NSObject>

/**
 * @brief Shows iAd banner view
 * @param bannerView - the banner view to be shown
 * @param animated - YES, if there is need to show the view with animation, 
 * otherwise NO.
 */
- (void)showBannerView:(ADBannerView *)bannerView animated:(BOOL)animated;

/**
 * @brief Hides iAd banner view
 * @param bannerView - the banner view to be hidden
 * @param animated - YES, if there is need to hide the view with animation, 
 * otherwise NO.
 */
- (void)hideBannerView:(ADBannerView *)bannerView animated:(BOOL)animated;

@end

extern NSString * const BannerViewActionWillBegin;
extern NSString * const BannerViewActionDidFinish;


@class MyBudgetViewController;

/// The delegete class of the MyBudget project.
@interface MyBudgetAppDelegate : UIResponder <UIApplicationDelegate, ADBannerViewDelegate, UINavigationControllerDelegate> {
        
    MyBudgetViewController *viewController;
    
    MOTransfer* receivedTransfer;
    NSDate* receivedDate;
    
    /// The main navigation Controller to navigate among the views.
    UINavigationController *rootNavigationController;
}

/// The main window of the project.
@property (strong, nonatomic) UIWindow *window;

/// The main viewController to be opened on the window.
@property (nonatomic, retain) MyBudgetViewController *viewController;

/// The received transfer object via local notification.
@property (nonatomic, retain) MOTransfer* receivedTransfer;

/// The received transfer time via local notification
@property (nonatomic, retain) NSDate* receivedDate;

/// navigation controller
@property (nonatomic, retain) UINavigationController *rootNavigationController;

@end
