/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/12/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "RepresentationView.h"

///class  for  view reports
@interface ReportView : RepresentationView {
    
    ///the coordinates  center
    CGPoint zeroPoint;

    ///factor for shows correct value in the graphic
    float factor;

    ///correct  point  for drawing  x-axis  labels
    NSMutableArray*  pointArray;
    
    /// values  for y-axis    
    NSMutableArray*  yAxisValueArray;
    
    ///tags  for x-axis  labels    
    NSMutableArray*  tagsArray;
    
    /// starting  point label tag
    int labelTag;

    /// legends title array
    NSArray* legendsTitleArray;
}

@end
