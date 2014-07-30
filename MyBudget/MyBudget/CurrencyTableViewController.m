/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/8/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "CurrencyTableViewController.h"
#import "CurrencyInfo.h"
#import "MOUser.h"
#import "MOSetting.h"
#import "CoreDataManager.h"

/// currency alert view tag
#define ALERT_VIEW_CHANGE_CURRENCY      100

@implementation CurrencyTableViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    
    NSString* currencyFullName = [selectingInfo.elementArray objectAtIndex:indexPath.row];
    cell.textLabel.text = currencyFullName;
    if ([CurrencyInfo isFullCurrency:currencyFullName containsCurrentCurrency:selectingInfo.currentElement]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        if (indexPath.row == 0) {
            NSLocale *theLocale = [NSLocale currentLocale];
//            NSString *symbol = [theLocale objectForKey:NSLocaleCurrencySymbol];
            NSString *code = [theLocale objectForKey:NSLocaleCurrencyCode];
            if ([selectingInfo.currentElement isEqualToString:code]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRowIndex = indexPath.row;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Change currency", nil) 
                                                        message:NSLocalizedString(@"Do you really want to change currency?", nil) 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"YES", nil) 
                                              otherButtonTitles:NSLocalizedString(@"NO", nil), nil];
    alertView.tag = ALERT_VIEW_CHANGE_CURRENCY;
    [alertView show];
    [alertView release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_VIEW_CHANGE_CURRENCY:
            if(buttonIndex == 0){
                NSString* currencyName = nil;
                
                if (selectedRowIndex == 0) {
                    // Set default currency
                    NSLocale *theLocale = [NSLocale currentLocale];
            //        NSString *symbol = [theLocale objectForKey:NSLocaleCurrencySymbol];
                    NSString *code = [theLocale objectForKey:NSLocaleCurrencyCode];
                    currencyName = code;
                } else {
                    NSString* currencyFullName = [selectingInfo.elementArray objectAtIndex:selectedRowIndex];
                    currencyName = [CurrencyInfo currencyFromFullName:currencyFullName];
                }
                
                if (![[MOUser instance].setting.currency isEqualToString:currencyName]) {
                    [MOUser instance].setting.currency = currencyName;
                    [[CoreDataManager instance] saveContext];
                }
            }
            break;
            
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollToSelectedRow {
    NSInteger currentCurrencyIndex = [CurrencyInfo currencyIndexByCurrencyName:selectingInfo.currentElement fromCurrencyArray:selectingInfo.elementArray];
    if (currentCurrencyIndex > -1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentCurrencyIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }    
}

@end
