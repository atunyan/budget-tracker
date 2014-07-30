/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 2/13/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

#import "DatePickerViewController.h"
#import "PaymentSettings.h"
#import "TransferViewController.h"
#import "CategoriesListViewController.h"
#import "MOCategory.h"
#import "LocationInfo.h"


/// the tag for category button
#define CATEGORY_BUTTON_TAG 66

/// The tag for location button
#define LOCATION_BUTTON_TAG 77

/**
 * @brief PaymentViewController class. This class is responsible for 
 * adding/changeing new payment. After creating new payment,the created payment
 * displays on @ref PaymentsListViewController.
 */
@interface PaymentViewController :  TransferViewController <CategoryListViewControllerDelegate, DatePickerViewControllerDelegate> {
    
    /// Shows whether date or reminder is selected.
    BOOL isDateSelected;
    
    /// The category of current managed object
    MOCategory* category;
    
    /// Location info temporary object
    LocationInfo* locationInfo;
    
    /// Return YES if category is selected.
    BOOL didCategorySelected;
}

/**
 * @brief Initializes the class properties with the predifined values.
 * @param payment - The member of the currentPayment, may be also nil.
 * @param isFromCalendar - indicates is view opened from calendar or not
 * @return - Initialized the class object.
 */
- (id)initWithTransfer:(id)payment isOpenedFromCalendar:(BOOL)isFromCalendar;

@end
