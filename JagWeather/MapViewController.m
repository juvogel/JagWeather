//
//  MapViewController.m
//  JagWeather
//
//  Created by Bobby Vogel on 2/16/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "MapViewController.h"
#import "APIManager.h"

@implementation MapViewController

@synthesize worldView, selectedLocation, locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([[selectedLocation latitude] doubleValue], [[selectedLocation longitude] doubleValue]), 10000, 10000);
    [worldView setRegion:region animated:YES];
	
	[self refreshRadar];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRadar) name:@"RadarImageReceived" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshRadar {
	[[APIManager sharedManager] getRadar];
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
