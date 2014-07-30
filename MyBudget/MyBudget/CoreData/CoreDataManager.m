/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/26/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "CoreDataManager.h"
#import "MOUser.h"
#import "MOIncome.h"
#import "UserInfo.h"
#import "MOCategory.h"
#import "MOSearchSettings.h"
#import "MOPayment.h"
#import "ConfigManager.h"
#import "MOSetting.h"
#import "MOAccount.h"
#import "ReminderInfo.h"
#import "LocationInfo.h"
#import "MOReport.h"
#import "PieInfo.h"
#import "MORecurrence.h"
#import "Constants.h"

static CoreDataManager* coreDataManager = nil;

@implementation CoreDataManager

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

+(CoreDataManager*) instance {
	if(coreDataManager == nil){
		coreDataManager = [[CoreDataManager alloc] init];
	}
	return coreDataManager;
}

-(id)init {
    if ((self = [super init])) {
        rootCategories = [[NSArray alloc] initWithObjects:
                          NSLocalizedString(@"Home_Rent", nil),
                          NSLocalizedString(@"Utilities", nil),
                          NSLocalizedString(@"Food_Groceries", nil),
                          NSLocalizedString(@"Departmental", nil),
                          NSLocalizedString(@"Entertainment", nil),
                          NSLocalizedString(@"Car_Auto", nil),
                          NSLocalizedString(@"Insurance_Medical", nil),
                          NSLocalizedString(@"Misc_One-Time", nil), nil];
    }
    return self;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *objectContext = self.managedObjectContext;
    if (objectContext != nil)
    { 
        if ([objectContext hasChanges] && ![objectContext save:&error])
        {
            // add error handling here
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
            return NO;
        }
    }
    return YES;
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MyBudget.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // REMOVE APP FROM SIMULATOR :)
        abort();
    }
    
    return persistentStoreCoordinator;
}

#pragma mark - functions

-(BOOL)deleteData:(NSManagedObject*)data alsoFromPersitentStore:(BOOL)isFromPS{
    if (!data) {
        return NO;
    }
    [managedObjectContext deleteObject:data];
    
    if (isFromPS) {
        return [self saveContext];
    }
    return YES;
}

-(MOCategory*)userCategory:(NSDictionary*)subCategoriesDictionary categoryIndex:(int)categoryIndex type:(CategoryType)type {
    
    MOCategory* category = nil;
    
    category = [self category];
    
    for (NSString* key in subCategoriesDictionary) {
        
        NSMutableArray* subCategoriesArray = [[NSMutableArray alloc] init];
        
        NSArray* subCategoriesNameArray = [subCategoriesDictionary valueForKey:key];
        
        // Create sub categories array
        int count = [subCategoriesNameArray count];
        for (int i = 0; i < count; ++i) {
            MOCategory* subCategory = [self category];
            NSString* subCategoryName = (NSString*)[subCategoriesNameArray objectAtIndex:i];
            
            subCategory.categoryImageName = [[ROOT_CATEGORY_DIR stringByAppendingPathComponent:subCategoryName] stringByAppendingPathExtension:@"png"];
            
            subCategoryName = [subCategoryName stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
            subCategory.name = subCategoryName;
            subCategory.categoryIndex = [NSNumber numberWithInt:i];
            subCategory.parentCategory = category;

            [subCategoriesArray addObject:subCategory];
        }
        
        // Create category
        category.categoryImageName = [[ROOT_CATEGORY_DIR stringByAppendingPathComponent:key] stringByAppendingPathExtension:@"png"];
        
        key = [key stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
        category.name = key;
        category.parentCategory = nil;
        category.categoryIndex = [NSNumber numberWithInt:categoryIndex];
        category.subCategories = [NSSet setWithArray:subCategoriesArray];
        category.type = [NSNumber numberWithInt:type];
        [subCategoriesArray release];
        //break;
    }
    return category;
}

-(NSMutableSet*)userCategories {    
    NSMutableArray* categoriesArray = [[NSMutableArray alloc] init];
    
    NSArray* homeRentArray = [NSArray arrayWithObjects:
                              NSLocalizedString(@"Mortgage", nil),
                              NSLocalizedString(@"Rent", nil),
                              NSLocalizedString(@"Association fee", nil),
                              NSLocalizedString(@"Property tax", nil),
                              nil];   
    [categoriesArray addObject:[self userCategory:[NSDictionary dictionaryWithObject:homeRentArray forKey:[rootCategories objectAtIndex:0]] categoryIndex:1 type:kCategoryTypePayment]];
    
    NSArray* utilitiesArray = [NSArray arrayWithObjects:
                               NSLocalizedString(@"Electricity", nil),
                               NSLocalizedString(@"Gas_Heating", nil),
                               NSLocalizedString(@"Telephone", nil),
                               NSLocalizedString(@"CellPhone", nil),
                               NSLocalizedString(@"Internet", nil),
                               NSLocalizedString(@"Cable_Dish", nil),
                               NSLocalizedString(@"Water", nil),
                               NSLocalizedString(@"Garbage", nil),
                               nil];
    [categoriesArray addObject:[self userCategory:[NSDictionary dictionaryWithObject:utilitiesArray forKey:[rootCategories objectAtIndex:1]] categoryIndex:2 type:kCategoryTypePayment]];
    
    NSArray* foodGroceriesArray = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"Groceries", nil),
                                   NSLocalizedString(@"Restaurant_Fast food", nil),
                                   nil];
    [categoriesArray addObject:[self userCategory:[NSDictionary dictionaryWithObject:foodGroceriesArray forKey:[rootCategories objectAtIndex:2]] categoryIndex:3 type:kCategoryTypeCommon]];
    
    NSArray* departmentalArray = [NSArray arrayWithObjects:
                                  NSLocalizedString(@"Clothing", nil),
                                  NSLocalizedString(@"Personal items", nil),
                                  NSLocalizedString(@"Kids_Toys", nil),
                                  NSLocalizedString(@"Books_Magazines", nil),
                                  nil];
    [categoriesArray addObject:[self userCategory:[NSDictionary dictionaryWithObject:departmentalArray forKey:[rootCategories objectAtIndex:3]] categoryIndex:4 type:kCategoryTypeCommon]];
    
    NSArray* entertainmentArray = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"Movies", nil),
                                   NSLocalizedString(@"DVD rental", nil),
                                   NSLocalizedString(@"Music", nil),
                                   nil];
    [categoriesArray addObject:[self userCategory:[NSDictionary dictionaryWithObject:entertainmentArray forKey:[rootCategories objectAtIndex:4]] categoryIndex:5 type:kCategoryTypeCommon]];
    
    NSArray* carAutoArray = [NSArray arrayWithObjects:
                             NSLocalizedString(@"Gasoline", nil),
                             NSLocalizedString(@"Auto Loan", nil),
                             NSLocalizedString(@"Oil Change", nil),
                             nil];
    [categoriesArray addObject:[self userCategory:[NSDictionary dictionaryWithObject:carAutoArray forKey:[rootCategories objectAtIndex:5]] categoryIndex:6 type:kCategoryTypePayment]];
    
    NSArray* insuranceMedicalArray = [NSArray arrayWithObjects:
                                      NSLocalizedString(@"Insurance - Auto", nil),
                                      NSLocalizedString(@"Insurance - Home", nil),
                                      NSLocalizedString(@"Insurance - Medical", nil),
                                      NSLocalizedString(@"Medical Payments_Co-pay", nil),
                                      nil];
    [categoriesArray addObject:[self userCategory:[NSDictionary dictionaryWithObject:insuranceMedicalArray forKey:[rootCategories objectAtIndex:6]] categoryIndex:7 type:kCategoryTypePayment]];
    
    NSArray* miscOneTimeArray = [NSArray arrayWithObjects:
                                 NSLocalizedString(@"Air tickets", nil),
                                 NSLocalizedString(@"Hotel_Lodging", nil),
                                 NSLocalizedString(@"Gifts_Charity", nil),
                                 nil];
    [categoriesArray addObject:[self userCategory:[NSDictionary dictionaryWithObject:miscOneTimeArray forKey:[rootCategories objectAtIndex:7]] categoryIndex:8 type:kCategoryTypeCommon]];

    
    NSMutableSet* userCategories = [NSSet setWithArray:categoriesArray];
    [categoriesArray release];
    
    return userCategories;
}

-(MOUser*)user {
    MOUser* user = (MOUser*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_USER inManagedObjectContext:self.managedObjectContext];
    
    return user;
}

-(MOIncome*)income {
    MOIncome* income = (MOIncome*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_INCOME inManagedObjectContext:self.managedObjectContext];
    
    return income;
}

-(MOCategory*)category {
    MOCategory* category = (MOCategory*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_CATEGORY inManagedObjectContext:self.managedObjectContext];
    category.type = kCategoryTypeCommon;
    
    return category;
}

-(MOPayment*)payment {
    MOPayment* payment = (MOPayment*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_BILL inManagedObjectContext:self.managedObjectContext];
    
    return payment;
}

-(MOAccount*)account {
    MOAccount* account = (MOAccount*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_ACCOUNT inManagedObjectContext:self.managedObjectContext];
    
    return account;
}

-(MOReport*)report {
    MOReport* report = (MOReport*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_REPORT inManagedObjectContext:self.managedObjectContext];
    //report.period = [NSNumber numberWithInt:3];
    report.representation = [NSNumber numberWithInt:3]; // Graphic view
    report.endDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*15];
    report.startDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*(-15)];
    return report;
}

-(MOSetting*)setting {
    MOSetting* setting = (MOSetting*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_SETTING inManagedObjectContext:self.managedObjectContext];
    
    // current currency
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString *code = [theLocale objectForKey:NSLocaleCurrencyCode];
    
    setting.currency = code;
    setting.startScreen = NSLocalizedString(@"Home", nil);
    setting.monthStartDate = @"1";
    setting.deleteAfterMonths = @"24";    
    setting.report = [self report];
    
    setting.defaultColor = [NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:189.0/255.0 green:19.0/255.0 blue:45.0/255.0 alpha:1.0]];
    
    return setting;
}

-(MOSearchSettings*) searchSettings {
    MOSearchSettings* setting = (MOSearchSettings*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_SEARCH_SETTINGS inManagedObjectContext:self.managedObjectContext]; 
    
    setting.searchInIncomeAccount = [NSNumber numberWithBool:YES];
    setting.searchInIncomeAmount = [NSNumber numberWithBool:YES];
    setting.searchInIncomeName = [NSNumber numberWithBool:YES];
    
    setting.searchInPaymentName = [NSNumber numberWithBool:YES];
    setting.searchInPaymentLocation = [NSNumber numberWithBool:YES];
    setting.searchInPaymentCategory = [NSNumber numberWithBool:YES];
    setting.searchInPaymentAmount = [NSNumber numberWithBool:YES];
    setting.searchInPaymentAccount = [NSNumber numberWithBool:YES];
    
    setting.searchInAccountAmount = [NSNumber numberWithBool:YES];
    setting.searchInAccountName = [NSNumber numberWithBool:YES];
    setting.searchInAccountType = [NSNumber numberWithBool:YES];
    setting.endDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*15];
    setting.startDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*(-15)];
    return setting;
}

-(MORecurrence*)recurring {
    MORecurrence* recurring = (MORecurrence*)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_RECURRING inManagedObjectContext:self.managedObjectContext];
    
    return recurring;
}

-(BOOL)saveUserData:(UserInfo*)userInfo {
    
    MOUser* user = [self userByNickname:userInfo.nickname andPassword:userInfo.password];
    if (!user) {
        user = [self user];
        user.categories = [self userCategories];
    }
    user.nickname = userInfo.nickname;
    user.password = userInfo.password;
    user.firstName = userInfo.firstName;
    user.lastName = userInfo.lastName;
    user.accountNumber = userInfo.accountNumber;
    user.eMail = userInfo.eMail;
    user.phoneNumber = userInfo.phoneNumber;
    
    MOSetting* setting = [self setting];
    user.setting = setting;
        
    BOOL isDone = [self saveContext];
    if (isDone) {
        [MOUser setInstance:user];
    }
        
    return isDone;
}

-(MOUser*)userByNickname:(NSString*)nickname andPassword:(NSString*)password {
    // create fetch object, this object fetch's the objects out of the database
    if (nickname && password) {
        NSError* error;
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:ENTITY_USER inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nickname like %@ AND password like %@", nickname, password];
        [fetchRequest setPredicate:predicate];
        
        NSArray* fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        [fetchRequest release];
        
        if ([fetchedObjects count] > 0) {
            return [fetchedObjects objectAtIndex:0];
        }
    }    
    return nil;
}

-(BOOL)existRegisteredUsers {
    NSError* error;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:ENTITY_USER inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray* fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    if ([fetchedObjects count] == 0) {    
        return NO;
    }
    return YES;
}

-(MOCategory*)categoryByName:(NSString*)categoryName fromSet:(NSSet*)categorySet {    
    for (MOCategory* category in categorySet) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", categoryName];
        
        NSArray* fetchedObjects = [[category.subCategories filteredSetUsingPredicate:predicate] allObjects];
        
        if ([fetchedObjects count] > 0) {
            return [fetchedObjects objectAtIndex:0];
        }
    }
    
    return nil;
}

+(NSArray*)imageNameArray {
    NSString* path = [[ NSBundle mainBundle] resourcePath];
    path = [path stringByAppendingPathComponent:@"CategoryImages"];
    NSArray* imageNameArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    return imageNameArray;
}

+(NSArray*)sortSet:(NSSet*)nsSet byProperty:(NSString*)propertyName ascending:(BOOL)ascending {
    
    NSSortDescriptor* descriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:ascending];
    
    NSArray* descriptors = [NSArray arrayWithObjects:descriptor, nil];
    
    NSArray* sortedArray = [nsSet sortedArrayUsingDescriptors:descriptors];
    
    [descriptor release];
    
    return sortedArray;
}

-(BOOL)deleteOldData {
    if (![[MOUser instance].setting.deleteAfterMonths isEqualToString:@""]) {
        int fullMonths = [[MOUser instance].setting.deleteAfterMonths intValue];
        int afterYears = fullMonths / 12;
        int afterMonths = fullMonths - afterYears * 12;
        
        // Delete old Incomes
        NSArray* fetchedObjects = [[MOUser instance].incomes allObjects];    
        if ([fetchedObjects count] > 0) {
            for (MOIncome* income in fetchedObjects) {
                NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
                
                for (MORecurrence* recurrence in income.recurrings) {
                    NSDateComponents *components = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:recurrence.dateTime toDate:[NSDate date] options:0];

                    NSInteger month = [components month];
                    NSInteger year = [components year];
                    if (year > afterYears || (year == afterYears && month >= afterMonths)) {
                        if (![[CoreDataManager instance] deleteData:recurrence alsoFromPersitentStore:YES]) {
                            return FALSE;
                        }
                    }
                }
            }        
        }
        
        // Delete old Payments
        fetchedObjects = [[MOUser instance].payments allObjects];    
        if ([fetchedObjects count] > 0) {
            for (MOPayment* payment in fetchedObjects) {
                NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
                
                for (MORecurrence* recurrence in payment.recurrings) {
                    NSDateComponents *components = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:recurrence.dateTime toDate:[NSDate date] options:0];
                    
                    NSInteger month = [components month];
                    NSInteger year = [components year];
                    if (year > afterYears || (year == afterYears && month >= afterMonths)) {
                        if (![[CoreDataManager instance] deleteData:recurrence alsoFromPersitentStore:YES]) {
                            return FALSE;
                        }
                    }
                }
            }        
        }
    }
    
    return TRUE;
}

+(NSSet*)filteredRecurrings:(NSSet*)set fromStartDate:(NSDate*)startDate toEndDate:(NSDate*)endDate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(dateTime >= %@) AND (dateTime < %@) AND (isDone == YES)", startDate, endDate];
    NSSet* subSet = [set filteredSetUsingPredicate:predicate];
    return subSet;
}

+(NSNumber*)sumAmountOfRecurrings:(NSSet*)set fromStartDate:(NSDate*)startDate toEndDate:(NSDate*)endDate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(dateTime >= %@) AND (dateTime < %@) AND (isDone == YES)", startDate, endDate];
    
    NSSet* subSet = [set filteredSetUsingPredicate:predicate];
    NSNumber* amount = [subSet valueForKeyPath:@"@sum.amount"];
    return amount;
}

-(BOOL)isNicknameBusy:(NSString *)nickname {
    NSError* error;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:ENTITY_USER inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nickname like %@", nickname];
    [fetchRequest setPredicate:predicate];
    
    NSArray* fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    if ([fetchedObjects count] > 0) {
        return YES;
    }
    return NO;
}

+(NSArray*)arrayWithDoneStatus:(NSArray*)array {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDone == YES"];
    NSArray* subArray = [array filteredArrayUsingPredicate:predicate];
    return subArray;
}

+(NSNumber*)sumAmountOfDoneSet:(NSSet*)set {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDone == YES"];
    NSSet* subSet = [set filteredSetUsingPredicate:predicate];
    NSNumber* amount = [subSet valueForKeyPath:@"@sum.amount"];
    return amount;
}

+(NSSet*)subSetOf:(NSSet*)set filteredByName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSSet* subSet = [set filteredSetUsingPredicate:predicate];
    return subSet;
}

+(NSSet*)subSetOf:(NSSet*)set filteredByAccount:(MOAccount*)account {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"account.name like %@", account.name];
    NSSet* subSet = [set filteredSetUsingPredicate:predicate];
    return subSet;
}

+(NSSet*)subSetOf:(NSSet*)set filteredByCategory:(MOCategory*)category {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category.name like %@", category.name];
    NSSet* subSet = [set filteredSetUsingPredicate:predicate];
    return subSet;
}

-(BOOL)isInSet:(NSSet*)set nameBusy:(NSString*)name {
    if ([[CoreDataManager subSetOf:set filteredByName:name] count] > 0) {
        return YES;
    }
    return NO;
}

-(BOOL)isCategoryUsed:(MOCategory*)category {
    NSSet* payments = [MOUser instance].payments;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(category.name like %@)", category.name];
    NSSet* subSet = [payments filteredSetUsingPredicate:predicate];
    if ([subSet count] > 0) {
        return YES;
    }
    return NO;
}

-(NSArray*)piesForReportFromStartMonth:(NSDate*)startMonth toEndMonth:(NSDate*)endMonth {
    
    // Get user's categories' parent category names
    NSMutableSet* parentCategoriesSet = [[NSMutableSet alloc] init];
    
    // Payments
    NSMutableArray* filteredPayments = [[[NSMutableArray alloc] init] autorelease];
    for (MOPayment* payment in [MOUser instance].payments) {
        NSSet* temp = [CoreDataManager filteredRecurrings:payment.recurrings fromStartDate:startMonth toEndDate:endMonth];
        if ([temp count] > 0) {
            NSString* parentCategoryName = payment.category.parentCategory.name;
            [parentCategoriesSet addObject:parentCategoryName];
            [filteredPayments addObject:payment];
        }
    }
    
    NSArray* parentCategoriesArray = [parentCategoriesSet allObjects];
    [parentCategoriesSet release];
    
    NSMutableArray* pieArray = [[NSMutableArray alloc] init];
    for (NSString* categoryName in parentCategoriesArray) {
        // Create predicate
        NSString* categoryRealName = [categoryName stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category.parentCategory.name like %@", categoryRealName];
                
        // Get payment's recurrances filtered by category and get sum amount
        NSSet* paymentsSet = [[NSSet alloc] initWithArray:filteredPayments];
        NSSet* payments = [paymentsSet filteredSetUsingPredicate:predicate];
        [paymentsSet release];
        
        NSMutableArray* allRecurrences = [[NSMutableArray alloc] init];
        for (MOPayment* payment in payments) {
            NSSet* recurrences = [CoreDataManager filteredRecurrings:payment.recurrings fromStartDate:startMonth toEndDate:endMonth];
            [allRecurrences addObjectsFromArray:[recurrences allObjects]];
        }
        NSNumber* sumPaymentRecurrences = [allRecurrences valueForKeyPath:@"@sum.amount"];
        [allRecurrences release];
        
        if ([payments count] > 0) {
            // Create PieInfo and add to array
            PieInfo* pieInfo = [[PieInfo alloc] init];
            pieInfo.categoryName = categoryRealName;
            pieInfo.payments = [NSNumber numberWithFloat:([sumPaymentRecurrences floatValue] * (-1))];
            [pieArray addObject:pieInfo];
            [pieInfo release];
        }
    }
    
    return [pieArray autorelease];
}

-(BOOL)isAccountUsed:(MOAccount*)account {    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"account.name like %@", account.name];
    NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setPredicate:predicate];
    
    // payments
    NSEntityDescription* entity = [NSEntityDescription entityForName:ENTITY_BILL inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray* fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count] > 0) {
        return YES;
    }
    
    // incomes
    entity = [NSEntityDescription entityForName:ENTITY_INCOME inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count] > 0) {
        return YES;
    }
    
    return NO;
}

-(void)dealloc {
    [rootCategories release];
    [super dealloc];
}

@end
