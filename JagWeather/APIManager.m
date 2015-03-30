//
//  APIManager.m
//  JagWeather
//
//  Created by Bobby Vogel on 3/11/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "APIManager.h"
#import "WeatherLocation.h"
#import "WeatherLocationStore.h"

#define API_KEY @"4009a293c3e11ed0"

@implementation APIManager

static APIManager *sharedManager = nil;

+(APIManager *)sharedManager {
    if(!sharedManager) {
        sharedManager = [[super allocWithZone:nil] init];
    }
    
    return sharedManager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedManager];
}

-(instancetype)init {
    self = [super init];
    
    if (self) {
        weatherAPIURL = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/", API_KEY];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
        jsonAPIData = [[NSMutableData alloc] init];
    }
    
    return self;
}

-(void)fetchWeatherConditions:(WeatherLocation *)incomingLocation {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@conditions/q/%f,%f.json", weatherAPIURL, [incomingLocation coordinate].latitude, [incomingLocation coordinate].longitude]];
    
    [self fetchJSONFromAPI:url withLocation:incomingLocation];
}

-(void)fetchWeatherForecast:(WeatherLocation *)incomingLocation {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@forecast/q/%f,%f.json", weatherAPIURL, [incomingLocation coordinate].latitude, [incomingLocation coordinate].longitude]];
    
    [self fetchJSONFromAPI:url withLocation:incomingLocation];
}

-(void)fetchLocationsFromAPI:(NSString *)searchString {
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://autocomplete.wunderground.com/aq?h=0&query=%@", searchString]];
    
    [self fetchJSONFromAPI:url withLocation:nil];
}

-(void)fetchJSONFromAPI:(NSURL *)url withLocation:(WeatherLocation *)incomingLocation {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *locationAPIData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        // run this method on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (incomingLocation) {
                [self parseJSON:locationAPIData withLocation:incomingLocation];
            }
            [self parseJSON:locationAPIData];
        });
    }];
    [dataTask resume];
}

-(void)parseJSON:(NSDictionary *)locationAPIData withLocation:(WeatherLocation *)incomingLocation {
    if ([locationAPIData objectForKey:@"forecast"] != NULL) {
        // fetch high temp
        [incomingLocation setHigh:[[[[[[[locationAPIData objectForKey:@"forecast"] objectForKey:@"simpleforecast"] objectForKey:@"forecastday"] objectAtIndex:0] objectForKey:@"high"] objectForKey:@"fahrenheit"] integerValue]];
        // fetch low temp
        [incomingLocation setLow:[[[[[[[locationAPIData objectForKey:@"forecast"] objectForKey:@"simpleforecast"] objectForKey:@"forecastday"] objectAtIndex:0] objectForKey:@"low"] objectForKey:@"fahrenheit"] integerValue]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APIDataProcessed" object:self];
    } else if ([locationAPIData objectForKey:@"current_observation"] != NULL) {
        [incomingLocation setTempF:[[[locationAPIData objectForKey:@"current_observation"] objectForKey:@"temp_f"] integerValue]];
        [incomingLocation setCondition:[[locationAPIData objectForKey:@"current_observation"] objectForKey:@"weather"]];
        [incomingLocation setHumidity:[[locationAPIData objectForKey:@"current_observation"] objectForKey:@"relative_humidity"]];
        // fetch wind
        [incomingLocation setWind:[NSString stringWithFormat:@"%@ %@ mph", [[locationAPIData objectForKey:@"current_observation"] objectForKey:@"wind_dir"], [[locationAPIData objectForKey:@"current_observation"] objectForKey:@"wind_mph"]]];
        // fetch pressure
        [incomingLocation setPressure:[NSString stringWithFormat:@"%@ in", [[locationAPIData objectForKey:@"current_observation"] objectForKey:@"pressure_in"]]];
        // fetch feels like temp
        [incomingLocation setFeelsLike:[[[locationAPIData objectForKey:@"current_observation"] objectForKey:@"feelslike_f"] integerValue]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APIDataProcessed" object:self];
    }
}

-(void)parseJSON:(NSDictionary *)apiData {
    searchResults = [apiData objectForKey:@"RESULTS"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APISearchDataProcessed" object:self];
}

-(NSArray *)getSearchResults {
    return searchResults;
}

@end
