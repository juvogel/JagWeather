//
//  AddViewLocationViewController.m
//  JagWeather
//
//  Created by Bobby Vogel on 3/24/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "AddLocationViewController.h"
#import "WeatherLocationStore.h"
#import "APIManager.h"

@implementation AddLocationViewController

@synthesize searchController, searchResults, tableView;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // store results of search filter
    searchResults = [NSMutableArray arrayWithCapacity:[[[WeatherLocationStore sharedStore] getAllLocations] count]];
    
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    
    // style
    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.hidesNavigationBarDuringPresentation = NO;
    // position
    searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.navigationItem.titleView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
}

-(void)updateTable {
    searchResults = [[[APIManager sharedManager] getSearchResults] mutableCopy];
    [[self tableView] reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [localTableView dequeueReusableCellWithIdentifier:@"SearchResultPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [[cell textLabel] setText:[[searchResults objectAtIndex:[indexPath row]] objectForKey:@"name"]];
    
    return cell;
}

// Search Bar Delegate Methods

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // get string typed in
    NSString *searchString = [self.searchController.searchBar text];
    
    if ([searchString length] > 0) {
        // reset array
        [[self searchResults] removeAllObjects];
        // fetch results
        [[APIManager sharedManager] fetchLocationsFromAPI:searchString];
        // when results are loaded refresh table data
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"APISearchDataProcessed" object:nil];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // dismiss view if cancel is pressed
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get row selected and information
    NSDictionary *selectedLocationInfo = [searchResults objectAtIndex:[indexPath row]];
    
    // Set weather location from dictionary
	[[WeatherLocationStore sharedStore] createLocationFromString:[selectedLocationInfo objectForKey:@"name"] Latitude:[selectedLocationInfo objectForKey:@"lat"] Longitude:[selectedLocationInfo objectForKey:@"lon"]];
    
    // Dismiss view
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [[APIManager sharedManager] fetchWeatherConditions:newLocation];
    }];
}

@end
