
/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 23/01/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */


#import <Foundation/Foundation.h>

/// The protocol is used to make changes in @ref RegisterViewController class.
@protocol RegistrationDelegate <NSObject>

@required

/// The function is responsible for dismissing @ref RegisterViewController.
-(void) dismissRegisterPage;

@end
