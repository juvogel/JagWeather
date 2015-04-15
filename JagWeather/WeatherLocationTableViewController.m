//
//  WeatherLocationTableViewController.m
//  JagWeather
//
//  Created by Bobby Vogel on 2/9/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "WeatherLocationTableViewController.h"
#import "WeatherLocation.h"
#import "OverviewViewController.h"
#import "WeatherLocationStore.h"
#import "APIManager.h"
#import "WeatherTableViewCell.h"

@implementation WeatherLocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	[locationManager requestWhenInUseAuthorization];
	[locationManager startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"APIDataProcessed" object:nil];
}

- (void)loadInitialData {
    for (WeatherLocation *apiLocation in [[WeatherLocationStore sharedStore] getAllLocations]) {
        [[APIManager sharedManager] fetchWeatherConditions:apiLocation];
    }
}

-(void)reloadTableData {
    [[self tableView] reloadData];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"didFailWithError: %@", error);
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	currentLocation = newLocation;
	
	if (currentLocation != nil) {
		[[[WeatherLocationStore sharedStore] getWeatherLocationAtIndex:0] setLatitude:[NSNumber numberWithDouble:currentLocation.coordinate.latitude]];
		[[[WeatherLocationStore sharedStore] getWeatherLocationAtIndex:0] setLongitude:[NSNumber numberWithDouble:currentLocation.coordinate.longitude]];
	}
	
	// Stop Location Manager
	[locationManager stopUpdatingLocation];
	
	[self loadInitialData];
	
	[self reloadTableData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[WeatherLocationStore sharedStore] getAllLocations] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weatherCell" forIndexPath:indexPath];
	
    // Configure the cell...
	
	if (cell == nil)
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"weatherCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}
	
    WeatherLocation *thisLocation = [[[WeatherLocationStore sharedStore] getAllLocations] objectAtIndex:[indexPath row]];
    [[cell cityNameLabel] setText:[thisLocation city]];
    [[cell temperatureLabel] setText:[NSString stringWithFormat:@"%@", [thisLocation tempF]]];
	[[cell weatherIconLabel] setText:[thisLocation icon]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[WeatherLocationStore sharedStore] removeLocation:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [[WeatherLocationStore sharedStore] reorderLocationFromIndex:[fromIndexPath row] toIndexPath:[toIndexPath row]];
    [self reloadTableData];
}
*/

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"LocationOverviewSegue"]) {
        
        // Get the new view controller using [segue destinationViewController].
        
        OverviewViewController *locationName = [segue destinationViewController];
        
        // Pass the selected object to the new view controller.
        
        NSIndexPath *ip = [self.tableView indexPathForCell:sender];
        
        WeatherLocation *thisLocation = [[[WeatherLocationStore sharedStore] getAllLocations] objectAtIndex:[ip row]];
        
        [locationName setSelectedLocation:thisLocation];
        
        [[APIManager sharedManager] fetchWeatherConditions:thisLocation];
        [[APIManager sharedManager] fetchWeatherForecast:thisLocation];
    }
}

@end
