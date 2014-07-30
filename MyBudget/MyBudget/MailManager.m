/**
 *   @file 
 *   My Budget
 *
 *   Created by Arevik Tunyan on 24/01/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "MailManager.h"

static MailManager *instance;

@implementation MailManager
@synthesize delegate;

+(MailManager *) instance {
	if(instance == nil) {
		instance = [[MailManager alloc] init];
	}
	return instance;
}

/**
 * Displays an email composition interface inside the application. 
 * Populates all the Mail fields. 
 */
-(void)displayComposerSheet:(NSString *) subject recipients:(NSArray *)toRecipients
                  emailBody:(NSString *)emailBody
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    [picker setSubject:subject];

	// Set up recipients
	[picker setToRecipients:toRecipients];
	
	// Fill out the email body text
	[picker setMessageBody:emailBody isHTML:YES];
    
	[(UIViewController *)delegate presentModalViewController:picker animated:YES];
    [picker release];
}

-(void) launchMailAppOnDevice:(NSString *) subject recipients:(NSArray *)toRecipients
                    emailBody:(NSString *)emailBody
{
    if (0 == [toRecipients count]) {
        toRecipients = [NSArray arrayWithObject:@""];
    }
	NSString *recipients =[NSString stringWithFormat:@"mailto:%@?subject=%@!", toRecipients, subject];
	NSString *body = [NSString stringWithFormat:@"&body=%@",emailBody];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL * phoneURL = [NSURL URLWithString: email];
	UIApplication * app = [UIApplication sharedApplication];
	
	[app openURL:phoneURL];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	NSString * message;
	// Notifies users about errors associated with the interface
	[(UIViewController *)delegate dismissModalViewControllerAnimated:YES];
	switch (result) {
		case MFMailComposeResultCancelled:
			//message = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			//message = @"Result: saved";
			break;
		case MFMailComposeResultSent: {
			message = NSLocalizedString(@"Message is sent successfully.", nil);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", nil) message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            [alert show];        
            [alert release];
        }
			break;
		case MFMailComposeResultFailed: {
			message = NSLocalizedString(@"Message sending failed.", nil);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", nil) message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            [alert show];        
            [alert release];
        }
			break;
		default: {
            message = NSLocalizedString(@"Message sending failed. Unknown error occurred.", nil);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", nil) message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            [alert show];        
            [alert release];
        }
			break;
	}
	
}

-(void) feedbackAction:(NSString *) subject recipients:(NSArray *)toRecipients
             emailBody:(NSString *)emailBody {
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil) {
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) {
			[self displayComposerSheet:subject recipients:toRecipients 
                                                emailBody:emailBody];
		} else {
			[self launchMailAppOnDevice:subject recipients:toRecipients
                              emailBody:emailBody];
		}
	} else {
		[self launchMailAppOnDevice:subject recipients:toRecipients
                          emailBody:emailBody];
	}
}

@end 
