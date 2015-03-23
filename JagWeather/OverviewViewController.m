//
//  OverviewViewController.m
//  JagWeather
//
//  Created by Bobby Vogel on 2/9/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "OverviewViewController.h"
#import "MapViewController.h"
#import "APIManager.h"
#import "OverviewDetailViewController.h"

@implementation OverviewViewController

@synthesize selectedLocation, locationField, currentTemperature, currentCondition, currentConditionIcon, currentWind, currentHigh, currentLow, currentHumidity, currentPressure, currentFeelsLike;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // set image background
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background2x.png"]];
    [self.view insertSubview:backgroundImage atIndex:0];
    
    // set color for labels to white
    [locationField setTextColor:[UIColor whiteColor]];
    [currentTemperature setTextColor:[UIColor whiteColor]];
    [currentCondition setTextColor:[UIColor whiteColor]];
    [currentHigh setTextColor:[UIColor whiteColor]];
    [currentLow setTextColor:[UIColor whiteColor]];
    [currentConditionIcon setTextColor:[UIColor whiteColor]];
    
    // set labels for weather condition
    [locationField setText:[selectedLocation city]];
    [currentTemperature setText:[NSString stringWithFormat:@"%ld\u00B0", (long)[selectedLocation tempF]]];
    [currentCondition setText:[selectedLocation condition]];
    [currentHigh setText:[NSString stringWithFormat:@"%ld", (long)[selectedLocation high]]];
    [currentLow setText:[NSString stringWithFormat:@"%ld", (long)[selectedLocation low]]];
    
    // set custom font for condition icon
    currentConditionIcon.font = [UIFont fontWithName:@"Meteocons" size:24];
    [self resolveConditionIcon];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabels) name:@"APIDataProcessed" object:nil];
    
    // recognize when screen is tapped
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateLabels {
    [currentTemperature setText:[NSString stringWithFormat:@"%ld\u00B0", (long)[selectedLocation tempF]]];
    [currentCondition setText:[selectedLocation condition]];
    [currentHigh setText:[NSString stringWithFormat:@"%ld", (long)[selectedLocation high]]];
    [currentLow setText:[NSString stringWithFormat:@"%ld", (long)[selectedLocation low]]];
    [self resolveConditionIcon];
}

-(void)resolveConditionIcon {
    if ([[selectedLocation condition] rangeOfString:@"Drizzle"].location != NSNotFound) {
        [currentConditionIcon setText:@"Q"];
    } else if ([[selectedLocation condition] rangeOfString:@"Light Rain"].location != NSNotFound) {
        [currentConditionIcon setText:@"Q"];
    } else if ([[selectedLocation condition] rangeOfString:@"Rain"].location != NSNotFound) {
        [currentConditionIcon setText:@"R"];
    } else if ([[selectedLocation condition] rangeOfString:@"Light Snow"].location != NSNotFound) {
        [currentConditionIcon setText:@"U"];
    } else if ([[selectedLocation condition] rangeOfString:@"Snow"].location != NSNotFound) {
        [currentConditionIcon setText:@"W"];
    } else if ([[selectedLocation condition] rangeOfString:@"Hail"].location != NSNotFound) {
        [currentConditionIcon setText:@"X"];
    } else if ([[selectedLocation condition] rangeOfString:@"Mist"].location != NSNotFound) {
        [currentConditionIcon setText:@"L"];
    } else if ([[selectedLocation condition] rangeOfString:@"Fog"].location != NSNotFound) {
        [currentConditionIcon setText:@"M"];
    } else if ([[selectedLocation condition] rangeOfString:@"Thunderstorm"].location != NSNotFound) {
        [currentConditionIcon setText:@"O"];
    } else if ([[selectedLocation condition] rangeOfString:@"Overcast"].location != NSNotFound) {
        [currentConditionIcon setText:@"Y"];
    } else if ([[selectedLocation condition] rangeOfString:@"Haze"].location != NSNotFound) {
        [currentConditionIcon setText:@"A"];
    } else if ([[selectedLocation condition] rangeOfString:@"Clear"].location != NSNotFound) {
        // if UTC time is less than sunset and greater than sunrise
        [currentConditionIcon setText:@"B"];
        // else
        //[currentConditionIcon setText:@"C"];
    } else if ([[selectedLocation condition] rangeOfString:@"Cloudy"].location != NSNotFound) {
        [currentConditionIcon setText:@"N"];
    } else if ([[selectedLocation condition] rangeOfString:@"Clouds"].location != NSNotFound) {
        [currentConditionIcon setText:@"N"];
    } else {
        [currentConditionIcon setText:@"?"];
    }
}

-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    [self performSegueWithIdentifier:@"detailSegue" sender:recognizer];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"mapViewSegue"]) {
        MapViewController *mapViewController = [segue destinationViewController];
        [mapViewController setSelectedLocation:selectedLocation];
    } else {
        OverviewDetailViewController *weatherDetail = [segue destinationViewController];
        [weatherDetail setSelectedLocation:selectedLocation];
    }
}

@end
