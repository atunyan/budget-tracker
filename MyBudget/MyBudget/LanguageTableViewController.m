//
//  LanguageTableViewController.m
//  My Budget
//
//  Created by Arevik Tunyan on 4/16/12.
//  Copyright (c) 2012 MyBudget. All rights reserved.
//

#import "LanguageTableViewController.h"
#import "SelectingInfo.h"
#import "MOUser.h"
#import "MOSetting.h"
#import "CoreDataManager.h"

/// App exit alert view's tag
#define ALERT_VIEW_EXIT_APP                 53

@implementation LanguageTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    
    NSDictionary* languageDictionary = [selectingInfo.elementArray objectAtIndex:indexPath.row];
    NSString* key = [[languageDictionary allKeys] objectAtIndex:0];
    cell.textLabel.text = key;
    if ([key isEqualToString:selectingInfo.currentElement]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* languageDictionary = [selectingInfo.elementArray objectAtIndex:indexPath.row];
    NSString* key = [[languageDictionary allKeys] objectAtIndex:0];
    if (![[MOUser instance].setting.language isEqualToString:key]) {        
        [MOUser instance].setting.language = key;
        [[CoreDataManager instance] saveContext];
        
        [[NSUserDefaults standardUserDefaults] setObject: [NSArray arrayWithObjects:[languageDictionary valueForKey:key] , nil] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Language changed!", nil) 
                                                            message:NSLocalizedString(@"In order to apply changes, you need to restart app. Please press OK", nil) 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                  otherButtonTitles:nil, nil];
        alertView.tag = ALERT_VIEW_EXIT_APP;
        [alertView show];
        [alertView release];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIAlertViewDelegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_VIEW_EXIT_APP:
            if(buttonIndex == 0){
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        default:
            break;
    }
}

@end
