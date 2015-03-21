//
//  OverviewDetailViewController.m
//  JagWeather
//
//  Created by Bobby Vogel on 3/20/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "OverviewDetailViewController.h"

@implementation OverviewDetailViewController

@synthesize selectedLocation, currentWind, currentHumidity, currentPressure, currentFeelsLike;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Set color for labels to white
    [currentWind setTextColor:[UIColor whiteColor]];
    [currentHumidity setTextColor:[UIColor whiteColor]];
    [currentPressure setTextColor:[UIColor whiteColor]];
    [currentFeelsLike setTextColor:[UIColor whiteColor]];
    
    // Set labels for weather condition
    [currentWind setText:[selectedLocation wind]];
    [currentHumidity setText:[selectedLocation humidity]];
    [currentPressure setText:[selectedLocation pressure]];
    [currentFeelsLike setText:[NSString stringWithFormat:@"%ld\u00B0", [selectedLocation feelsLike]]];
    
    // Recognize when screen is tapped
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
}

-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    // Make view disappear
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
