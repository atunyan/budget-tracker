/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 2/16/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "AccountDetailViewController.h"
#import "TransactionListTableViewController.h"
#import "IncomeViewController.h"
#import "PaymentViewController.h"
#import "CoreDataManager.h"
#import "MOUser.h"
#import "MyBudgetHelper.h"
#import "MORecurrence.h"
#import "MOPayment.h"
#import "ActionManager.h"

#import <QuartzCore/QuartzCore.h>

/// the add income button tag
#define ADD_INCOME_BUTTON_TAG 30

/// the add payment button tag
#define ADD_BILL_BUTTON_TAG 50

/// the incomes amount label tag
#define TOTAL_INCOMES_LABEL_TAG 60

/// the incomes amount value tag
#define TOTAL_INCOMES_VALUE_TAG 61

/// the payments amount tag
#define TOTAL_BILLS_LABEL_TAG   80

/// the payments amount value tag
#define TOTAL_BILLS_VALUE_TAG   81

/// the balance label tag
#define ACCOUNT_BALANCE_LABEL_TAG   90

/// the balance value tag
#define ACCOUNT_BALANCE_VALUE_TAG   91

/// the total amount label tag
#define ACCOUNT_TOTAL_LABEL_TAG     100

/// the total amount value tag
#define ACCOUNT_TOTAL_VALUE_TAG     101

/// the transations button tag
#define VIEW_TRANSACTION_BUTTON_TAG 120

/// the vertical difference between fields
#define VERTICAL_DIFFERENCE_BETWEEN_FIELDS 10

/// Delete alert view tag
#define DELETE_ALERT_VIEW_TAG       300

@implementation AccountDetailViewController

@synthesize delegate;
@synthesize isInEditMode;

- (id)initWithAccount:(MOAccount*)account
{
    self = [super init];
    if (self) {
        // Custom initialization
        currentAccount = account;
        isInEditMode = NO;
    }
    return self; 
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/// this method creates accounts detais fields
-(void)createDetailFieldsWithOriginY:(CGFloat)frameOriginY withTag:(NSInteger)tag withFieldTitle:(NSString*)fieldTitle withAmount:(NSNumber*)amount withTextColor:(UIColor*)textColor withValueTag:(NSInteger)valueTag {
    
    UILabel* fieldNamelabel = (UILabel*)[self.view viewWithTag:tag];
    if (!fieldNamelabel) {
        fieldNamelabel = [[[UILabel alloc]initWithFrame:CGRectMake(10, frameOriginY, 130, 30)] autorelease];
        fieldNamelabel.backgroundColor = [UIColor clearColor];
        fieldNamelabel.textAlignment = UITextAlignmentLeft;
        
        fieldNamelabel.tag = tag;
        fieldNamelabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [self.view addSubview:fieldNamelabel];
    }
    fieldNamelabel.textColor = textColor;
    fieldNamelabel.text = fieldTitle;

    
    UILabel* amountLabel = (UILabel*)[self.view viewWithTag:valueTag];
    if (!amountLabel) {
        amountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(fieldNamelabel.frame.origin.x + fieldNamelabel.frame.size.width + 10, frameOriginY, 160, 30)] autorelease];
        amountLabel.tag = valueTag;
        amountLabel.textAlignment = UITextAlignmentRight;
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:amountLabel];
    }
    amountLabel.text = [NSString stringWithFormat:@"%.2f %@",[amount doubleValue] ,[MOUser instance].setting.currency];
    amountLabel.textColor = textColor;
    
    theOriginY = amountLabel.frame.origin.y + amountLabel.frame.size.height;
}

/// this method create add incom/payment buttons
-(void)createButtonWithOriginX:(CGFloat)originX withTitle:(NSString*)title withTag:(NSInteger)tag {
    UIButton* addTransferBtn = (UIButton*)[self.view viewWithTag:tag];
    if (!addTransferBtn) {
        addTransferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addTransferBtn.layer.cornerRadius = 6.0f;
        addTransferBtn.tag = tag;
        addTransferBtn.titleLabel.lineBreakMode  = UILineBreakModeWordWrap;
        addTransferBtn.titleLabel.textAlignment = UITextAlignmentCenter;
        addTransferBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [addTransferBtn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addTransferBtn];
    }
    addTransferBtn.frame = CGRectMake(originX, theOriginY + 7 *VERTICAL_DIFFERENCE_BETWEEN_FIELDS, 90, 60);
    [addTransferBtn setTitle:title forState:UIControlStateNormal];
    
    if (tag != VIEW_TRANSACTION_BUTTON_TAG) {
        [addTransferBtn setEnabled:isInEditMode];
        
        if (isInEditMode) {
            addTransferBtn.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
        } else {
            addTransferBtn.backgroundColor = [UIColor colorWithRed:195.0/255.0 green:189.0/255.0 blue:180.0/255.0 alpha:1.0f];
        }
    } else {
        addTransferBtn.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
    }
    
    theOriginX  = addTransferBtn.frame.origin.x + addTransferBtn.frame.size.width;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)createDeleteButton {
    UIButton* deleteButton = (UIButton*)[self.view viewWithTag:DELETE_BUTTON_TAG];
    UIImage* image = [UIImage imageNamed:@"delete.png"];
    if (!deleteButton) {
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.layer.cornerRadius = 5.0f;
        
        [deleteButton setBackgroundImage:image forState:UIControlStateNormal];
        deleteButton.clipsToBounds = YES;
        deleteButton.tag  = DELETE_BUTTON_TAG;
        [deleteButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
        deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [deleteButton addTarget:self action:@selector(deleteTransfer) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:deleteButton];
    }
    deleteButton.frame = CGRectMake(65, theOriginY + VERTICAL_DIFFERENCE_BETWEEN_VIEW - 2, image.size.width, image.size.height);
}

-(void) createEditSaveBarButton {
    UIBarButtonItem *saveBarButtonItem;
    if (isInEditMode) {
        saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(editSaveTransfer)];
    } else {
        saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(editSaveTransfer)];
    }
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    [saveBarButtonItem release];
}

-(void)updatePage {
    
    [self createEditSaveBarButton];
    
    // create account field
    [self createDetailFieldsWithOriginY:(theOriginY + VERTICAL_DIFFERENCE_BETWEEN_FIELDS) withTag:ACCOUNT_TOTAL_LABEL_TAG withFieldTitle:NSLocalizedString(@"Account", nil) withAmount:currentAccount.amount withTextColor:[UIColor whiteColor] withValueTag:ACCOUNT_TOTAL_VALUE_TAG];
    
    // create income field
    NSNumber* amount = [ActionManager totalAmountOfAccountIncomes:currentAccount];
    UIColor* color = [UIColor colorWithRed:35.0/255.0 green:142.0/255.0 blue:35.0/255.0 alpha:1.0];
    [self createDetailFieldsWithOriginY :(theOriginY + VERTICAL_DIFFERENCE_BETWEEN_FIELDS) withTag:TOTAL_INCOMES_LABEL_TAG withFieldTitle:NSLocalizedString(@"Incomes", nil) withAmount:amount withTextColor:color withValueTag:TOTAL_INCOMES_VALUE_TAG];
    
    // create payments field 
    amount = [ActionManager totalAmountOfAccountPayments:currentAccount]; 
    color = [MyBudgetHelper paymentColor];
    [self createDetailFieldsWithOriginY:(theOriginY + VERTICAL_DIFFERENCE_BETWEEN_FIELDS) withTag:TOTAL_BILLS_LABEL_TAG withFieldTitle:NSLocalizedString(@"Payments", nil) withAmount:amount withTextColor:color withValueTag:TOTAL_BILLS_VALUE_TAG];
    
    // create balance field
    amount = [NSNumber numberWithDouble:[currentAccount.amount doubleValue] -  [currentAccount.initialAmount doubleValue]]; 
    color = ([currentAccount.amount doubleValue] -  [currentAccount.initialAmount doubleValue] > 0) ?[UIColor colorWithRed:35.0/255.0 green:142.0/255.0 blue:35.0/255.0 alpha:1.0] : [MyBudgetHelper paymentColor];
    
    [self createDetailFieldsWithOriginY:theOriginY + VERTICAL_DIFFERENCE_BETWEEN_FIELDS withTag:ACCOUNT_BALANCE_LABEL_TAG withFieldTitle:NSLocalizedString(@"Balance", nil) withAmount:amount withTextColor:color withValueTag:ACCOUNT_BALANCE_VALUE_TAG];
    
    // create add income button
    [self createButtonWithOriginX:(theOriginX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW + 5 ) withTitle:NSLocalizedString(@"Add\nIncome", nil) withTag:ADD_INCOME_BUTTON_TAG];
    // create add payment button
    [self createButtonWithOriginX:(theOriginX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW) withTitle:NSLocalizedString(@"Add\nPayment", nil) withTag:ADD_BILL_BUTTON_TAG];
    // create add transaction button
    [self createButtonWithOriginX:(theOriginX + HORIZONTAL_DIFFERENCE_BETWEEN_VIEW) withTitle:NSLocalizedString(@"View\nTrans", nil) withTag:VIEW_TRANSACTION_BUTTON_TAG];
    
    UIButton* viewTransButton = (UIButton*)[self.view viewWithTag:VIEW_TRANSACTION_BUTTON_TAG];
    theOriginY = viewTransButton.frame.origin.y + viewTransButton.frame.size.height + 3 * HORIZONTAL_DIFFERENCE_BETWEEN_VIEW;
    [self createDeleteButton];
}

-(void)editTransfer {
    isInEditMode = YES;
    [self updatePage];
}

-(void)saveTransfer {
    isInEditMode = NO;
    [self updatePage];
}

-(void)editSaveTransfer {
    theOriginX = 0;
    theOriginY = 0;
    if (isInEditMode) {
        [self saveTransfer];
    } else {
        [self editTransfer];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"budget_bg.png"]];
    [self updatePage];
}

-(void)deleteTransfer {
    if ([ActionManager deleteTransfer:currentAccount view:self.view.window delegate:self]) {
        if ([delegate respondsToSelector:@selector(didDeletedTransfer)]) {
            [delegate didDeletedTransfer];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } 
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [ActionManager deleteNonRecurringItem:currentAccount];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - the target methods

-(void)selectButton:(UIButton*)button {
    if(button.tag == ADD_INCOME_BUTTON_TAG){
        
        IncomeViewController *incomeViewController = [[IncomeViewController alloc] initWithTransfer:nil isOpenedFromCalendar:NO];
        incomeViewController.title = NSLocalizedString(@"Add Income", nil);
        [self.navigationController pushViewController:incomeViewController animated:YES];
        [incomeViewController didSelectAccount:currentAccount];
        [incomeViewController release];
     } else if(button.tag == ADD_BILL_BUTTON_TAG) {
        
        PaymentViewController *paymentViewController = [[PaymentViewController alloc] initWithTransfer:nil isOpenedFromCalendar:NO];
        paymentViewController.title = NSLocalizedString(@"Add Payment", nil);
        [self.navigationController pushViewController:paymentViewController animated:YES];
        [paymentViewController didSelectAccount:currentAccount];
        [paymentViewController release];
        
    } else if(button.tag == VIEW_TRANSACTION_BUTTON_TAG){
        TransactionListTableViewController* transactionListViewController = [[TransactionListTableViewController alloc] initWithStyle:UITableViewStylePlain withAccount:currentAccount];
        transactionListViewController.title = NSLocalizedString(@"Transactions", nil);
        [self.navigationController pushViewController:transactionListViewController animated:YES];
        
        [transactionListViewController release];
    }
}

@end
