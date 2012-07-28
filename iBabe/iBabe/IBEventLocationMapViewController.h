//
//  IBEventLocationMapViewController.h
//  iBabe
//
//  Created by David Liang on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SMMapUtil.h"
@class IBAnnotation;


@interface IBEventLocationMapViewController : UIViewController<MKMapViewDelegate>
{
    CLLocationCoordinate2D locationCoord;
	
}

@property (retain, nonatomic) IBOutlet MKMapView *mapEventLocation;
@property (retain, nonatomic) NSString* location;

@end
