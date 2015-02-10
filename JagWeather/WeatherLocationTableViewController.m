//
//  WeatherLocationTableViewController.m
//  JagWeather
//
//  Created by Bobby Vogel on 2/9/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "WeatherLocationTableViewController.h"

@interface WeatherLocationTableViewController ()

@end

@implementation WeatherLocationTableViewController

@synthesize allLocations;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    allLocations = [[NSMutableArray alloc] init];
    
    [self loadInitialData];
}

- (void)loadInitialData {
    WeatherLocation *loc1 = [[WeatherLocation alloc] initWithCity:@"Indianapolis"
                                                            State:@"IN"
                                                          Country:@"USA"];
    [[self allLocations] addObject:loc1];
    
    WeatherLocation *loc2 = [[WeatherLocation alloc] initWithCity:@"San Francisco"
                                                            State:@"CA"
                                                          Country:@"USA"];
    [[self allLocations] addObject:loc2];
    
    WeatherLocation *loc3 = [[WeatherLocation alloc] initWithCity:@"Hong Kong"
                                                            State:@""
                                                          Country:@"Hong Kong"];
    [[self allLocations] addObject:loc3];
    
    WeatherLocation *loc4 = [[WeatherLocation alloc] initWithCity:@"Rio de Janeiro"
                                                            State:@""
                                                          Country:@"Brazil"];
    [[self allLocations] addObject:loc4];
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
    return [allLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    WeatherLocation *thisLocation = [[self allLocations] objectAtIndex:[indexPath row]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
