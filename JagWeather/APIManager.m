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

#define API_KEY @"a5364373826b7b92"

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
	NSURL *url;
	if ([incomingLocation link] == nil) {
		url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/q/%@,%@.json", weatherAPIURL, keyword, [incomingLocation latitude], [incomingLocation longitude]]];
	} else {
		url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/q/zmw:%@.json", weatherAPIURL, keyword, [incomingLocation link]]];
	}
	
	if ([incomingLocation latitude] != nil) {
		[self fetchJSONFromAPI:url withLocation:incomingLocation];
	}
}

-(void)fetchRadar:(MKCoordinateRegion)region {
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;
	CGFloat screenHeight = screenRect.size.height;
	CGFloat centerLatitude = region.center.latitude;
	CGFloat centerLongitude = region.center.longitude;
	CGFloat minLatitude = centerLatitude - region.span.latitudeDelta / 2;
	CGFloat minLongitude = centerLongitude - region.span.longitudeDelta / 2;
	CGFloat maxLatitude = centerLatitude + region.span.latitudeDelta / 2;
	CGFloat maxLongitude = centerLongitude + region.span.longitudeDelta / 2;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@radar/image.png?reproj.automerc=1&noclutter=1&rainsnow=1&smooth=1&width=%f&height=%f&minlat=%f&minlon=%f&maxlat=%f&maxlon=%f", weatherAPIURL, screenWidth, screenHeight, minLatitude, minLongitude, maxLatitude, maxLongitude]];
	//NSLog(@"%@", url);
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		radar = [[UIImage alloc] initWithData:data];
		
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
				[self parseJSONSearchResults:locationAPIData];
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
		if ([incomingLocation city] == nil) {
			[incomingLocation setCity:[[[locationAPIData objectForKeyedSubscript:@"current_observation"] objectForKey:@"display_location"] objectForKey:@"city"]];
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
		[incomingLocation setTimeZone:[[locationAPIData objectForKey:@"current_observation"] objectForKey:@"local_tz_short"]];
		[self resolveConditionIcon:incomingLocation];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APIDataProcessed" object:self];
	}
	if ([locationAPIData objectForKey:@"sun_phase"] != NULL) {
		[incomingLocation setSunrise:[NSString stringWithFormat:@"%@:%@", [[[locationAPIData objectForKey:@"sun_phase"] objectForKey:@"sunrise"] objectForKey:@"hour"], [[[locationAPIData objectForKey:@"sun_phase"] objectForKey:@"sunrise"] objectForKey:@"minute"]]];
		[incomingLocation setSunset:[NSString stringWithFormat:@"%@:%@", [[[locationAPIData objectForKey:@"sun_phase"] objectForKey:@"sunset"] objectForKey:@"hour"], [[[locationAPIData objectForKey:@"sun_phase"] objectForKey:@"sunset"] objectForKey:@"minute"]]];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"APIDataProcessed" object:self];
	}
}

-(void)resolveConditionIcon:(WeatherLocation *)incomingLocation {
	BOOL daytime = [self isDaytimeForLocation:incomingLocation];
	if ([[incomingLocation condition] rangeOfString:@"Drizzle"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"Q"] : [incomingLocation setIcon:@"7"];
	} else if ([[incomingLocation condition] rangeOfString:@"Light Rain"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"Q"] : [incomingLocation setIcon:@"7"];
	} else if ([[incomingLocation condition] rangeOfString:@"Rain"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"R"] : [incomingLocation setIcon:@"8"];
	} else if ([[incomingLocation condition] rangeOfString:@"Light Snow"].location != NSNotFound) {
		daytime ?[incomingLocation setIcon:@"U"] : [incomingLocation setIcon:@"\""];
	} else if ([[incomingLocation condition] rangeOfString:@"Snow"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"W"] : [incomingLocation setIcon:@"#"];
	} else if ([[incomingLocation condition] rangeOfString:@"Flurries"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"U"] : [incomingLocation setIcon:@"\""];
	} else if ([[incomingLocation condition] rangeOfString:@"Hail"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"X"] : [incomingLocation setIcon:@"$"];
	} else if ([[incomingLocation condition] rangeOfString:@"Mist"].location != NSNotFound) {
		[incomingLocation setIcon:@"L"];
	} else if ([[incomingLocation condition] rangeOfString:@"Fog"].location != NSNotFound) {
		[incomingLocation setIcon:@"M"];
	} else if ([[incomingLocation condition] rangeOfString:@"Thunderstorms"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"Z"] : [incomingLocation setIcon:@"&"];
	} else if ([[incomingLocation condition] rangeOfString:@"Thunderstorm"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"O"] : [incomingLocation setIcon:@"6"];
	} else if ([[incomingLocation condition] rangeOfString:@"Overcast"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"Y"] : [incomingLocation setIcon:@"%"];
	} else if ([[incomingLocation condition] rangeOfString:@"Haze"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"A"] : [incomingLocation setIcon:@"K"];
	} else if ([[incomingLocation condition] rangeOfString:@"Clear"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"B"] : [incomingLocation setIcon:@"C"];
	} else if ([[incomingLocation condition] rangeOfString:@"Partly Cloudy"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"H"] : [incomingLocation setIcon:@"4"];
	} else if ([[incomingLocation condition] rangeOfString:@"Cloudy"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"N"] : [incomingLocation setIcon:@"5"];
	} else if ([[incomingLocation condition] rangeOfString:@"Clouds"].location != NSNotFound) {
		daytime ? [incomingLocation setIcon:@"N"] : [incomingLocation setIcon:@"5"];
	} else {
		[incomingLocation setIcon:@"?"];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"APILocationIconUpdated" object:self];
}

-(void)parseJSONSearchResults:(NSDictionary *)apiData {
    searchResults = [apiData objectForKey:@"RESULTS"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APISearchDataProcessed" object:self];
}

-(NSArray *)getSearchResults {
    return searchResults;
}

-(NSString *)getCurrentTimeWithTimeZone:(NSString *)incomingTimeZone {
	NSDate *currentDate = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:mm"];
	NSTimeInterval timeZoneSeconds = [[NSTimeZone timeZoneWithAbbreviation:incomingTimeZone] secondsFromGMT];
	NSDate *localDate = [currentDate dateByAddingTimeInterval:timeZoneSeconds];
	
	return [formatter stringFromDate:localDate];
}

-(BOOL)isDaytimeForLocation:(WeatherLocation *)incomingLocation {
	NSString *time = [self getCurrentTimeWithTimeZone:[incomingLocation timeZone]];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:mm"];
	NSDate *sunriseTime = [formatter dateFromString:[incomingLocation sunrise]];
	NSDate *currentTime = [formatter dateFromString:time];
	NSDate *sunsetTime = [formatter dateFromString:[incomingLocation sunset]];
	
	return ([currentTime compare:sunriseTime] == NSOrderedAscending || [currentTime compare:sunsetTime] == NSOrderedDescending) ? NO : YES;
}

@end
