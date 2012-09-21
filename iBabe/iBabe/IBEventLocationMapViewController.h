//
//  IBEventLocationMapViewController.h
//  iBabe
//
//  Created by David Liang on 28/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SMMapUtil.h"
#import "MBProgressHUD.h"
#import "IBLocationWebBrowserViewController.h"

@class IBAnnotation;

@interface IBEventLocationMapViewController : UIViewController <MKMapViewDelegate>
{
    CLLocationCoordinate2D  locationCoord;
    MKPolyline              *connectionLine;
    MKMapPoint              *pinLocations;
    CLGeocoder              *geoCodder;
    NSMutableArray          *points;
    MBProgressHUD           *progressHUD;
}

@property (retain, nonatomic) IBOutlet MKMapView    *mapEventLocation;
@property (retain, nonatomic) NSString              *location;

@end