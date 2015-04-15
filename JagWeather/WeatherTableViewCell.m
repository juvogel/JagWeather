//
//  WeatherTableViewCell.m
//  JagWeather
//
//  Created by Bobby Vogel on 4/14/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "WeatherTableViewCell.h"

@implementation WeatherTableViewCell

@synthesize cityNameLabel, weatherIconLabel, temperatureLabel;

- (void)awakeFromNib {
    // Initialization code
	weatherIconLabel.font = [UIFont fontWithName:@"Meteocons" size:28];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
