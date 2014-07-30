/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 1/26/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOCategory, MOUser;

/**
 * @brief The class keeps the properties of Core Data Category, which are describing category, such as category's index, name.
 */
@interface MOCategory : NSManagedObject

/// Category index
@property (nonatomic, retain) NSNumber * categoryIndex;

/// Category name
@property (nonatomic, retain) NSString * name;

/// Category type (Common, for Payments or other)
@property (nonatomic, retain) NSNumber * type;

/// Category subCategories
@property (nonatomic, retain) NSSet *subCategories;

/// Category image
@property (nonatomic, retain) NSString* categoryImageName;

/// Category User
@property (nonatomic, retain) MOUser *user;

/// the parent category
@property (nonatomic, retain) MOCategory *parentCategory;

@end

//@interface Category (CoreDataGeneratedAccessors)
//- (void)addCategoryCategoryObject:(Category *)value;
//- (void)removeCategoryCategoryObject:(Category *)value;
//- (void)addCategoryCategory:(NSSet *)values;
//- (void)removeCategoryCategory:(NSSet *)values;
//@end
