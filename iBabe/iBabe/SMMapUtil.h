//
//  SMMapUtil.h
//  iBabe
//
//  Created by David Liang on 28/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SMMapUtil : NSObject
{
}

+(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr;

@end
