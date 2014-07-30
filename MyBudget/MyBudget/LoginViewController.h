/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/17/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import "MyBudgetAppDelegate.h"

/// Used for handling functions called from login page
@protocol LoginViewControllerDelegate <NSObject>

@optional

/// called when user clicked login button
-(void)didUserLoggedIn;

/// called when user clicked logout button
-(void)didUserLoggedOut;

@end

/// The view is responsible for user registration and login.
@interface LoginViewController : UIViewController <ADBannerViewDelegate, BannerViewContainer, UITextFieldDelegate, RegistrationDelegate> {
    
    /// The instance of @ref RegisterViewController class
    RegisterViewController* registerViewController;
        
    NSString* nickname;
    
    NSString* password;
    
    /// indicates is user must be stay in logged in
    BOOL keepMeLoggedIn;  
    
    id<LoginViewControllerDelegate> delegate;

    /// indicates if back button hidden or not
    BOOL isBackButtonHidden;
}

/// user's nickname
@property (nonatomic, retain) NSString* nickname;

/// user's password
@property (nonatomic, retain) NSString* password;

/// The delegate of @ref LoginViewControllerDelegate protocol
@property (nonatomic, assign) id<LoginViewControllerDelegate> delegate;

/**
 * @brief Initializes object with back button or not
 * @param isBackHidden - indicates if back button hidden or not
 * @return Initialized object
 */
- (id)initWithBackButtonHidden:(BOOL)isBackHidden;

@end
