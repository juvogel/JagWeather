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

-(void)fetchJSONFromAPI:(NSURL *)url location:(WeatherLocation *)incomingLocation {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        locationAPIData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        // run this method on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self parseJSON:incomingLocation];
        });
    }];
    [dataTask resume];
}

-(void)fetchWeatherConditions:(WeatherLocation *)incomingLocation {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@conditions/q/%f,%f.json", weatherAPIURL, [incomingLocation coordinate].latitude, [incomingLocation coordinate].longitude]];
    
    [self fetchJSONFromAPI:url location:incomingLocation];
}

-(void)fetchWeatherForecast:(WeatherLocation *)incomingLocation {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@forecast/q/%f,%f.json", weatherAPIURL, [incomingLocation coordinate].latitude, [incomingLocation coordinate].longitude]];
    
    [self fetchJSONFromAPI:url location:incomingLocation];
}

-(void)parseJSON:(WeatherLocation *)incomingLocation{
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
/*
// DELEGATE METHODS FOR NSURLCONNECTION

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [jsonAPIData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    locationAPIData = [NSJSONSerialization JSONObjectWithData:jsonAPIData options:0 error:nil];
    [self parseJSON];
}
*/
@end
