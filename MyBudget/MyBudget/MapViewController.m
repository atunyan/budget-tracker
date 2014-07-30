/**
 *  @file 
 *  MyBudget
 *
 *  Created by Arevik Tunyan on 12.01.12.
 *  &copy; 2012 MyBudget. All rights reserved.
 *
 */

#import "MapViewController.h"
#import "AddressAnnotation.h"
#import "LocationInfo.h"

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>


@implementation MapViewController

@synthesize delegate;
@synthesize isTapAllowed;

-(id)initWithLocationInfo:(LocationInfo*)info {
    self = [super init];
    if (self) {
        locationInfo = [info retain];
        isTapAllowed = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)showLocationByCoordinate:(BOOL)isResetScale {
    if (isResetScale) {
        MKCoordinateRegion region;
        MKCoordinateSpan span; 
        double delta = 0.01; // Change these values to change the zoom
        span.latitudeDelta  = delta;
        span.longitudeDelta = delta;
        region.span = span;
        region.center = locationInfo.coordinate;
        [mapView setRegion:region animated:YES];
        [mapView regionThatFits:region];
    }
    
    if(addAnnotation != nil) {
		[mapView removeAnnotation:addAnnotation];
		[addAnnotation release];
		addAnnotation = nil;
	}
    
    addAnnotation = [[AddressAnnotation alloc] initWithLocationInfo:locationInfo];
	[mapView addAnnotation:addAnnotation];
}

-(void)showExistingLocation {
    [self showLocationByCoordinate:YES];
}

-(void)showUserCurrentLocation {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
}

#pragma mark - Map taping handlers

- (void)handleLongPressAndPinchGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    [mapView selectAnnotation:addAnnotation animated:YES];
}

- (void)handlePanGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
}

-(void)createLocationInfo:(CLLocation *)newLocation andIsResetScale:(BOOL)isResetScale {
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            // DON'T remove comments
            //            NSString* city = placemark.locality;
            //            NSString* street = placemark.thoroughfare;
            //            NSString* corporation = placemark.name;
            
            if (locationInfo) {
                [locationInfo release];
                locationInfo = nil;
            }
            
            locationInfo = [[LocationInfo alloc] init];
            locationInfo.coordinate = coordinate;
            locationInfo.title = placemark.locality ? placemark.locality : @"";
            NSString* subtitle = @"";
            if (placemark.thoroughfare) {
                subtitle = placemark.thoroughfare;
            }
            if (placemark.name && ![placemark.name isEqualToString:placemark.thoroughfare]) {
                [subtitle stringByAppendingString:placemark.name];
            }
            locationInfo.subtitle = subtitle;
            
            [self showLocationByCoordinate:isResetScale];
            
            //            NSLog(@"%@", placemark);
            //            NSLog(@"%@", placemark.locality);
            //            NSLog(@"%@", placemark.name);
            //            NSLog(@"%@", placemark.addressDictionary);
            //            NSLog(@"%@", placemark.thoroughfare);
            //            NSLog(@"%@", placemark.subThoroughfare);
            //            NSLog(@"%@", placemark.subLocality);
            //            NSLog(@"%@", placemark.administrativeArea);
            //            NSLog(@"%@", placemark.subAdministrativeArea);
            //            NSLog(@"%@", placemark.postalCode);
            //            NSLog(@"%@", placemark.ISOcountryCode);
            //            NSLog(@"%@", placemark.country);
            //            NSLog(@"%@", placemark.inlandWater);
            //            NSLog(@"%@", placemark.ocean);
            //            NSLog(@"%@", placemark.areasOfInterest);
            break;
        }    
    }];
    [geoCoder release];
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    if (isTapAllowed) {
        CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
        CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
        
        CLLocation* newLocation = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
        [self createLocationInfo:newLocation andIsResetScale:NO];
        [newLocation release];
    }
}

-(void)createMapViewTapHandlers {
    // for changing annotation view position
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];   
    tgr.numberOfTapsRequired = 1;
    tgr.numberOfTouchesRequired = 1;
    [mapView addGestureRecognizer:tgr];
    [tgr release];
    
    // Add gesture recognizer for map hoding
    UILongPressGestureRecognizer *longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressAndPinchGesture:)] autorelease];
    longPressGesture.minimumPressDuration = 3;  // In order to detect the map touching directly (Default was 0.5)
    [mapView addGestureRecognizer:longPressGesture];
    
    // Add gesture recognizer for map pinching
    UIPinchGestureRecognizer *pinchGesture = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressAndPinchGesture:)] autorelease];
    [mapView addGestureRecognizer:pinchGesture];
    
    // Add gesture recognizer for map dragging
    UIPanGestureRecognizer *panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] autorelease];
    panGesture.maximumNumberOfTouches = 1;  // In order to discard dragging when pinching
    [mapView addGestureRecognizer:panGesture];
} 

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.view.backgroundColor = [UIColor whiteColor];
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    [self createMapViewTapHandlers]; 
    
    if (locationInfo) {
        [self showExistingLocation];
    } else {
        [self showUserCurrentLocation];
    }

    UIBarButtonItem *saveLocationBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleDone target:self action:@selector(saveCurrentLocation)];
    self.navigationItem.rightBarButtonItem = saveLocationBtn;
    [saveLocationBtn release];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];    
    [self createLocationInfo:newLocation andIsResetScale:YES];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.pinColor = MKPinAnnotationColorGreen;
    annView.animatesDrop = TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    return [annView autorelease];
}

-(void)saveCurrentLocation {
    if ([delegate respondsToSelector:@selector(didSelectLocation:)]) {
        [delegate didSelectLocation:locationInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc {
    [mapView release];
    [locationInfo release];
    [addAnnotation release];
    [super  dealloc];
}

@end

