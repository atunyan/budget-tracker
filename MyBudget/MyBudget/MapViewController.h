/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 12.01.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class AddressAnnotation;
@class LocationInfo;

/// delegate  for location functionalities
@protocol LocationControllerDelegate <NSObject>

@optional
/**
 * @brief  transfers location info on click
 * @param info - location info
 */
-(void) didSelectLocation:(LocationInfo*)info;

@end


/**
 * @brief The viewController is responsible for opening the map, choosing and
 * storing the current and the other locations also.
 */
@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    /// The mapView to be opened in the current view controller.
    MKMapView* mapView;
    
    /// CLLocationManager class handles sending out updates to a delegate anytime the location is changed
    CLLocationManager *locationManager;
    
    /// current location info object
    LocationInfo* locationInfo;
    
    /// annotation object, for showing position ball, title and subtitle
    AddressAnnotation *addAnnotation;
    
    id<LocationControllerDelegate> delegate;
    
    BOOL isTapAllowed;
}

/// The delegate of @ref LocationControllerDelegate protocol
@property (nonatomic, assign) id<LocationControllerDelegate> delegate;

/// indicates is user can tap on map
@property (nonatomic, assign) BOOL isTapAllowed;

/**
 * @brief  Creates object with specified location info
 * @param info - location info
 * @return - initialized object
 */
-(id)initWithLocationInfo:(LocationInfo*)info;

@end
