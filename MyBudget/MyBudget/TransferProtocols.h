/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 4/3/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

/// handles operations within transfer view controller
@protocol TransferViewControllerDelegate <NSObject>

@optional

/**
 * @brief  Call when trasfer saved
 * @param managedObject - transfer object, that should be saved and added into list
 */
-(void)didSavedTransfer:(NSManagedObject*)managedObject;

/**
 * @brief  Call when trasfer deleted
 */
-(void)didDeletedTransfer;

@end


