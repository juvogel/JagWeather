//
//  AddViewLocationViewController.h
//  JagWeather
//
//  Created by Bobby Vogel on 3/24/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddLocationViewController : UIViewController <UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UISearchController *searchController;
@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
