//
//  WeatherLocation.m
//  JagWeather
//
//  Created by Bobby Vogel on 4/14/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "WeatherLocation.h"


@implementation WeatherLocation

@dynamic postalCode;
@dynamic countryName;
@dynamic state;
@dynamic city;
@dynamic latitude;
@dynamic longitude;
@dynamic tempF;
@dynamic condition;
@dynamic icon;
@dynamic high;
@dynamic low;
@dynamic humidity;
@dynamic wind;
@dynamic pressure;
@dynamic feelsLike;

-(NSString *)fullName {
	if ([[self countryName] isEqualToString:@"USA"]) {
		return [NSString stringWithFormat:@"%@, %@, %@", [self city], [self state], [self countryName]];
	} else {
		return [NSString stringWithFormat:@"%@, %@", [self city], [self countryName]];
	}
}

@end
