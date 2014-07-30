/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 1/12/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@protocol DatePickerViewControllerDelegate;

/**
 * @brief DatePickerViewController class is responsible for creating and showing 
 * date picker. 
 */
@interface DatePickerViewController : UIViewController {
    /// the UIDatePicker object
    UIDatePicker* datePicker;  

    NSDate* date;
    
    NSDate* endDate;
        
	id<DatePickerViewControllerDelegate> delegate;
    
    UIDatePickerMode datePickerMode;
    
    /// The format of datePicker
    NSString* dateFormat;
}

/// the DatePickerViewControllerDelegate delegate
@property (nonatomic,assign) id<DatePickerViewControllerDelegate> delegate;

/// the NSDate object.Keeps already selected date. Sets nil only at initializing class. 
@property (nonatomic, retain) NSDate * date;

/// periodicity end date
@property (nonatomic, retain) NSDate* endDate;

/// the datePicker mode
@property(nonatomic) UIDatePickerMode datePickerMode;  

/**
 * @brief Initializes the date picker with the given date and 
 * mode.
 * @param selectedDate - the selected date to initialize the 
 * date picker.
 * @param anEndDate - periodicity end date
 * @param mode - the date picker mode
 * @return - the initialized self. 
 */
- (id)initWithDate:(NSDate*)selectedDate withEndDate:(NSDate*)anEndDate andMode:(UIDatePickerMode)mode;

@end

/**
 * @brief the DatePickerViewControllerDelegate. Responsible for date selection.
 */
@protocol DatePickerViewControllerDelegate <NSObject>

@optional 

/**
 * @brief this method calls at selecting date from date picker
 * @param date - the selected date
 */
-(void)datePickerControllerDidSave:(NSDate *) date;

@end

