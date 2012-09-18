//
//  IBEventLocationMapViewController.m
//  iBabe
//
//  Created by David Liang on 28/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBEventLocationMapViewController.h"
// #import "IBEventDetailsViewController.h"

#define METERS_PER_MILE 1609.344

@interface IBEventLocationMapViewController ()

@end

@implementation IBEventLocationMapViewController
@synthesize mapEventLocation, location;

#pragma mark- UI Action Functions
- (void)initNavigationBar
{
    UIBarButtonItem *btnShowMe = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:100 target:self action:@selector(btnShowMyLocationPressed:)];

    UIBarButtonItem *btnShowTarget = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"target-location.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(btnShowTargetLocationPressed:)];

    NSMutableArray *rightBtns = [[NSMutableArray alloc] initWithCapacity:2];

    [rightBtns addObject:btnShowMe];
    [rightBtns addObject:btnShowTarget];

    [[self navigationItem] setRightBarButtonItems:rightBtns];

    [btnShowMe release];
    [btnShowTarget release];
    [rightBtns release];
}





- (IBAction)btnShowMyLocationPressed:(id)sender
{
    [mapEventLocation setCenterCoordinate:mapEventLocation.userLocation.coordinate animated:YES];
}



- (IBAction)btnShowTargetLocationPressed:(id)sender
{
    [mapEventLocation setCenterCoordinate:locationCoord animated:YES];
}



#pragma mark- MKMap Delegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
}



- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
}



- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
}



- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
	[mapEventLocation removeOverlay:connectionLine];
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
	
	
	
	CLLocationCoordinate2D coords[2];
	
	coords[0] = locationCoord;
	coords[1] = userLocation.coordinate;
	
	connectionLine = [MKPolyline polylineWithCoordinates:coords count:2];
	
	
	if (Nil != connectionLine)
	{
		[mapEventLocation addOverlay:connectionLine];
	}
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
	

}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{

    MKAnnotationView    *annView = nil;
    static NSString     *defaultPinID = @"com.sigmapps.iBabe.defPin";

    if (annotation != mapEventLocation.userLocation)
    {
        annView = (MKPinAnnotationView *)[mapEventLocation dequeueReusableAnnotationViewWithIdentifier:defaultPinID];

        if (annView == nil)
        {
            annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }

        // --- Add a right arrown icon on the title box for clicking.
        annView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
        annView.image = [UIImage imageNamed:@"pin-yellow.png"];
    }
	else
    {
        [mapEventLocation.userLocation setTitle:@"Your're Here."];
		
	}

    annView.canShowCallout = YES;
    annView.draggable = NO;

    return annView ;
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{

	UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
	
	IBLocationWebBrowserViewController* webViewCtrl = [sb instantiateViewControllerWithIdentifier:@"IBLocationWebBrowserView"];
	[webViewCtrl setLocationName:[[view annotation] title]];
	[self.navigationController pushViewController:webViewCtrl animated:YES];
}



- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView *overlayView = nil;

    if (overlay == connectionLine)
    {
        // if we have not yet created an overlay view for this overlay, create it now.
        if (nil == connectionLineView)
        {
            connectionLineView = [[[MKPolylineView alloc] initWithPolyline:connectionLine] autorelease];
            connectionLineView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
			connectionLineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
			connectionLineView.lineCap = kCGLineCapButt;
			connectionLineView.lineJoin = kCGLineJoinBevel;
            connectionLineView.lineWidth = 3;
        }

        overlayView = connectionLineView;
    }

    return overlayView;
}




#pragma mark-
#pragma MBProgresHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD was hidded
    [progressHUD removeFromSuperview];
    [progressHUD release];
    progressHUD = nil;
}



#pragma mark -
#pragma LocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	
}




- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
}




#pragma mark- View Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self)
    {
        // Custom initialization
    }

    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
	
	[locationManager startUpdatingLocation];
	
	
    mapEventLocation.delegate = self;
	mapEventLocation.showsUserLocation = YES;
    [mapEventLocation setUserTrackingMode:MKUserTrackingModeNone];


	
	
    progressHUD = [[MBProgressHUD alloc] initWithView:[self.navigationController view]];
    [progressHUD setLabelText:@"Loading..."];
    [progressHUD setMode:MBProgressHUDModeDeterminate];
    [self.navigationController.view addSubview:progressHUD];

    [self initNavigationBar];
	
	
	if (![location isEqualToString:@""])
    {
        [locationManager startUpdatingLocation];
		
        // --- Set up the annotation.
		locationCoord = [SMMapUtil getLocationFromAddressString:location];

        MKPointAnnotation *annotation = [[[MKPointAnnotation alloc] init] autorelease];
        annotation.coordinate = locationCoord;
        annotation.title = location;
        // annotation.subtitle = @"Get direction - Tab the 'i' icon.";
        [mapEventLocation addAnnotation:annotation];
		
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locationCoord, METERS_PER_MILE, METERS_PER_MILE);
        MKCoordinateRegion adjRegion = [mapEventLocation regionThatFits:region];
        [mapEventLocation setRegion:adjRegion animated:YES];
		
    }
	

}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}



- (void)viewDidUnload
{
    [self setMapEventLocation:nil];
    [locationManager stopUpdatingLocation];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



// - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
// {
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
// }

- (void)dealloc
{
    [locationManager release];
    [mapEventLocation release];
	[geoCodder release];
    [super dealloc];
}

@end