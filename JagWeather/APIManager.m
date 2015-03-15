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
        serviceURL = @"http://api.wunderground.com/api/4009a293c3e11ed0/conditions/q/";
    }
    
    return self;
}


-(void)fetchInfoFromAPI:(CLLocationCoordinate2D)incomingCoordinates {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%f,%f.json", serviceURL, incomingCoordinates.latitude, incomingCoordinates.longitude]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if (connectionInProgress) {
        [connectionInProgress cancel];
    }
    
    connectionInProgress = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    jsonAPIData = [[NSMutableData alloc] init];
}

-(void)populateLocationInfo:(NSMutableData *)incomingData {
    jsonAPIObject = [NSJSONSerialization JSONObjectWithData:incomingData options:0 error:nil];
    
    id currentLocation = [jsonAPIObject objectAtIndex:1];
    
    double thisLatitude = [[currentLocation objectForKey:@"latitude"] doubleValue];
    double thisLongitude = [[currentLocation objectForKey:@"longitude"] doubleValue];
    
    for (WeatherLocation *tempLocation in [[WeatherLocationStore sharedStore] getAllLocations]) {
        if (fabs([tempLocation coordinate].latitude - thisLatitude) <= .01 && fabs([tempLocation coordinate].longitude - thisLongitude) <= .01) {
            [tempLocation setTempF:(int)[currentLocation objectForKey:@"temp_f"]];
        }
    }
    
    //WeatherLocation *tempLocation = [[WeatherLocationStore sharedStore] getAllLocations]
    
    
}

// DELEGATE METHODS FOR NSURLCONNECTION

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [jsonAPIData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self populateLocationInfo:jsonAPIData];
}

@end
