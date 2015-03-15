//
//  OverviewViewController.h
//  JagWeather
//
//  Created by Bobby Vogel on 2/9/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherLocation.h"
#import "MapViewController.h"

@interface OverviewViewController : UIViewController

@property (nonatomic) WeatherLocation *selectedLocation;
@property (nonatomic) IBOutlet UILabel *locationField;

@end
