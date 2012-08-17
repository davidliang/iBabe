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
#import "MBProgressHUD/MBProgressHUD.h"

@class IBAnnotation;

@interface IBEventLocationMapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate, MBProgressHUDDelegate>
{
    CLLocationCoordinate2D  locationCoord;
    CLLocationManager       *locationManager;
	CLLocation				*locationTmpNew;
	CLLocation				*locationTmpOld;

    MBProgressHUD *progressHUD;
}

@property (retain, nonatomic) IBOutlet MKMapView    *mapEventLocation;
@property (retain, nonatomic) NSString              *location;

@end