/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/8/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "CurrencyInfo.h"

@implementation CurrencyInfo

+(BOOL)isFullCurrency:(NSString*)currencyFullName containsCurrentCurrency:(NSString*)currentCurrencyName {
    BOOL isCurrent = NO;
    
    NSRange range = [currencyFullName rangeOfString:@"("];
    if (range.location != NSNotFound) {
        NSString* currencyName = [currencyFullName substringWithRange:NSMakeRange(range.location + 1, 3)];
        if ([currencyName isEqualToString:currentCurrencyName]) {
            isCurrent = YES;
        }
    }
    return isCurrent;
}

+(NSString*)currencyFromFullName:(NSString*)currencyFullName {
    NSString* currencyName = nil;
    
    NSRange range = [currencyFullName rangeOfString:@"("];
    if (range.location != NSNotFound) {
        currencyName = [currencyFullName substringWithRange:NSMakeRange(range.location + 1, 3)];
    }
    
    return currencyName;
}

+(NSInteger)currencyIndexByCurrencyName:(NSString*)currentCurrencyName fromCurrencyArray:(NSArray*)currencyArray {
    int index = -1;
    int count = [currencyArray count];
    for (int i = 0; i < count; ++i) {
        NSString* currencyFullName = [currencyArray objectAtIndex:i];
        
        if ([CurrencyInfo isFullCurrency:currencyFullName containsCurrentCurrency:currentCurrencyName]) {
            index = i;
            break;
        }
    }
    return index; 
}

@end
