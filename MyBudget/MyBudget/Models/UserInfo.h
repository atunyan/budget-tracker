/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/18/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>

/// used as User's table data model
@interface UserInfo : NSObject {
    NSString* nickname;
    NSString* password;
    NSString* confirmPassword;
    NSString* firstName;
    NSString* lastName;
    NSString* phoneNumber;
    NSString* eMail;
    NSString* accountNumber;
    BOOL keepMeLoggedIn;
}

/// table column Nickname
@property (nonatomic, retain) NSString* nickname;

/// table column Password
@property (nonatomic, retain) NSString* password;

/// table column Comfirm Password
@property (nonatomic, retain) NSString* confirmPassword;

/// The user's first name
@property (nonatomic, retain) NSString* firstName;

/// The user's last name
@property (nonatomic, retain) NSString* lastName;

/// The user's phone number
@property (nonatomic, retain) NSString* phoneNumber;

/// The user's email
@property (nonatomic, retain) NSString* eMail;

/// The user's accountNumber
@property (nonatomic, retain) NSString* accountNumber;

/// True if keep me logged in set, otherwise no.
@property (nonatomic, assign) BOOL keepMeLoggedIn;

@end
