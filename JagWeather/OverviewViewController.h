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
@property (nonatomic) IBOutlet UILabel *currentTemperature;
@property (nonatomic) IBOutlet UILabel *currentCondition;
@property (nonatomic) IBOutlet UILabel *currentConditionIcon;
@property (nonatomic) IBOutlet UILabel *currentWind;
@property (nonatomic) IBOutlet UILabel *currentHigh;
@property (nonatomic) IBOutlet UILabel *currentLow;
@property (nonatomic) IBOutlet UILabel *currentHumidity;
@property (nonatomic) IBOutlet UILabel *currentPressure;
@property (nonatomic) IBOutlet UILabel *currentFeelsLike;

-(void)resolveConditionIcon;

@end
