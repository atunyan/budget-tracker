/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/15/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/// Used for locationing
@interface LocationInfo : NSObject <NSCoding> {
    CLLocationCoordinate2D coordinate;
    
    NSString* title;
    
    NSString* subtitle;
}

/// location coordinate
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/// location title
@property (nonatomic, retain) NSString* title;

/// location subtitle
@property (nonatomic, retain) NSString* subtitle;

/**
 * @brief  convert data to location info
 * @param data - data, from which should be converted info
 * @return - converted data
 */
+(LocationInfo*)locationInfoFromData:(NSData*)data;

/**
 * @brief  convert info to data
 * @param locationInfo - info, from which should be converted data
 * @return - converted info
 */
+(NSData*)dataFromLocationInfo:(LocationInfo*)locationInfo;

/**
 * @brief  get data's address
 * @param data - data, from which should be received address
 * @return - data address
 */
+(NSString*)dataAddress:(NSData*)data;

/// returns location address
-(NSString*)address;

@end
