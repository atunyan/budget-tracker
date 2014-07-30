/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/18/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "UserInfo.h"

@implementation UserInfo

@synthesize nickname;
@synthesize password;
@synthesize confirmPassword;
@synthesize firstName;
@synthesize lastName;
@synthesize phoneNumber;
@synthesize eMail;
@synthesize accountNumber;
@synthesize keepMeLoggedIn;

-(id) init {
    self = [super init];
    if (self) {
        nickname = @"";
        password = @"";
        confirmPassword = @"";
        firstName = @"";
        lastName = @"";
        phoneNumber = @"";
        eMail = @"";
        accountNumber = @"";
        keepMeLoggedIn = NO;
    }
    return self;
}

@end
