/**
 *   @file 
 *   My Budget
 *
 *   Created by Arevik Tunyan on 24/01/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@protocol MailManagerDelegate;

/// The class is responsible for sending emails, such as feedback.
@interface MailManager : NSObject<MFMailComposeViewControllerDelegate> {
    
    /// The instance of @ref MailManagerDelegate protocol.
    id<MailManagerDelegate> delegate;
}

/// Returns the only instance of MailManager class.
+(MailManager *) instance;

@property (nonatomic, assign) id<MailManagerDelegate> delegate;

/**
 * @brief Composes an email.
 * @param subject - the subject of the email to be sent
 * @param toRecipients - the list of recipients in TO section
 * @param emailBody - the body of the email to be sent
 */
-(void) feedbackAction:(NSString *) subject recipients:(NSArray *)toRecipients
             emailBody:(NSString *)emailBody;

@end

/// The protocol of Mail management.
@protocol MailManagerDelegate <NSObject>

@optional
@end
