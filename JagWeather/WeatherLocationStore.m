//
//  WeatherLocationStore.m
//  JagWeather
//
//  Created by Bobby Vogel on 3/11/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "WeatherLocationStore.h"
#import "APIManager.h"

@implementation WeatherLocationStore

static WeatherLocationStore *sharedStore = nil;

-(instancetype)init {
    self = [super init];
    
    if (self) {
        allLocations = [[NSMutableArray init] alloc];
    }
    
    return self;
}

+(WeatherLocationStore *)sharedStore {
    
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedStore];
}

-(NSArray *)getAllLocations:(NSMutableArray *)incomingLocations {
    
    if ([allLocations count] == 0) {
        WeatherLocation *loc1 = [[WeatherLocation alloc] initWithCity:@"Indianapolis"
                                                                State:@"IN"
                                                              Country:@"USA"];
        [loc1 setCoordinate:CLLocationCoordinate2DMake(39.7910, -86.1480)];
        [allLocations addObject:loc1];
        
        WeatherLocation *loc2 = [[WeatherLocation alloc] initWithCity:@"San Francisco"
                                                                State:@"CA"
                                                              Country:@"USA"];
        [loc2 setCoordinate:CLLocationCoordinate2DMake(37.7833, -122.4167)];
        [allLocations addObject:loc2];
        
        WeatherLocation *loc3 = [[WeatherLocation alloc] initWithCity:@"Hong Kong"
                                                                State:@""
                                                              Country:@"Hong Kong"];
        [loc3 setCoordinate:CLLocationCoordinate2DMake(22.2783, 114.1747)];
        [allLocations addObject:loc3];
        
        WeatherLocation *loc4 = [[WeatherLocation alloc] initWithCity:@"Rio de Janeiro"
                                                                State:@""
                                                              Country:@"Brazil"];
        [loc4 setCoordinate:CLLocationCoordinate2DMake(-22.9068, -43.1729)];
        [allLocations addObject:loc4];
    }
    
    return allLocations;
}

-(WeatherLocation *)createLocation {
    
    WeatherLocation *newLocation = [[WeatherLocation alloc] init];
    
    [allLocations addObject:newLocation];
    
    return newLocation;
}

@end
