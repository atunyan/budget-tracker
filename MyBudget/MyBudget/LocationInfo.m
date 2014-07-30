/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/15/12.  
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "LocationInfo.h"

/// key for coordinate latitude
#define KEY_LATITUDE    @"Latitude"

/// key for coordinate longitude
#define KEY_LONGITUDE   @"Longitude"

/// key for location title
#define KEY_TITLE       @"Title"

/// key for location subtitle
#define KEY_SUBTITLE    @"Subtitle"

/// key for coding/decoding data
#define KEY_CODING      @"LocationInfo"

@implementation LocationInfo

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

+(LocationInfo*)locationInfoFromData:(NSData*)data {
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    LocationInfo* locationInfo = [unarchiver decodeObjectForKey:KEY_CODING];
    [unarchiver finishDecoding];
    [unarchiver release];
    return locationInfo;
}

+(NSData*)dataFromLocationInfo:(LocationInfo*)locationInfo {  
    NSMutableData* data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver* archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:locationInfo forKey:KEY_CODING];
    [archiver finishEncoding];
    
    return [data autorelease];
}

+(NSString*)dataAddress:(NSData*)data {
    LocationInfo* locationInfo = [LocationInfo locationInfoFromData:data];
    NSString* address = [locationInfo address];
    return address;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:coordinate.latitude forKey:KEY_LATITUDE];
    [aCoder encodeDouble:coordinate.longitude forKey:KEY_LONGITUDE];
    [aCoder encodeObject:title forKey:KEY_TITLE];
    [aCoder encodeObject:subtitle forKey:KEY_SUBTITLE];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        coordinate.latitude = [aDecoder decodeDoubleForKey:KEY_LATITUDE];
        coordinate.longitude = [aDecoder decodeDoubleForKey:KEY_LONGITUDE];
        self.title = [aDecoder decodeObjectForKey:KEY_TITLE];
        self.subtitle = [aDecoder decodeObjectForKey:KEY_SUBTITLE];
    }
    return self;
}

-(NSString*)address {
    NSString* address = [NSString stringWithFormat:@"%@, %@", title, subtitle];
    return address;
}

@end
