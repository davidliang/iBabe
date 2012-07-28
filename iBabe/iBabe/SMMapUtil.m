//
//  SMMapUtil.m
//  iBabe
//
//  Created by David Liang on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SMMapUtil.h"

@implementation SMMapUtil




// ---- Convert address location to LocationCoordinate.
+(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr {
    NSString *urlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
                        [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSError* err = nil;
    NSString* locationStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSUTF8StringEncoding error:&err];
    
    
    NSArray *items = [locationStr componentsSeparatedByString:@","];
    
    double latVal = 0.0;
    double longVal = 0.0;
    
    if([items count] >= 4 && [[items objectAtIndex:0] isEqualToString:@"200"]) {
        latVal = [[items objectAtIndex:2] doubleValue];
        longVal = [[items objectAtIndex:3] doubleValue];
    }
    
    CLLocationCoordinate2D location;
    location.latitude = latVal;
    location.longitude = longVal;
    
    return location;
}


@end
