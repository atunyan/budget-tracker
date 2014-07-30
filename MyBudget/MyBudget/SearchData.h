/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 29.02.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

/// Search data class keeps all the neccessary information for searching any item.
@interface SearchData : NSObject {
    NSMutableArray* searchIncomesList;
    NSMutableArray* searchPaymentsList;
    NSMutableArray* searchAccountsList;
    
    NSDate* startDate;
    NSDate* endDate;
    NSString* searchKeyword;
    NSNumber * searchInIncomeAmount;
    NSNumber * searchInIncomeName;
    NSNumber * searchInIncomeAccount;
    
    NSNumber * searchInPaymentAccount;
    NSNumber * searchInPaymentAmount;
    NSNumber * searchInPaymentCategory;
    NSNumber * searchInPaymentLocation;
    NSNumber * searchInPaymentName;
    NSNumber * searchInAccountAmount;
    NSNumber * searchInAccountName;
    NSNumber * searchInAccountType;
}

/// The list of incomes among which the search is done.
@property (nonatomic, retain) NSMutableArray* searchIncomesList;

/// The list of payments among which the search is done.
@property (nonatomic, retain) NSMutableArray* searchPaymentsList;

/// The list of accounts among which the search is done.
@property (nonatomic, retain) NSMutableArray* searchAccountsList;

/// The search keyword
@property (nonatomic, assign) NSString* searchKeyword;

/// The search start date 
@property (nonatomic, retain) NSDate* startDate;

/// The search end date
@property (nonatomic, retain) NSDate* endDate;


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


/**
 * @brief Returns the only instance of the class. If the insance is not created yet,
 * the method creates it.
 * @return - the only instance of class.
 */
+(SearchData*) instance;

/**
 * @brief initializes and returns the search list.
 */
-(void) initializeSearchLists;

/// Initializes the parameters for performing search.
-(void) initializeSearchParameters;

@end
