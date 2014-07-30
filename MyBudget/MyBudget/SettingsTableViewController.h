/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/6/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "MailManager.h"
#import "LoginViewController.h"

/**
 * @brief Displays settings list and responsible for settings' configurations.
 */
@interface SettingsTableViewController : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate, MailManagerDelegate, LoginViewControllerDelegate> {
    NSMetadataQuery* metadataQuery;
    
    id<LoginViewControllerDelegate> delegate;
}

/// metadata query for iCloud access
@property (nonatomic, retain) NSMetadataQuery* metadataQuery;

/// The delegate of @ref LoginViewControllerDelegate protocol
@property (nonatomic, assign) id<LoginViewControllerDelegate> delegate;

@end
