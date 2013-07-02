//
//  SMMapUtil.m
//  iBabe
//
//  Created by David Liang on 28/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "SMMapUtil.h"

@implementation SMMapUtil

// ---- Convert address location to LocationCoordinate.
+ (CLLocationCoordinate2D)getLocationFromAddressString:(NSString *)addressStr
{
//    NSString *urlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
//        [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//
//    NSError     *err = nil;
//    NSString    *locationStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSUTF8StringEncoding error:&err];
//
//    NSArray *items = [locationStr componentsSeparatedByString:@","];
//
//    double  latVal = 0.0;
//    double  longVal = 0.0;
//
//    if (([items count] >= 4) && [[items objectAtIndex:0] isEqualToString:@"200"])
//    {
//        latVal = [[items objectAtIndex:2] doubleValue];
//        longVal = [[items objectAtIndex:3] doubleValue];
//    }
//
//    CLLocationCoordinate2D location;
//    location.latitude = latVal;
//    location.longitude = longVal;
//
//    return location;

	
	NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
	
	NSDictionary *googleResponse = [[NSString stringWithContentsOfURL: [NSURL URLWithString: req] encoding: NSUTF8StringEncoding error: NULL] JSONValue];
	
	NSDictionary    *resultsDict = [googleResponse valueForKey:  @"results"];   // get the results dictionary
	NSDictionary   *geometryDict = [resultsDict valueForKey: @"geometry"];   // geometry dictionary within the  results dictionary
	NSDictionary   *locationDict = [geometryDict valueForKey: @"location"];   // location dictionary within the geometry dictionary
	
	NSArray *latArray = [locationDict valueForKey: @"lat"];
	NSString *latString = [latArray lastObject];     // (one element) array entries provided by the json parser
	
	NSArray *lngArray = [locationDict valueForKey: @"lng"];
	NSString *lngString = [lngArray lastObject];     // (one element) array entries provided by the json parser
	
	CLLocationCoordinate2D location;
	location.latitude = [latString doubleValue];// latitude;
	location.longitude = [lngString doubleValue]; //longitude;
	
	 return location;

}



@end