/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 29/03/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOUser;

/// The class keeps the search settings to be stored in the data based
@interface MOSearchSettings : NSManagedObject

/// the start date of the search
@property (nonatomic, retain) NSDate * startDate;

/// the end date of the search
@property (nonatomic, retain) NSDate * endDate;

/// Indicates whether there is need to perform search in the income amount or no.
@property (nonatomic, retain) NSNumber * searchInIncomeAmount;

/// Indicates whether there is need to perform search in the income name or no.
@property (nonatomic, retain) NSNumber * searchInIncomeName;

/// Indicates whether there is need to perform search in the income account or no.
@property (nonatomic, retain) NSNumber * searchInIncomeAccount;

/// Indicates whether there is need to perform search in the payment account or no.
@property (nonatomic, retain) NSNumber * searchInPaymentAccount;

/// Indicates whether there is need to perform search in the payment amount or no.
@property (nonatomic, retain) NSNumber * searchInPaymentAmount;

/// Indicates whether there is need to perform search in the payment category or no.
@property (nonatomic, retain) NSNumber * searchInPaymentCategory;

/// Indicates whether there is need to perform search in the payment location or no.
@property (nonatomic, retain) NSNumber * searchInPaymentLocation;

/// Indicates whether there is need to perform search in the payment name or no.
@property (nonatomic, retain) NSNumber * searchInPaymentName;

/// Indicates whether there is need to perform search in the account amount or no.
@property (nonatomic, retain) NSNumber * searchInAccountAmount;

/// Indicates whether there is need to perform search in the account name or no.
@property (nonatomic, retain) NSNumber * searchInAccountName;

/// Indicates whether there is need to perform search in the account type or no.
@property (nonatomic, retain) NSNumber * searchInAccountType;

/// The user of the current search settings.
@property (nonatomic, retain) MOUser *user;

@end
