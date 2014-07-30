/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/15/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class LocationInfo;

/// The class for showing the annotation on the location.
@interface AddressAnnotation : NSObject <MKAnnotation> {
    /// annotation coordinate
	CLLocationCoordinate2D coordinate;
	
    /// annotation title
	NSString *mTitle;
    
    /// annotation subtitle
	NSString *mSubTitle;
}

/**
 * @brief creates annotation object with specified info
 * @param info - location info
 * @return - initialized object
 */
-(id)initWithLocationInfo:(LocationInfo*)info;

@end

