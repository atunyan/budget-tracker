/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 29.02.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "SearchData.h"
#import "MOUser.h"
#import "CoreDataManager.h"
#import "Constants.h"
#import "MOSearchSettings.h"

static SearchData* searchData = nil;

@implementation SearchData

@synthesize searchIncomesList;
@synthesize searchPaymentsList;
@synthesize searchAccountsList;
@synthesize searchKeyword;
@synthesize startDate;
@synthesize endDate;
@synthesize searchInIncomeAmount;
@synthesize searchInIncomeName;
@synthesize searchInIncomeAccount;
@synthesize searchInPaymentAccount;
@synthesize searchInPaymentAmount;
@synthesize searchInPaymentCategory;
@synthesize searchInPaymentLocation;
@synthesize searchInPaymentName;
@synthesize searchInAccountAmount;
@synthesize searchInAccountName;
@synthesize searchInAccountType;


-(id) init {
    self = [super init];
    if (self) {
        searchIncomesList = [[NSMutableArray alloc] init];
        searchPaymentsList = [[NSMutableArray alloc] init];
        searchAccountsList = [[NSMutableArray alloc] init];
        
        [self initializeSearchParameters];
        searchKeyword = @"";
        [self initializeSearchLists];
    }
    return  self;
}

+(SearchData *) instance {
    if (searchData == nil){
		searchData = [[SearchData alloc] init];
	}
	return searchData;
}

-(void) initializeSearchParameters {
    if (![MOUser instance].searchSettings) {
        MOSearchSettings* searchSettings = [[CoreDataManager instance] searchSettings];
        [MOUser instance].searchSettings = searchSettings;
    }
    searchInIncomeAmount = [MOUser instance].searchSettings.searchInIncomeAmount;
    searchInIncomeName = [MOUser instance].searchSettings.searchInIncomeName;
    searchInIncomeAccount = [MOUser instance].searchSettings.searchInIncomeAccount;
    searchInAccountAmount =  [MOUser instance].searchSettings.searchInAccountAmount;
    searchInAccountName = [MOUser instance].searchSettings.searchInAccountName;
    searchInAccountType = [MOUser instance].searchSettings.searchInAccountType;
    searchInPaymentAmount = [MOUser instance].searchSettings.searchInPaymentAmount;
    searchInPaymentName = [MOUser instance].searchSettings.searchInPaymentName;
    searchInPaymentAccount = [MOUser instance].searchSettings.searchInPaymentAccount;
    searchInPaymentLocation = [MOUser instance].searchSettings.searchInPaymentLocation;
    searchInPaymentCategory = [MOUser instance].searchSettings.searchInPaymentCategory;
    
    startDate = [[MOUser instance].searchSettings.startDate retain];
    endDate = [[MOUser instance].searchSettings.endDate retain];
}

-(void) initializeSearchLists {
    NSSet* incomesSet = [MOUser instance].incomes;
    NSArray* tmpListOfItems = [[CoreDataManager sortSet:incomesSet byProperty:SORT_BY_NAME ascending:NO] retain];
    if (searchIncomesList) {
        [searchIncomesList release]; 
        searchIncomesList = nil;
    }
    searchIncomesList = [[NSMutableArray alloc] initWithArray:tmpListOfItems];
    
    NSSet* paymentsSet = [MOUser instance].payments;
    if (tmpListOfItems) {
        [tmpListOfItems release];
        tmpListOfItems = nil;
    }
    tmpListOfItems = [[CoreDataManager sortSet:paymentsSet byProperty:SORT_BY_NAME ascending:NO] retain];
    if (searchPaymentsList) {
        [searchPaymentsList release]; 
        searchPaymentsList = nil;
    }
    searchPaymentsList = [[NSMutableArray alloc] initWithArray:tmpListOfItems];
    
    NSSet* accountsSet = [MOUser instance].accounts;
    
    if (tmpListOfItems) {
        [tmpListOfItems release];
        tmpListOfItems = nil;
    }
    tmpListOfItems = [[CoreDataManager sortSet:accountsSet byProperty:SORT_BY_NAME ascending:NO] retain];
    if (searchAccountsList) {
        [searchAccountsList release]; 
        searchAccountsList = nil;
    }
    searchAccountsList = [[NSMutableArray alloc] initWithArray:tmpListOfItems];
    [tmpListOfItems release];
}

-(void) dealloc {
    [searchIncomesList release];
    [searchPaymentsList release];
    [searchAccountsList release];
    
    /// The properties can be initialized in the @ref SearchSettingsViewController class
    if (startDate) {
        [startDate release]; 
        startDate = nil;
    }
    if (endDate) {
        [endDate release];
        endDate = nil;
    }
    [super dealloc];
}

@end
