/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 03/02/12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "ListView.h"
#import "MOUser.h"
#import "MOAccount.h"
#import "LocationInfo.h"
#import "MOIncome.h"
#import "MOPayment.h"
#import "MOAccount.h"
#import "CoreDataManager.h"
#import "MOCategory.h"
#import "MOTransfer.h"
#import "MORecurrence.h"
#import "Constants.h"
#import "MyBudgetHelper.h"
#import "ActionManager.h"

@implementation ListView

+(void) createSubtitleLabel:(UITableViewCell *)cell {
    UILabel* subtitleLabel = (UILabel *) [cell.contentView viewWithTag:SUBTITLE_LABEL_TAG];
    if (! subtitleLabel) {
        subtitleLabel = [[[UILabel alloc] init] autorelease];
        subtitleLabel.textColor = [UIColor darkGrayColor];
        subtitleLabel.font = [UIFont boldSystemFontOfSize:12.0];
        subtitleLabel.tag = SUBTITLE_LABEL_TAG;
        subtitleLabel.textAlignment = UITextAlignmentLeft;
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.text = @"";
        subtitleLabel.frame = CGRectMake(60, cell.contentView.frame.origin.y + 23, 110, 20);
        [cell.contentView addSubview: subtitleLabel];
    }
}

+(void) createStatusLabel:(UITableViewCell *)cell {
    UILabel* statusLabel = (UILabel *) [cell.contentView viewWithTag:STATUS_LABEL_TAG];
    if (! statusLabel) {
        statusLabel = [[[UILabel alloc] init] autorelease];
        statusLabel.textColor = [UIColor blackColor];
        statusLabel.font = [UIFont boldSystemFontOfSize:12.0];
        statusLabel.tag = STATUS_LABEL_TAG;
        statusLabel.textAlignment = UITextAlignmentCenter;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.text = @"";
        statusLabel.frame = CGRectMake(230, cell.contentView.frame.origin.y + 58, 60, 20);
        [cell.contentView addSubview: statusLabel];
    }
}


+(void) createTitleLabel:(UITableViewCell *)cell {
    UILabel*titleLabel = (UILabel *) [cell.contentView viewWithTag:TITLE_LABEL_TAG];
    if (! titleLabel) {
        titleLabel = [[[UILabel alloc] init] autorelease];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        titleLabel.tag = TITLE_LABEL_TAG;
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"";
        titleLabel.frame = CGRectMake(60, cell.contentView.frame.origin.y, cell.contentView.frame.size.width - 80, 25);
        [cell.contentView addSubview: titleLabel];
    }
}

+(void) createAccountLabel:(UITableViewCell *)cell {
    UILabel* accountLabel = (UILabel *) [cell.contentView viewWithTag:ACCOUNT_LABEL_TAG];
    if (!accountLabel) {
        accountLabel = [[[UILabel alloc] init] autorelease];
        accountLabel.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
        accountLabel.font = [UIFont boldSystemFontOfSize:12.0];
        accountLabel.tag = ACCOUNT_LABEL_TAG;
        accountLabel.textAlignment = UITextAlignmentRight;
        accountLabel.backgroundColor = [UIColor clearColor];
        accountLabel.text = @"";
        accountLabel.frame = CGRectMake(170, cell.contentView.frame.origin.y + 43, 120, 16);
        [cell.contentView addSubview:accountLabel];
    }
}

+(void) createAmountLabel:(UITableViewCell *)cell 
             filteredData:(MOTransfer *) currentObject 
          isInEditingMode:(BOOL) isInEditingMode
            accordingDate:(NSDate*)date {
    UILabel* amountLabel = (UILabel *) [cell.contentView viewWithTag:AMOUNT_LABEL_TAG];
    if (!amountLabel) {
        amountLabel = [[[UILabel alloc] init] autorelease];
        amountLabel.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
        amountLabel.font = [UIFont boldSystemFontOfSize:12.0];
        amountLabel.tag = AMOUNT_LABEL_TAG;
        amountLabel.textAlignment = UITextAlignmentRight;
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.frame = CGRectMake(170, cell.contentView.frame.origin.y + 23, 120, 20);
        [cell.contentView addSubview:amountLabel];
    }
    if (!isInEditingMode) {
        amountLabel.hidden = NO;
    }
    
    MORecurrence* recurrence = [MyBudgetHelper recurrenceByDate:date transfer:currentObject withFormatter:DATE_FORMAT_MONTH];
    if(recurrence) {
        if ([currentObject isKindOfClass:[MOPayment class]]) {
            amountLabel.textColor = [MyBudgetHelper paymentColor];
        } else {
            amountLabel.textColor = [MyBudgetHelper incomeColor];
        }
        NSString* string = [NSString stringWithFormat:@"%.2f", [recurrence.amount doubleValue]];
        amountLabel.text = [string stringByAppendingString:[NSString stringWithFormat:@" %@", [MOUser instance].setting.currency]]; 
    }
}

+(void) createSubsubTitleLabel:(MOPayment *)currentObject cell:(UITableViewCell *)cell accordingDate:(NSDate*)date {
    UILabel* subsubTitleLabel = (UILabel *) [cell.contentView viewWithTag:NAME_LABEL_TAG];
    if (!  subsubTitleLabel) {
        subsubTitleLabel = [[[UILabel alloc] init] autorelease];
        subsubTitleLabel.textColor = [UIColor grayColor];
        subsubTitleLabel.font = [UIFont systemFontOfSize:12.0];
        subsubTitleLabel.tag = NAME_LABEL_TAG;
        subsubTitleLabel.textAlignment = UITextAlignmentLeft;
        subsubTitleLabel.backgroundColor = [UIColor clearColor];     

        subsubTitleLabel.frame = CGRectMake(60, cell.contentView.frame.origin.y + 43, 110, 16);
        [cell.contentView addSubview:  subsubTitleLabel];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT_STYLE];

    MORecurrence* recurrence = [MyBudgetHelper recurrenceByDate:date transfer:currentObject withFormatter:DATE_FORMAT_MONTH];
    if (recurrence) {
        NSString *string = [dateFormatter stringFromDate:recurrence.dateTime];
        subsubTitleLabel.text = string;
    }
    [dateFormatter release];
}

+(void) createAccountTypeLabel:(UITableViewCell *)cell filteredData:(MOAccount *)currentObject isInEditingMode:(BOOL) isInEditingMode {
    UILabel* accountTypeLabel = (UILabel *) [cell.contentView viewWithTag:AMOUNT_LABEL_TAG];
    if (!accountTypeLabel) {
        accountTypeLabel = [[[UILabel alloc] init] autorelease];
        accountTypeLabel.textColor = [NSKeyedUnarchiver unarchiveObjectWithData:[[MOUser instance].setting defaultColor]];
        accountTypeLabel.font = [UIFont boldSystemFontOfSize:12.0];
        accountTypeLabel.tag = AMOUNT_LABEL_TAG;
        accountTypeLabel.textAlignment = UITextAlignmentRight;
        accountTypeLabel.backgroundColor = [UIColor clearColor];
        accountTypeLabel.frame = CGRectMake(160, cell.contentView.frame.origin.y + 30, cell.contentView.frame.size.width - 190, 20);
        accountTypeLabel.hidden = YES;
        [cell.contentView addSubview:accountTypeLabel];
    }
    if (!isInEditingMode) {
        accountTypeLabel.hidden = NO;
    }
    accountTypeLabel.text = currentObject.type;
}

+(void) createLocationLabel:(MOPayment *)currentObject cell:(UITableViewCell *)cell {
    UILabel* locationLabel = (UILabel *) [cell.contentView viewWithTag:LOCATION_LABEL_TAG];
    if (!  locationLabel) {
        locationLabel = [[[UILabel alloc] init] autorelease];
        locationLabel.textColor = [UIColor redColor];
        locationLabel.font = [UIFont systemFontOfSize:12.0];
        locationLabel.tag = LOCATION_LABEL_TAG;
        locationLabel.textAlignment = UITextAlignmentLeft;
        locationLabel.backgroundColor = [UIColor clearColor];     
        
        locationLabel.frame = CGRectMake(60, cell.contentView.frame.origin.y + 58, cell.contentView.frame.size.width - 145, 20);
        [cell.contentView addSubview:  locationLabel];
    }
    locationLabel.text = [LocationInfo dataAddress:[currentObject location]];
}

+(void) addTitleAndSubtitleForIncome:(MOIncome *)currentObject cell:(UITableViewCell *)cell accordingDate:(NSDate*)date {
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:TITLE_LABEL_TAG];
    label.frame = CGRectMake(20, cell.contentView.frame.origin.y + 20, 145, 25);
    
    label.text = currentObject.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_STYLE];
    label = (UILabel*)[cell.contentView viewWithTag:SUBTITLE_LABEL_TAG];
    
    MORecurrence* recurrence = [MyBudgetHelper recurrenceByDate:date transfer:currentObject withFormatter:DATE_FORMAT_MONTH];
    if (recurrence) {
        NSString *string = [formatter stringFromDate:recurrence.dateTime];
        label.text = string;
        label.frame = CGRectMake(20, cell.contentView.frame.origin.y + 45, 140, 20);
    }
    [formatter release];
}


+(void) addTitleAndSubtitleForPayment:(MOPayment *) payment cell:(UITableViewCell *) cell {
    UIImage* image = [UIImage imageNamed:payment.category.categoryImageName];
    cell.imageView.image = image;
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:TITLE_LABEL_TAG];
    label.text = [NSString stringWithFormat:@"%@/%@", payment.category.parentCategory.name, payment.category.name];
    
    label = (UILabel*)[cell.contentView viewWithTag:SUBTITLE_LABEL_TAG];
    label.text = payment.name;
}

+(void) addTitleAndSubtitleForAccount:(MOAccount *) account cell:(UITableViewCell *) cell { 
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:TITLE_LABEL_TAG];
    label.frame = CGRectMake(20, cell.contentView.frame.origin.y + 20, 145, 25);
    label.text = account.name;
    
    label = (UILabel*)[cell.contentView viewWithTag:SUBTITLE_LABEL_TAG];
    label.text = [NSString stringWithFormat:NSLocalizedString(@"Total: %.2f %@", nil), [account.amount doubleValue], [[[MOUser instance] setting] currency]];
    
    label.frame = CGRectMake(20, cell.contentView.frame.origin.y + 45, 200, 20);
}

+(void) addStatusLabelText:(MOTransfer *) transfer cell:(UITableViewCell *) cell 
           isInEditingMode:(BOOL) isInEditingMode 
             selectedDate :(NSDate *) selectedDate {
    UILabel* label = (UILabel *)[cell.contentView viewWithTag:STATUS_LABEL_TAG];
    if (!isInEditingMode) {
        label.hidden = NO;
    }

    MORecurrence* recurrence = [MyBudgetHelper recurrenceByDate:selectedDate transfer:transfer withFormatter:DATE_FORMAT_MONTH];
    if (recurrence) {
        if (![recurrence.isDone boolValue]) {
            if ([transfer isKindOfClass:[MOIncome class]]) {
                label.text = NSLocalizedString(@"Not added", "Undone status");
            } else {
                label.text = NSLocalizedString(@"Unpaid", "Undone status");
            }
            [label setBackgroundColor:[UIColor redColor]];
        } else {
            if ([transfer isKindOfClass:[MOIncome class]]) {
                label.text = NSLocalizedString(@"Added", "Done status");
            } else {
                label.text = NSLocalizedString(@"Paid", "Done status");
            }
            [label setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
}

+(void) addAccountLabelText:(MOTransfer *) transfer cell:(UITableViewCell *) cell 
                   isInEditingMode:(BOOL) isInEditingMode {
    UILabel* label = (UILabel *)[cell.contentView viewWithTag:ACCOUNT_LABEL_TAG];
    label.text = transfer.account.name;
    if (!isInEditingMode) {
        label.hidden = NO;
    }
}

@end
