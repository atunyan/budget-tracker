/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 2/16/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MOAccount.h"
#import "TransferProtocols.h"

/// @brief AcountDetailViewController class is responsible for showing account detials. 
@interface AccountDetailViewController : UIViewController <UIActionSheetDelegate> {
    
    /// the current account
    MOAccount* currentAccount;
    
    /// the fields origin Y
    CGFloat theOriginY;
    
    /// the fields origin X
    CGFloat theOriginX;
    
    id<TransferViewControllerDelegate> delegate;
    
    BOOL isInEditMode;
}

/// The delegate of @ref TransferViewControllerDelegate protocol
@property (nonatomic, assign) id<TransferViewControllerDelegate> delegate;

/// account view editing mode
@property (nonatomic, assign) BOOL isInEditMode;

/**
 * @brief initilizing with current account object
 * @param currentAccount - the @ref MOAccount class object
 * @return current viewController object
 */
- (id)initWithAccount:(MOAccount*)currentAccount;

@end
