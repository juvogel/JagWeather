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
        allLocations = [[NSMutableArray alloc] init];
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

-(NSArray *)getAllLocations {
    
    if ([allLocations count] == 0) {
        WeatherLocation *location1 = [[WeatherLocation alloc] initWithCity:@"Indianapolis"
                                                                State:@"IN"
                                                              Country:@"USA"];
        [location1 setCoordinate:CLLocationCoordinate2DMake(39.7910, -86.1480)];
        [allLocations addObject:location1];
        
        WeatherLocation *location2 = [[WeatherLocation alloc] initWithCity:@"San Francisco"
                                                                State:@"CA"
                                                              Country:@"USA"];
        [location2 setCoordinate:CLLocationCoordinate2DMake(37.7833, -122.4167)];
        [allLocations addObject:location2];
        
        WeatherLocation *location3 = [[WeatherLocation alloc] initWithCity:@"Hong Kong"
                                                                State:@""
                                                              Country:@"Hong Kong"];
        [location3 setCoordinate:CLLocationCoordinate2DMake(39.6396194, -86.1446483)];
        [allLocations addObject:location3];
    }
    
    return allLocations;
}

-(WeatherLocation *)createLocation {
    
    WeatherLocation *newLocation = [[WeatherLocation alloc] init];
    
    [allLocations addObject:newLocation];
    
    return newLocation;
}

-(void)addLocation:(WeatherLocation *)newLocation {
    [allLocations addObject:newLocation];
}

-(void)removeLocation:(NSInteger)index {
    [allLocations removeObjectAtIndex:index];
}

-(void)reorderLocationFromIndex:(NSInteger)fromIndex toIndexPath:(NSInteger)toIndex {
    WeatherLocation *object = [allLocations objectAtIndex:fromIndex];
    [allLocations removeObject:[allLocations objectAtIndex:fromIndex]];
    [allLocations insertObject:object atIndex:toIndex];
}

@end
