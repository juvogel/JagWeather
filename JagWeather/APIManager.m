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

-(void)fetchWeatherForLocation:(WeatherLocation *)incomingLocation informationType:(NSString *)keyword {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/q/%@,%@.json", weatherAPIURL, keyword, [incomingLocation latitude], [incomingLocation longitude]]];
    
    [self fetchJSONFromAPI:url withLocation:incomingLocation];
}

-(void)fetchRadar:(MKCoordinateRegion)region {
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;
	CGFloat screenHeight = screenRect.size.height;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@radar/image.gif?noclutter=1&rainsnow=1&smooth=1&width=%f&height=%f&centerlat=%f&centerlon=%f&radius=%f", weatherAPIURL, screenWidth, screenHeight, region.center.latitude, region.center.longitude, region.span.longitudeDelta]];
	NSLog(@"%@", url);
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		radar = (UIImage *)data;
		
		// run this method on main thread
		dispatch_async(dispatch_get_main_queue(), ^{
			[[NSNotificationCenter defaultCenter] postNotificationName:@"RadarImageReceived" object:self];
		});
	}];
	[dataTask resume];
}

-(UIImage *)getRadar {
	return radar;
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
			} else {
				[self parseJSON:locationAPIData];
			}
        });
    }];
    [dataTask resume];
}

-(void)parseJSON:(NSDictionary *)locationAPIData withLocation:(WeatherLocation *)incomingLocation {
    if ([locationAPIData objectForKey:@"forecast"] != NULL) {
        // fetch high temp
        [incomingLocation setHigh:[NSDecimalNumber decimalNumberWithString:[[[[[[locationAPIData objectForKey:@"forecast"] objectForKey:@"simpleforecast"] objectForKey:@"forecastday"] objectAtIndex:0] objectForKey:@"high"] objectForKey:@"fahrenheit"]]];
        // fetch low temp
        [incomingLocation setLow:[NSDecimalNumber decimalNumberWithString:[[[[[[locationAPIData objectForKey:@"forecast"] objectForKey:@"simpleforecast"] objectForKey:@"forecastday"] objectAtIndex:0] objectForKey:@"low"] objectForKey:@"fahrenheit"]]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APIDataProcessed" object:self];
    }
	if ([locationAPIData objectForKey:@"current_observation"] != NULL) {
		// set location info if it is not there
		if ([incomingLocation city] == nil) {
			[incomingLocation setCity:[[[locationAPIData objectForKey:@"current_observation"] objectForKey:@"display_location"] objectForKey:@"city"]];
			[incomingLocation setState:[[[locationAPIData objectForKey:@"current_observation"] objectForKey:@"display_location"] objectForKey:@"state"]];
		}
        [incomingLocation setTempF:[[locationAPIData objectForKey:@"current_observation"] objectForKey:@"temp_f"]];
        [incomingLocation setCondition:[[locationAPIData objectForKey:@"current_observation"] objectForKey:@"weather"]];
        [incomingLocation setHumidity:[[locationAPIData objectForKey:@"current_observation"] objectForKey:@"relative_humidity"]];
        // fetch wind
        [incomingLocation setWind:[NSString stringWithFormat:@"%@ %@ mph", [[locationAPIData objectForKey:@"current_observation"] objectForKey:@"wind_dir"], [[locationAPIData objectForKey:@"current_observation"] objectForKey:@"wind_mph"]]];
        // fetch pressure
        [incomingLocation setPressure:[NSString stringWithFormat:@"%@ in", [[locationAPIData objectForKey:@"current_observation"] objectForKey:@"pressure_in"]]];
        // fetch feels like temp
        [incomingLocation setFeelsLike:[NSDecimalNumber decimalNumberWithString:[[locationAPIData objectForKey:@"current_observation"] objectForKey:@"feelslike_f"]]];
		[self resolveConditionIcon:incomingLocation];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APIDataProcessed" object:self];
	}
}

-(void)resolveConditionIcon:(WeatherLocation *)incomingLocation {
	if ([[incomingLocation condition] rangeOfString:@"Drizzle"].location != NSNotFound) {
		[incomingLocation setIcon:@"Q"];
		// night
		//[incomingLocation setIcon:@"7"];
	} else if ([[incomingLocation condition] rangeOfString:@"Light Rain"].location != NSNotFound) {
		[incomingLocation setIcon:@"Q"];
		// night
		//[incomingLocation setIcon:@"7"];
	} else if ([[incomingLocation condition] rangeOfString:@"Rain"].location != NSNotFound) {
		[incomingLocation setIcon:@"R"];
		// night
		//[incomingLocation setIcon:@"8"];
	} else if ([[incomingLocation condition] rangeOfString:@"Light Snow"].location != NSNotFound) {
		[incomingLocation setIcon:@"U"];
		// night
		//[incomingLocation setIcon:@"\""];
	} else if ([[incomingLocation condition] rangeOfString:@"Snow"].location != NSNotFound) {
		[incomingLocation setIcon:@"W"];
		// night
		//[incomingLocation setIcon:@"#"];
	} else if ([[incomingLocation condition] rangeOfString:@"Flurries"].location != NSNotFound) {
		[incomingLocation setIcon:@"U"];
		// night
		//[incomingLocation setIcon:@"\""];
	} else if ([[incomingLocation condition] rangeOfString:@"Hail"].location != NSNotFound) {
		[incomingLocation setIcon:@"X"];
		// night
		//[incomingLocation setIcon:@"$"];
	} else if ([[incomingLocation condition] rangeOfString:@"Mist"].location != NSNotFound) {
		[incomingLocation setIcon:@"L"];
	} else if ([[incomingLocation condition] rangeOfString:@"Fog"].location != NSNotFound) {
		[incomingLocation setIcon:@"M"];
	} else if ([[incomingLocation condition] rangeOfString:@"Thunderstorms"].location != NSNotFound) {
		[incomingLocation setIcon:@"Z"];
		// night
		//[incomingLocation setIcon:@"&"];
	} else if ([[incomingLocation condition] rangeOfString:@"Thunderstorm"].location != NSNotFound) {
		[incomingLocation setIcon:@"O"];
		// night
		//[incomingLocation setIcon:@"6"];
	} else if ([[incomingLocation condition] rangeOfString:@"Overcast"].location != NSNotFound) {
		[incomingLocation setIcon:@"Y"];
		// night
		//[incomingLocation setIcon:@"%"];
	} else if ([[incomingLocation condition] rangeOfString:@"Haze"].location != NSNotFound) {
		[incomingLocation setIcon:@"A"];
	} else if ([[incomingLocation condition] rangeOfString:@"Clear"].location != NSNotFound) {
		// if UTC time is less than sunset and greater than sunrise
		[incomingLocation setIcon:@"B"];
		// else
		//[incomingLocation setIcon:@"C"];
	} else if ([[incomingLocation condition] rangeOfString:@"Partly Cloudy"].location != NSNotFound) {
		[incomingLocation setIcon:@"H"];
		// night
		//[incomingLocation setIcon:@"4"];
	} else if ([[incomingLocation condition] rangeOfString:@"Cloudy"].location != NSNotFound) {
		[incomingLocation setIcon:@"N"];
		// night
		//[incomingLocation setIcon:@"5"];
	} else if ([[incomingLocation condition] rangeOfString:@"Clouds"].location != NSNotFound) {
		[incomingLocation setIcon:@"N"];
		// night
		//[incomingLocation setIcon:@"5"];
	} else {
		[incomingLocation setIcon:@"?"];
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
