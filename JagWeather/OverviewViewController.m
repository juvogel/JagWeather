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
	
	// set custom font for condition icon
	currentConditionIcon.font = [UIFont fontWithName:@"Meteocons" size:24];
	
    // set labels for weather condition
    [locationField setText:[selectedLocation city]];
    [currentTemperature setText:[NSString stringWithFormat:@"%@\u00B0", [selectedLocation tempF]]];
    [currentCondition setText:[selectedLocation condition]];
    [currentHigh setText:[NSString stringWithFormat:@"%@", [selectedLocation high]]];
    [currentLow setText:[NSString stringWithFormat:@"%@", [selectedLocation low]]];
	[currentConditionIcon setText:[selectedLocation icon]];
    
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
    [currentTemperature setText:[NSString stringWithFormat:@"%@\u00B0", [selectedLocation tempF]]];
    [currentCondition setText:[selectedLocation condition]];
    [currentHigh setText:[NSString stringWithFormat:@"%@", [selectedLocation high]]];
    [currentLow setText:[NSString stringWithFormat:@"%@", [selectedLocation low]]];
	[currentConditionIcon setText:[selectedLocation icon]];
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
