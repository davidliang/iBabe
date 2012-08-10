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
#import "MBProgressHUD/MBProgressHUD.h"

@class IBAnnotation;


@interface IBEventLocationMapViewController : UIViewController<MKMapViewDelegate, MBProgressHUDDelegate>
{
    CLLocationCoordinate2D locationCoord;
	MBProgressHUD *progressHUD;
	
}

@property (retain, nonatomic) IBOutlet MKMapView *mapEventLocation;
@property (retain, nonatomic) NSString* location;

@end
