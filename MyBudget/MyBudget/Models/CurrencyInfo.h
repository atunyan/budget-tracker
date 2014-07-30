/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/8/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "SelectingInfo.h"

/// Used as currency model
@interface CurrencyInfo : SelectingInfo {

}

/**
 * @brief  checks is currrency full name contains current currency name
 * @param currencyFullName - currency full name
 * @param currentCurrencyName - current currency name
 * @return - returns is contains or not
 */
+(BOOL)isFullCurrency:(NSString*)currencyFullName containsCurrentCurrency:(NSString*)currentCurrencyName;

/**
 * @brief  gets currency name from currency full name
 * @param currencyFullName - currency full name
 * @return - returns only currency name
 */
+(NSString*)currencyFromFullName:(NSString*)currencyFullName;

/**
 * @brief  gets current currency index from carrencies array
 * @param currentCurrencyName - current currency name
 * @param currencyArray - all carrencies
 * @return - returns index (if not exists returns -1)
 */
+(NSInteger)currencyIndexByCurrencyName:(NSString*)currentCurrencyName fromCurrencyArray:(NSArray*)currencyArray;

@end
