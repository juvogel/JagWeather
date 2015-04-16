//
//  WeatherLocationStore.m
//  JagWeather
//
//  Created by Bobby Vogel on 3/11/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "WeatherLocationStore.h"
#import "APIManager.h"
#import <CoreLocation/CoreLocation.h>

@implementation WeatherLocationStore

@synthesize appDelegate, context;

static WeatherLocationStore *sharedStore = nil;

-(instancetype)init {
    self = [super init];
	
	if (self) {
		appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		context = [appDelegate managedObjectContext];
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
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"WeatherLocation" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSError *error;
	
	NSArray *allLocations = [context executeFetchRequest:fetchRequest error:&error];
	
	if ([allLocations count] == 0) {
		[self createLocationFromLatitude:nil Longitude:nil];
	}
	
	return allLocations;
}

-(WeatherLocation *)getWeatherLocationAtIndex:(NSInteger)index {
	return [[self getAllLocations] objectAtIndex:index];
}

-(void)createLocationWithCity:(NSString *)incomingCity
						State:(NSString *)incomingState
					  Country:(NSString *)incomingCountry
					 Latitude:(NSNumber *)incomingLatitude
					Longitude:(NSNumber *)incomingLongitude {
	
	WeatherLocation *newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherLocation" inManagedObjectContext:context];
	
	// set properties
	[newLocation setCity:incomingCity];
	[newLocation setState:incomingState];
	[newLocation setCountryName:incomingCountry];
	[newLocation setLatitude:incomingLatitude];
	[newLocation setLongitude:incomingLongitude];
	
	[self saveLocation];
}

-(WeatherLocation *)createLocationFromLatitude:(NSNumber *)incomingLatitude
								 Longitude:(NSNumber *)incomingLongitude {
	
	WeatherLocation *newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherLocation" inManagedObjectContext:context];
	
	[newLocation setLatitude:incomingLatitude];
	[newLocation setLongitude:incomingLongitude];
	
	// Set location using geolocation from coordinates
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	CLLocation *location = [[CLLocation alloc] initWithLatitude:[incomingLatitude doubleValue] longitude:[incomingLongitude doubleValue]];
	
	[geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
		CLPlacemark *placemark = [placemarks objectAtIndex:0];
		[newLocation setCountryName:placemark.country];
		[newLocation setCity:placemark.name];
		[newLocation setState:placemark.locality];
		[newLocation setPostalCode:placemark.postalCode];
	}];
	
	[self saveLocation];
	
	return newLocation;
}

-(void)addLocation:(WeatherLocation *)incomingLocation {
	[context insertObject:incomingLocation];
	
	[self saveLocation];
}

-(void)removeLocation:(NSInteger)index {
	
	[context deleteObject:[[self getAllLocations] objectAtIndex:index]];
	
	[self saveLocation];
}

-(void)saveLocation {
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Something appears to have gone awry! Error message: %@", [error localizedDescription]);
	}
}

/*
-(void)reorderLocationFromIndex:(NSInteger)fromIndex toIndexPath:(NSInteger)toIndex {
    WeatherLocation *locationBeingMoved = [[self getAllLocations] objectAtIndex:fromIndex];
    [self removeLocation:fromIndex];
    [self addLocation:locationBeingMoved atIndex:toIndex];
}
*/

@end
