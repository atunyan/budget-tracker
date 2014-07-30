/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 02/02/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@protocol DataPickerViewControllerDelegate;

/**
 * @brief DataPickerViewController class is responsible for creating and showing 
 * date picker. 
 */
@interface DataPickerViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource> {
    
    /// periodicity picker view
    UIPickerView* periodicityPicker; 
    
    /// end date picker view
    UIDatePicker* endDatePicker;

    /// the NSData object. Keeps already selected data. Sets nil only at initializing class.
    NSString* periodicity;

    /// end date
    NSDate* endDate;
    
    /// Start date for validation comparing end date
    NSDate* startDate;
    
    /// format for end date
    NSDateFormatter *formatter;
        
	id<DataPickerViewControllerDelegate> delegate;
    
    /// The array of periods 
    NSArray* arrayOfRepeatDays;
}

/// the DataPickerViewControllerDelegate delegate
@property (nonatomic,assign) id<DataPickerViewControllerDelegate> delegate;         

/**
 * @brief Initializes the date picker with the given data
 * @param selectedPeriodicity - the selected periodicity
 * @param selectedEndDate - the selected end date
 * @param selectedStartDate - the selected start date for validation comparing with end date
 * @return - the initialized self
 */
- (id)initWithPeriodicity:(NSString*)selectedPeriodicity andWithEndDate:(NSDate*)selectedEndDate andWithStartDate:(NSDate*)selectedStartDate;

@end

/**
 * @brief the DataPickerViewControllerDelegate. Responsible for date 
 * selection.
 */
@protocol DataPickerViewControllerDelegate <NSObject>

@optional 

/**
 * @brief  Calls for receiving periodicity and end date from pickers
 * @param periodicity - periodicity
 * @param endDate - end date
 */
-(void)didSavedWithPeriodicity:(NSString*)periodicity andWithEndDate:(NSDate*)endDate;

@end

