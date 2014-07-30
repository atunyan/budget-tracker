/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "CategoriesListViewController.h"
#import "CategoryViewCell.h"
#import "Constants.h"
#import "MOCategory.h"
#import "MOUser.h"
#import "CoreDataManager.h"

@implementation CategoriesListViewController

@synthesize categories;
@synthesize delegate;
@synthesize currentCategory;

- (id)initWithStyle:(UITableViewStyle)style withCategory:(MOCategory*)category withClickedCategory:(MOCategory*)justClickedCategory
{
    self = [super initWithStyle:style];
    if (self) {
        currentCategory = [category retain];
        clickedCategory = [justClickedCategory retain];
        
        if (!clickedCategory) {
            isRootCategoriesList = YES;
        } else {
            if (clickedCategory.parentCategory) {
                isRootCategoriesList = YES;
            } else {
                isRootCategoriesList = NO;
            }
        }
        NSSet* nsSet = nil;
        if (isRootCategoriesList) {
            nsSet = [MOUser instance].categories;
        } else {
            nsSet = clickedCategory.subCategories;
        }
        categories = [[NSMutableArray alloc] initWithArray:[CoreDataManager sortSet:nsSet byProperty:SORT_BY_CATEGORY_INDEX ascending:YES]];
        self.tableView.allowsSelectionDuringEditing = YES;
        needToPop = NO;
        
        deletingIndexPath = nil;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Edit", nil);
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
    if(needToPop){
        if([delegate respondsToSelector:@selector(didSelectCategory:)]) {
            [delegate didSelectCategory:currentCategory];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.editing == NO){
        return [categories count];
    } 
    return [categories count] +1;
    // Return the number of rows in the section.
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CategoryViewCell *cell = (CategoryViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CategoryViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] autorelease];
    }
    MOCategory*  cat = (indexPath.row < [categories count]) ?[categories objectAtIndex:indexPath.row]:nil;
    [cell setData:cat];
    if ([categories count] == 0) {
        [tableView setEditing:YES];
    } else {
        if (isRootCategoriesList) {
            NSLog(@"%@, %@", cat.name, currentCategory.parentCategory.name);
            if ([cat.name isEqualToString:currentCategory.parentCategory.name]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            NSLog(@"%@, %@", cat.name, currentCategory.name);
            if ([cat.name isEqualToString:currentCategory.name]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
     return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        if (indexPath.row < [categories count]) {
            return UITableViewCellEditingStyleDelete;
        } else {
            return UITableViewCellEditingStyleInsert;
        }
    }
    return UITableViewCellEditingStyleNone;
}


-(void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deletingIndexPath = [[NSIndexPath alloc] init];
        deletingIndexPath = [indexPath retain];
        MOCategory* deletingCategory = [categories objectAtIndex:indexPath.row];
        if ([deletingCategory.subCategories count] > 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil) 
                                                                message:NSLocalizedString(@"The subcategories will also be removed. Do you really want it?", nil) 
                                                               delegate:self 
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
                                                      otherButtonTitles:NSLocalizedString(@"Delete", nil), nil];
            [alertView show];
            [alertView release];
            return;
        }
        if ([[CoreDataManager instance] isCategoryUsed:deletingCategory] || [currentCategory.name isEqualToString:deletingCategory.name]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete not allowed", nil) 
                                                                message:NSLocalizedString(@"The category is used and you can not delete it.", nil) 
                                                               delegate:nil 
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            return;
        }
        
        // Delete the row from the data source
        [categories removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (isRootCategoriesList) {
            [MOUser instance].categories = [NSSet setWithArray:categories];
        } else {
            clickedCategory.subCategories = [NSSet setWithArray:categories];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    } 
//    [tableView reloadData];
    
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    MOCategory* category = [[self.categories objectAtIndex:fromIndexPath.row] retain];
    [self.categories removeObjectAtIndex:fromIndexPath.row];
    [self.categories insertObject:category atIndex:toIndexPath.row];
    [category release];
    int count = [categories count];
    for (int i = 0; i < count; ++i) {
        ((MOCategory*)[categories objectAtIndex:i]).categoryIndex = [NSNumber numberWithInt:i];
    }
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    if (indexPath.row < [categories count]) {
        return YES;
    } else {
        return NO;
    }

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    [self.tableView reloadData];
    if(editing) {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Done", nil);
        NSLog(@"editMode on");
    } else {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Edit", nil);
        [[CoreDataManager instance] saveContext];
        
        if (deletingIndexPath) {
            [deletingIndexPath release];
            deletingIndexPath = nil;
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [categories count]) {
        CategoryViewController*  vc = [[CategoryViewController alloc] initWithParentCategory:clickedCategory];
        vc.title = NSLocalizedString(@"New category", nil);
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    if (tableView.editing == NO) {
        if (isRootCategoriesList) {
            CategoriesListViewController* categoryViewController =  [[CategoriesListViewController alloc] initWithStyle:UITableViewStylePlain withCategory:currentCategory withClickedCategory:(MOCategory*)[categories objectAtIndex:indexPath.row]];
            categoryViewController.title = NSLocalizedString(@"Categories", nil);
            categoryViewController.delegate =  self;
            MOCategory* cat =[categories objectAtIndex:indexPath.row];
            if(![cat.subCategories count]) {
                [categoryViewController setEditing:YES];
            }
            [self.navigationController pushViewController:categoryViewController animated:YES];
            [categoryViewController release];
        } else {
            if([delegate respondsToSelector:@selector(didSelectCategory:)]){
                [self.navigationController popViewControllerAnimated:YES];
                [delegate didSelectCategory:[categories objectAtIndex:indexPath.row]];
            }
        }
    }
}

-(void) didSelectCategory:(MOCategory*) category {
    needToPop = YES;
    self.currentCategory = category;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        for (MOCategory* obj in [((MOCategory*)[categories objectAtIndex:deletingIndexPath.row]).subCategories allObjects]) {
            if ([[CoreDataManager instance] isCategoryUsed:obj] || [currentCategory.name isEqualToString:obj.name]) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete not allowed", nil) 
                                                                    message:NSLocalizedString(@"The category is used and you can not delete it", nil) 
                                                                   delegate:nil 
                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                          otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
        }
        for (MOCategory* obj in [((MOCategory*)[categories objectAtIndex:deletingIndexPath.row]).subCategories allObjects]) {
            [[CoreDataManager instance] deleteData:obj alsoFromPersitentStore:YES];
        }
        
        [[CoreDataManager instance] deleteData:[categories objectAtIndex:deletingIndexPath.row] alsoFromPersitentStore:YES];
        [categories removeObjectAtIndex:deletingIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deletingIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (isRootCategoriesList) {
            [MOUser instance].categories = [NSSet setWithArray:categories];
        } else {
            clickedCategory.subCategories = [NSSet setWithArray:categories];
        }
    }
}

-(void) dealloc {
    [categories release];
    [currentCategory release];
    [deletingIndexPath release];
    [super dealloc];
}

-(void) addNewCategory:(MOCategory *)category {
    category.categoryIndex = [NSNumber numberWithInt:[categories count] + 1];
    [categories addObject:category];
    [self.tableView reloadData];    
}



@end
