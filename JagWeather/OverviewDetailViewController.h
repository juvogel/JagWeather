//
//  OverviewDetailViewController.h
//  JagWeather
//
//  Created by Bobby Vogel on 3/20/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewViewController.h"

@interface OverviewDetailViewController : OverviewViewController

@property (nonatomic) WeatherLocation *selectedLocation;
@property (nonatomic) IBOutlet UILabel *currentWind;
@property (nonatomic) IBOutlet UILabel *currentHumidity;
@property (nonatomic) IBOutlet UILabel *sunrise;
@property (nonatomic) IBOutlet UILabel *sunset;

@end
