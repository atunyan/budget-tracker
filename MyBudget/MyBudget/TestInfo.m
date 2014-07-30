/**
 *   @file
 *   My Budget
 *
 *   Created by Arevik Tunyan 27.04.12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "TestInfo.h"
#import "MOUser.h"
#import "MOAccount.h"
#import "MOCategory.h"
#import "MOPayment.h"
#import "MOIncome.h"
#import "MOReport.h"
#import "MORecurrence.h"
#import "CoreDataManager.h"
#import "LocationInfo.h"
#import "Constants.h"

@implementation TestInfo

/// Set default temporary data into CoreData
+(void)saveTemporaryData {
    if (![[CoreDataManager instance] existRegisteredUsers]) {
        int objectsCount = 0;   
        for (int i = 1; i <= objectsCount; ++i) {
            MOUser* user = [[CoreDataManager instance] user];
            user.accountNumber = [NSString stringWithFormat:@"123456%i", i];
            user.eMail = [NSString stringWithFormat:@"user%i@yahoo.com", i];
            user.firstName = [NSString stringWithFormat:@"User%i", i];
            user.lastName = [NSString stringWithFormat:@"User%iyan", i];
            user.nickname = [NSString stringWithFormat:@"user%i", i];
            user.password = [NSString stringWithFormat:@"%i23456", i];
            user.phoneNumber = [NSString stringWithFormat:@"01012345%i", i];
            user.categories = [[CoreDataManager instance] userCategories];
            
            /// Add Account 
            NSMutableArray* accountArray = [[NSMutableArray alloc] init];
            for (int j = 1; j <= objectsCount; ++j) {
                MOAccount* account = [[CoreDataManager instance] account];
                account.amount = [NSNumber numberWithDouble:(j * 1000)];
                account.type = [@"Account type " stringByAppendingFormat:@"%d", j];
                account.moDescription = [NSString stringWithFormat:@"Account %i description", j];
                account.name = [NSString stringWithFormat:@"Account %i", j];
                account.dateTime = [NSDate date];
                account.account = account;
                [accountArray addObject:account];
            }
            user.accounts = [NSSet setWithArray:accountArray];
            
            // Add Incomes
            NSMutableArray* incomeArray = [[NSMutableArray alloc] init];
            for (int j = 1; j <= objectsCount; ++j) {
                MOIncome* income = [[CoreDataManager instance] income];
                income.amount = [NSNumber numberWithDouble:20000 * j];                
                income.moDescription = [NSString stringWithFormat:@"Income%i description", j];
                income.name = [NSString stringWithFormat:@"Income %i", j];
                
                NSDate *now = [NSDate date];
                int daysToAdd = j * 5 * -1;
                now = [now dateByAddingTimeInterval:60 * 60 * 24 * daysToAdd];                
                income.dateTime = now;
                
                income.isRecurring = [NSNumber numberWithBool:NO];
                
                income.account = [accountArray objectAtIndex:(j - 1)];
                
                MORecurrence* recurrence = [[CoreDataManager instance] recurring];
                recurrence.dateTime = now;
                recurrence.amount = income.amount;
                recurrence.isDone = [NSNumber numberWithBool:YES];
                recurrence.transfer = income;
                [income.recurrings addObject:recurrence];
                
                [incomeArray addObject:income];
            }
            user.incomes = [NSSet setWithArray:incomeArray];
            [incomeArray release];
            
            
            // Add Payments
            NSMutableArray* paymentArray = [[NSMutableArray alloc] init];
            for (int j = 1; j <= objectsCount; ++j) {
                MOPayment* payment = [[CoreDataManager instance] payment];
                payment.amount = [NSNumber numberWithDouble:1000 * j * (-1)];
                payment.moDescription = [NSString stringWithFormat:@"Payment%i description", j];
                payment.name = [NSString stringWithFormat:@"Payment %i", j];
                payment.isRecurring = [NSNumber numberWithBool:NO];
                
                LocationInfo* locationInfo = [[LocationInfo alloc] init];
                locationInfo.title = @"Yerevan";
                locationInfo.subtitle = [NSString stringWithFormat:@"Bagramyan %i", j];
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = 40.2;
                coordinate.longitude = 44.5;
                locationInfo.coordinate = coordinate;
                payment.location = [LocationInfo dataFromLocationInfo:locationInfo];
                [locationInfo release];
                
                NSDate *now = [NSDate date];
                int daysToAdd = j * 7 * -1;
                now = [now dateByAddingTimeInterval:60 * 60 * 24 * daysToAdd];                
                payment.dateTime = now;
                
                payment.isRecurring = [NSNumber numberWithBool:NO];
                
                MORecurrence* recurrence = [[CoreDataManager instance] recurring];
                recurrence.dateTime = now;
                recurrence.amount = payment.amount;
                recurrence.isDone = [NSNumber numberWithBool:YES];
                recurrence.transfer = payment;
                [payment.recurrings addObject:recurrence];
                
                MOCategory* category = nil;
                switch (j % 5 + 1) {
                    case 1:
                        category = [[CoreDataManager instance] categoryByName:NSLocalizedString(@"Mortgage", nil) fromSet:user.categories];
                        break;
                    case 2:
                        category = [[CoreDataManager instance] categoryByName:NSLocalizedString(@"Internet", nil) fromSet:user.categories];
                        break;
                    case 3:
                        category = [[CoreDataManager instance] categoryByName:NSLocalizedString(@"Auto Loan", nil) fromSet:user.categories];
                        break;
                    case 4:
                        category = [[CoreDataManager instance] categoryByName:NSLocalizedString(@"Insurance - Home", nil) fromSet:user.categories];
                        break;
                    case 5:
                        category = [[CoreDataManager instance] categoryByName:NSLocalizedString(@"Electricity", nil) fromSet:user.categories];
                        break;
                    default:
                        break;
                }
                payment.category = category;
                
                payment.account = [accountArray objectAtIndex:(j - 1)];
                
                [paymentArray addObject:payment];
            }
            user.payments = [NSSet setWithArray:paymentArray];
            [paymentArray release];
            
            [accountArray release];
            
            // Add Setting
            MOSetting* setting = [[CoreDataManager instance] setting];
            user.setting = setting;
            
            MOSearchSettings* searchSettings = [[CoreDataManager instance] searchSettings];
            user.searchSettings = searchSettings;
        }
        
        // Save Users
        [[CoreDataManager instance] saveContext];
    }
}

@end
