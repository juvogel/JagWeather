//
//  MapViewController.h
//  JagWeather
//
//  Created by Bobby Vogel on 2/16/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "WeatherLocation.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) IBOutlet MKMapView *worldView;
@property (nonatomic) WeatherLocation *selectedLocation;
@property (nonatomic) CLLocationManager *locationManager;

@end
