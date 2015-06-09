//
//  WeatherLocationTableViewController.h
//  JagWeather
//
//  Created by Bobby Vogel on 2/9/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherLocation.h"

@interface WeatherLocationTableViewController : UITableViewController <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocation *currentLocation;
}

@property (nonatomic) UIRefreshControl *refreshControl;

@end
