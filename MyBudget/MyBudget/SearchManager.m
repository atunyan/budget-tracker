/**
 *   @file 
 *   My Budget
 *
 *   Created by Arevik Tunyan on 01/03/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "SearchManager.h"
#import "MOIncome.h"
#import "MOPayment.h"
#import "MOAccount.h"
#import "MOCategory.h"
#import "SearchData.h"
#import "LocationInfo.h"
#import "MOTransfer.h"

@implementation SearchManager

+(BOOL) containString: (NSString *) sourceStr stringToFind:(NSString *)keyword  {
    NSRange titleResultsRange = [sourceStr rangeOfString:keyword options:NSCaseInsensitiveSearch];
    
    return titleResultsRange.length > 0;
}

+(void) filterIncomesList:(MOIncome *) sTemp 
                   fArray:(NSMutableArray *)filteredArray 
                keyword  :(NSString *) keyword {
    NSString *string = [NSString stringWithFormat:@"%.2f", [sTemp.amount doubleValue]];     
    if (keyword != nil && ![@"" isEqualToString: keyword]) {
        if ([SearchManager containString:string stringToFind:keyword] && [[SearchData instance].searchInIncomeAmount boolValue]) {
            [filteredArray addObject:sTemp];   
        } else if ([[SearchData instance].searchInIncomeName boolValue] && [SearchManager containString: [sTemp name] stringToFind:keyword]) {
            [filteredArray addObject:sTemp];   
        } else if ([[SearchData instance].searchInIncomeAccount boolValue] && [SearchManager containString:[[sTemp account] name] stringToFind:keyword]) {
            [filteredArray addObject:sTemp];   
        }
    } else {
        if ([[SearchData instance].searchInIncomeAmount boolValue] || [[SearchData instance].searchInIncomeName boolValue] || [[SearchData instance].searchInIncomeAccount boolValue]) {
            [filteredArray addObject:sTemp];
        }
    }
 }

+(void) filterAccountList:(MOAccount *) sTemp 
                   fArray:(NSMutableArray *)filteredArray 
                keyword  :(NSString *) keyword {
    NSString *string = [NSString stringWithFormat:@"%.2f", [sTemp.amount doubleValue]];     

    if (keyword != nil && ![@"" isEqualToString: keyword]) {
        if ([SearchManager containString:string stringToFind:keyword] && [[SearchData instance].searchInAccountAmount boolValue]) {
            [filteredArray addObject:sTemp];   
        } else if ([[SearchData instance].searchInAccountName boolValue] && [SearchManager containString: [sTemp name] stringToFind:keyword]) {
            [filteredArray addObject:sTemp];   
        } else if ([[SearchData instance].searchInAccountType boolValue] && [SearchManager containString:[sTemp type] stringToFind:keyword]) {
            [filteredArray addObject:sTemp];   
        }
    } else {
        if ([[SearchData instance].searchInAccountName boolValue] || [[SearchData instance].searchInAccountAmount boolValue] || [[SearchData instance].searchInAccountType boolValue]) {
            [filteredArray addObject:sTemp];
        }
    }

}

+(void) filterPaymentsList:(MOPayment *) sTemp 
                    fArray:(NSMutableArray *)filteredArray 
                 keyword  :(NSString *) keyword {
    NSString *string = [NSString stringWithFormat:@"%.2f", [sTemp.amount doubleValue]];     
    if (keyword != nil && ![@"" isEqualToString: keyword]) {
        if ([SearchManager containString:string stringToFind:keyword] && [[SearchData instance].searchInPaymentAmount boolValue]) {
            [filteredArray addObject:sTemp];    
        } else if ([SearchManager containString: [sTemp name] stringToFind:keyword] && [[SearchData instance].searchInPaymentName boolValue]) {
            [filteredArray addObject:sTemp];
        } else if ([SearchManager containString:[[sTemp account] name] stringToFind:keyword] && [[SearchData instance].searchInPaymentAccount boolValue]) {
            [filteredArray addObject:sTemp]; 
        } else if  ([SearchManager containString:[LocationInfo dataAddress:sTemp.location] stringToFind:keyword] && [[SearchData instance].searchInPaymentLocation boolValue]) {
            [filteredArray addObject:sTemp];
        } else if ([SearchManager containString:[[sTemp category] name] stringToFind:keyword] && [[SearchData instance].searchInPaymentCategory boolValue]) {
            [filteredArray addObject:sTemp];
        }
    } else {
        if ([[SearchData instance].searchInPaymentName boolValue] || [[SearchData instance].searchInPaymentLocation boolValue]|| [[SearchData instance].searchInPaymentCategory boolValue] || [[SearchData instance].searchInPaymentAmount boolValue] || [[SearchData instance].searchInPaymentAccount boolValue]) {
            [filteredArray addObject:sTemp];
        }
    }
}

+(NSMutableArray *) filterItemsList: (NSArray *) array keyword:(NSString *) keyword {
    NSMutableArray *filteredArray = [[[NSMutableArray alloc] init] autorelease];
    for (MOTransfer* sTemp in array) { 
        if ([sTemp isKindOfClass:[MOIncome class]]) {
            [self filterIncomesList:(MOIncome *)sTemp fArray:filteredArray keyword:keyword];
        } else if ([sTemp isKindOfClass:[MOAccount class]]) {
            [self filterAccountList:(MOAccount *)sTemp fArray:filteredArray keyword:keyword];
        } else if ([sTemp isKindOfClass:[MOPayment class]]) {
            [self filterPaymentsList:(MOPayment *)sTemp fArray:filteredArray keyword:keyword];
        }
    }
    return filteredArray;
}

+(NSMutableArray *) listFilteredByKeyword:(NSString *) keyword array :(NSMutableArray *) array {
    if (!keyword) {
        keyword = @"";
    }
    NSMutableArray *filteredArray = [[[NSMutableArray alloc] init] autorelease];
    [filteredArray addObjectsFromArray: [SearchManager filterItemsList:array keyword:keyword]];
    if (![filteredArray count]) {
        return nil;
    }
    
    if ([SearchData instance].startDate && [SearchData instance].endDate && ![[filteredArray objectAtIndex:0] isKindOfClass:[MOAccount class]]) {
        NSMutableArray *filteredByDateArray = [[[NSMutableArray alloc] init] autorelease];
        for (MOTransfer* sTemp in filteredArray) { 
            if (NSOrderedDescending == [[sTemp dateTime] compare:[SearchData instance].startDate] && NSOrderedAscending == [[sTemp dateTime] compare:[SearchData instance].endDate]) {
                [filteredByDateArray addObject:sTemp];
            }
        }
        return filteredByDateArray;
    }
    return filteredArray;
}

@end
