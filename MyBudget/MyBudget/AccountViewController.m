/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 2/9/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */
#import "AccountViewController.h"
#import "MOUser.h"
#import "CoreDataManager.h"
#import "MyBudgetHelper.h"

#import <QuartzCore/QuartzCore.h>

/// the account type label tag
#define ACCOUNT_TYPE_LABEL_TAG 133


@implementation AccountViewController

- (id)initWithTransfer:(id)payment{
    self = [super initWithTransfer:payment];
    if (self) {
        // Custom initialization
        scrollingUpHeight = 160;
        scrollingDownHeight = 100;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)updatePage {
    [self createEditSaveBarButton:@selector(editSaveTransfer)];
    [self createMainFieldsForm:((MOAccount*)currentMO).initialAmount
                          name:currentMO.name
                         notes:currentMO.moDescription
                          date:nil dateName:@"" accountName:@""];
    UITextField* amountTextField = (UITextField*)[transferScrollView viewWithTag:AMOUNT_TEXT_FIELD_TAG];
    amountTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self createFieldTitleWithOriginY:(originY + VERTICAL_DIFFERENCE_BETWEEN_VIEW) withString:NSLocalizedString(@"Type", nil) tag:ACCOUNT_TYPE_LABEL_TAG];
    [self createAccountTypeField];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updatePage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)saveTransfer {
    // Check for errors
    UITextField* amount = (UITextField *)[self.view viewWithTag:AMOUNT_TEXT_FIELD_TAG];
    if([amount.text length] == 0){
        [self showMessageAlert:NSLocalizedString(@"Please fill in amount field", nil)];
        return;
    }

    UITextField* nameTextField = (UITextField *)[self.view viewWithTag:NAME_TEXT_FIELD_TAG];
    NSString* name = [MyBudgetHelper trimString:nameTextField.text];
    if([name length] == 0){
        [self showMessageAlert:NSLocalizedString(@"Please fill in name field", nil)];
        return;
    }
    
    if ([[CoreDataManager instance] isInSet:[MOUser instance].accounts nameBusy:name]) {
        [self showMessageAlert:NSLocalizedString(@"The name is already used.\nPlease try another name." , nil)];
        return;
    }
    
    UITextField* accountTypeTextField = (UITextField *)[self.view viewWithTag:ACCOUNT_TYPE_TEXT_FIELD_TAG];
    NSString* accountType = [MyBudgetHelper trimString:accountTypeTextField.text];
    if (0 == [accountType length]) {
        [self showMessageAlert:NSLocalizedString(@"Please fill in type field", nil)];
        return;
    }
    
    // All right, can save
    if (!currentMO) {
        currentMO = [[CoreDataManager instance] account];
    }
    
    ((MOAccount*)currentMO).initialAmount = [NSDecimalNumber decimalNumberWithString:amount.text];
    
    ((MOAccount*)currentMO).amount = [NSDecimalNumber decimalNumberWithString:amount.text];
    
    currentMO.name = name;
    
    UITextView* notes = (UITextView *)[self.view viewWithTag:NOTES_TEXT_VIEW_TAG];
    currentMO.moDescription = notes.text;
    ((MOAccount*)currentMO).type = accountType;
    
    ((MOAccount*)currentMO).user = [MOUser instance];
    [[MOUser instance].accounts addObject:currentMO];
    
    currentMO.account = (MOAccount*)currentMO;
    
    // Save data
    [[CoreDataManager instance] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
} 

-(void)editTransfer {
    isInEditMode = YES;
    [self updatePage];
}

-(void)editSaveTransfer {
    if (isInEditMode) {
        [self saveTransfer];
    } else {
        [self editTransfer];
    }
}

@end
