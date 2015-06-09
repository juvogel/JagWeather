//
//  MapViewController.m
//  JagWeather
//
//  Created by Bobby Vogel on 2/16/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "MapViewController.h"
#import "APIManager.h"
#import "RadarOverlayRenderer.h"

@implementation MapViewController

@synthesize mapDisplayModeOptions, worldView, selectedLocation, locationManager, radarOverlay, coordinate;

- (void)viewDidLoad {
    [super viewDidLoad];
	_defaults = [NSUserDefaults standardUserDefaults];
	
	// Set up segemented control on navigation bar
	mapDisplayModeOptions = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Standard", @"Satellite", @"Hybrid", nil]];
	self.navigationItem.titleView = mapDisplayModeOptions;
	[mapDisplayModeOptions addTarget:self action:@selector(mapDisplayMode:) forControlEvents:UIControlEventValueChanged];
	// Set segmented control to default mode
	[_defaults integerForKey:@"mapDisplayMode"] != NSNotFound ? [mapDisplayModeOptions setSelectedSegmentIndex:[_defaults integerForKey:@"mapDisplayMode"]] : [mapDisplayModeOptions setSelectedSegmentIndex:2];
	
	// Set map view to default mode
	[_defaults integerForKey:@"mapDisplayMode"] != NSNotFound ? [worldView setMapType:[_defaults integerForKey:@"mapDisplayMode"]] : [worldView setMapType:MKMapTypeHybrid];
	
	// Map region set up
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([[selectedLocation latitude] doubleValue], [[selectedLocation longitude] doubleValue]), 300000, 300000);
    [worldView setRegion:region animated:YES];
	// Show current location on map
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	[locationManager startUpdatingLocation];
	
	// Refresh radar when image is finished downloaded
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRadar) name:@"RadarImageReceived" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshRadar {
	if (radarOverlay) {
		[worldView removeOverlay:radarOverlay];
	}
	radarOverlay = [[RadarOverlay alloc] initWithRegion:[worldView region]];
	[worldView addOverlay:radarOverlay level:MKOverlayLevelAboveRoads];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	[[APIManager sharedManager] fetchRadar:[worldView region]];
}

-(IBAction)mapDisplayMode:(id)sender {
	
	// Change map type
	[worldView setMapType:mapDisplayModeOptions.selectedSegmentIndex];
	
	// Save user preference of map type
	[_defaults setInteger:mapDisplayModeOptions.selectedSegmentIndex forKey:@"mapDisplayMode"];
	[_defaults synchronize];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"didFailWithError: %@", error);
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	
	// Stop Location Manager
	[locationManager stopUpdatingLocation];
	
	// Put user location on map if inside current map view
	MKMapPoint userLocation = MKMapPointForCoordinate([[locations firstObject] coordinate]);
	if (MKMapRectContainsPoint([worldView visibleMapRect], userLocation)) {
		[worldView setShowsUserLocation:YES];
	}
}

#pragma mark - Map View delegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
	RadarOverlayRenderer *overlayRenderer = [[RadarOverlayRenderer alloc] initWithOverlay:overlay overlayImage:[[APIManager sharedManager] getRadar]];
	
	return overlayRenderer;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
