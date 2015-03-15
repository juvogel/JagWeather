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

@implementation WeatherLocationTableViewController

@synthesize allLocations;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    allLocations = [[NSMutableArray alloc] init];
    
    [self loadInitialData];
}

- (void)loadInitialData {
    for (id apiLocation in [[WeatherLocationStore sharedStore] getAllLocations]) {
        [[APIManager sharedManager] fetchInfoFromAPI:[apiLocation coordinate]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    WeatherLocation *thisLocation = [[[WeatherLocationStore sharedStore] getAllLocations] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[thisLocation fullName]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    }
}

@end
