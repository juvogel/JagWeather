//
//  WeatherLocation.m
//  JagWeather
//
//  Created by Bobby Vogel on 4/20/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "WeatherLocation.h"


@implementation WeatherLocation

@dynamic city;
@dynamic condition;
@dynamic countryName;
@dynamic feelsLike;
@dynamic high;
@dynamic humidity;
@dynamic icon;
@dynamic latitude;
@dynamic longitude;
@dynamic low;
@dynamic postalCode;
@dynamic pressure;
@dynamic state;
@dynamic sunrise;
@dynamic sunset;
@dynamic tempF;
@dynamic timeZone;
@dynamic wind;
@dynamic creationDate;
@dynamic link;

-(NSString *)fullName {
	return [[self countryName] isEqualToString:@"USA"] ? [NSString stringWithFormat:@"%@, %@", [self city], [self state]] : [NSString stringWithFormat:@"%@, %@", [self city], [self countryName]];
}

-(void)awakeFromInsert {
	[super awakeFromInsert];
	
	self.creationDate = [NSDate date];
}

@end
