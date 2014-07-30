/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 3/5/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class MOAccount;

/// Used as Column reporting model file
@interface ColumnReportInfo : NSObject {
    NSNumber* incomeValue;
    UIColor* incomeColor;
    
    NSNumber* paymentValue;
    UIColor* paymentColor;
    
    MOAccount* account;
    UIColor* accountColor;
}

/// income amount value
@property (nonatomic, retain) NSNumber* incomeValue;

/// income column color
@property (nonatomic, retain) UIColor* incomeColor;

/// payment amount value
@property (nonatomic, retain) NSNumber* paymentValue;

/// payment column color
@property (nonatomic, retain) UIColor* paymentColor;

/// account amount value
@property (nonatomic, retain) MOAccount* account;

/// account column color
@property (nonatomic, retain) UIColor* accountColor;

/**
 * @brief  Creates object with specified income, payment and account amounts
 * @param income - income amount
 * @param payment - payment amount
 * @param anAccount - account
 * @return - Initialized object
 */
-(id)initWithIncome:(NSNumber*)income payment:(NSNumber*)payment account:(MOAccount*)anAccount;

@end
