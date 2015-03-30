//
//  WeatherLocation.m
//  JagWeather
//
//  Created by Bobby Vogel on 2/9/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "WeatherLocation.h"

@implementation WeatherLocation

@synthesize postalCode, countryName, state, city, coordinate, tempF, condition, icon, high, low, humidity, wind, pressure, feelsLike;

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

-(instancetype)initWithString:locationString {
    self = [super init];
    
    if (self) {
        // parse string
        NSArray *locationArray = [locationString componentsSeparatedByString:@", "];
        [self setCity:[locationArray objectAtIndex:0]];
        
        // compare second half of string to dictionary of all US States
        NSDictionary *states = @{ @"Alabama": @"AL", @"Alaska" : @"AK", @"Arizona" : @"AZ", @"Arkansas" : @"AR", @"California" : @"CA", @"Colorado" : @"CO", @"Connecticut" : @"CT", @"Delaware" : @"DE", @"Florida" : @"FL", @"Georgia" : @"GA", @"Hawaii" : @"HI", @"Idaho" : @"ID", @"Illinois" : @"IL", @"Indiana" : @"IN", @"Iowa" : @"IA", @"Kansas" : @"KS", @"Kentucky" : @"KY", @"Louisiana" : @"LA", @"Maine" : @"ME", @"Maryland" : @"MD", @"Massachusetts" : @"MA", @"Michigan" : @"MI", @"Minnesota" : @"MN", @"Mississippi" : @"MS", @"Missouri" : @"MO", @"Montana" : @"MT", @"Nebraska" : @"NE", @"Nevada": @"NV", @"New Hampshire" : @"NH", @"New Jersey" : @"NJ", @"New Mexico" : @"NM", @"New York" : @"NY", @"North Carolina" : @"NC", @"North Dakota" : @"ND", @"Ohio" : @"OH", @"Oklahoma" : @"OK", @"Oregon" : @"OR", @"Pennsylvania" : @"PA", @"Rhode Island" : @"RI", @"South Carolina" : @"SC", @"South Dakota" : @"SD", @"Tennessee" : @"TN", @"Texas" : @"TX", @"Utah" : @"UT", @"Vermont" : @"VT", @"Virginia" : @"VA", @"Washington" : @"WA", @"West Virginia" : @"WV", @"Wisconsin" : @"WI", @"Wyoming" : @"WY"};
        
        if ([states objectForKey:[NSString stringWithFormat:@"%@", [locationArray objectAtIndex:1]]] != nil) {
            [self setState:[states objectForKey:[locationArray objectAtIndex:1]]];
            [self setCountryName:@"USA"];
        } else {
            [self setCountryName:[locationArray objectAtIndex:1]];
        }
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
