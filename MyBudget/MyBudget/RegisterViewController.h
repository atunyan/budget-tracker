/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/19/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "RegistrationDelegate.h"

/// The view controller is responsible for the first time registration.
@interface RegisterViewController : UITableViewController<UITextFieldDelegate> {
    /// The only instance of @ref UserInfo class
    UserInfo* userInfo;
    
    /// The array of text fields for entering user's info.
    NSMutableArray* arrayOfTextFields;
    
    id<RegistrationDelegate> delegate;
}


/// The delegate of @ref RegistrationDelegate protocol
@property (nonatomic, assign) id<RegistrationDelegate> delegate;

@end