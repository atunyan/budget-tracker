/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/26/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "MOUser.h"
#import "MOCategory.h"
#import "MOIncome.h"
#import "MOPayment.h"
#import "MOAccount.h"
#import "CoreDataManager.h"

static MOUser* user = nil;

static BOOL keepMeLoggedIn = NO;

/// the name of last logged in user
NSString* lastLoggedUserName = nil;

@implementation MOUser

@dynamic accountNumber;
@dynamic eMail;
@dynamic firstName;
@dynamic lastName;
@dynamic nickname;
@dynamic password;
@dynamic phoneNumber;
@dynamic isLogged;
@dynamic categories;
@dynamic incomes;
@dynamic payments;
@dynamic setting;
@dynamic searchSettings;
@dynamic accounts;

+(MOUser*) instance {
	return user;
}

+(void)setInstance:(MOUser*)instance {
    if (user != instance) {
        [user release];
        user = [instance retain];
    }
}

+(void) resetUserData {
    user = nil;
    lastLoggedUserName = nil;
    keepMeLoggedIn = NO;
}

+(void)setKeepMeLoggedIn:(BOOL)loggedIn {
    keepMeLoggedIn = loggedIn;
}

+(BOOL)keepMeLoggedIn {
    return keepMeLoggedIn;
}

+(void)setLastLoggedUserName:(NSString*)userName {
    if (lastLoggedUserName != userName) {
        [lastLoggedUserName release];
        lastLoggedUserName = [userName retain];
    }
}

+(NSString*)lastLoggedUserName {
    return lastLoggedUserName;
}

@end
