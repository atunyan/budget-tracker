/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/15/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "AddressAnnotation.h"
#import "LocationInfo.h"

@implementation AddressAnnotation

@synthesize coordinate;

- (NSString *)subtitle {
    return mSubTitle;
}
- (NSString *)title{
    return ![mTitle isEqualToString:@""] ? mTitle : NSLocalizedString(@"Unknown", nil);
}

-(id)initWithLocationInfo:(LocationInfo*)info {
    mTitle = [info.title copy];
    mSubTitle = [info.subtitle copy];
    coordinate = info.coordinate;
	return self;
}

-(void)dealloc {
    [mTitle release];
    [mSubTitle release];
    [super dealloc];
}

@end
