//
//  WeatherTableViewCell.h
//  JagWeather
//
//  Created by Bobby Vogel on 4/14/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@end
