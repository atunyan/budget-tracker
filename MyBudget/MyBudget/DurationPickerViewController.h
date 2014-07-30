/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 02/02/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@protocol DurationPickerViewControllerDelegate;

/**
 * @brief DurationPickerViewController class is responsible for creating and showing 
 * date picker. 
 */
@interface DurationPickerViewController : UIViewController {
    
    /// Date picker view
    UIDatePicker* datePicker; 

    /// end date
    NSDate* endDate;
    
    /// Start date for validation comparing end date
    NSDate* startDate;
    
    /// format for end date
    NSDateFormatter *formatter;
        
	id<DurationPickerViewControllerDelegate> delegate;
}

/// the DurationPickerViewControllerDelegate delegate
@property (nonatomic,assign) id<DurationPickerViewControllerDelegate> delegate;         

/**
 * @brief Initializes the date picker with the given data
 * @param selectedStartDate - the selected start date for validation comparing with end date
 * @param selectedEndDate - the selected end date
 * @return - the initialized self
 */
- (id)initWithStartDate:(NSDate*)selectedStartDate andEndDate:(NSDate*)selectedEndDate;

@end

/**
 * @brief the DurationPickerViewControllerDelegate. Responsible for passing back 
 * the selected start and end dates.
 */
@protocol DurationPickerViewControllerDelegate <NSObject>

@required 

/**
 * @brief  Calls for receiving periodicity and end date from pickers
 * @param startDate - the start date
 * @param endDate - the end date
 */
-(void)didSavedWithStartDate:(NSDate*)startDate andWithEndDate:(NSDate*)endDate;

@end

