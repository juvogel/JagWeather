//
//  WeatherLocation.m
//  JagWeather
//
//  Created by Bobby Vogel on 2/9/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "WeatherLocation.h"

@implementation WeatherLocation

@synthesize postalCode, countryName, state, city, coordinate, tempF, weather, icon, high, low, relativeHumidity, wind;

-(instancetype)initWithCity:strCity
          State:strState
        Country:strCountryName {
    
    self = [super init];
    
    if (self) {
        [self setCity:strCity];
        [self setState:strState];
        [self setCountryName:strCountryName];
    }
    
    return self;
}

-(NSString *)fullName {
    if ([countryName isEqualToString:@"USA"]) {
        return [NSString stringWithFormat:@"%@, %@, %@", city, state, countryName];
    } else {
        return [NSString stringWithFormat:@"%@, %@", city, countryName];
    }
}

@end
