/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/29/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <UIKit/UIKit.h>

/// tag for view, that should be removed before updating
#define VIEW_COMMON_TAG       3000

@class Report;

/// Parent class for representation views
@interface RepresentationView : UIView {
    ///data source for  report view
    Report* report;
}

/// Updates view
-(void)updateView;

/// returns period months number
-(int)periodMonthNumber;

/**
 * @brief  Creates title
 * @param title - title
 */
-(void)createTitle:(NSString*)title;

/**
 * @brief  Draws label in specified position
 * @param ctx - graphics context
 * @param point - location
 * @param string - text
 */
-(void)drawPropertyByContext:(CGContextRef)ctx point:(CGPoint)point string:(NSString*)string;

/**
 * @brief  Draws legends in specified rectangle
 * @param rect - draw area
 * @param titleArray - legends title array
 */
-(void)drawLegends:(CGRect)rect titleArray:(NSArray*)titleArray;

@end
