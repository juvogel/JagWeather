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
	
	if ([[context executeFetchRequest:fetchRequest error:&error] count] == 0) {
		[self createLocationFromString:nil Latitude:nil Longitude:nil];
	}
	
	return [context executeFetchRequest:fetchRequest error:&error];
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
	
	// create error object
	NSError *error;
	
	// save the author object
	if (![context save:&error]) {
		NSLog(@"Something appears to have gone awry! Error message: %@", [error localizedDescription]);
	}
}

-(WeatherLocation *)createLocationFromString:(NSString *)incomingString
									Latitude:(NSNumber *)incomingLatitude
								   Longitude:(NSNumber *)incomingLongitude {
	
	WeatherLocation *newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherLocation" inManagedObjectContext:context];
	
	// set properties
	NSArray *locationNameArray = [incomingString componentsSeparatedByString:@", "];
	[newLocation setCity:[locationNameArray objectAtIndex:0]];
	
	// compare second half of string to dictionary of all US States
	NSDictionary *states = @{ @"Alabama": @"AL", @"Alaska" : @"AK", @"Arizona" : @"AZ", @"Arkansas" : @"AR", @"California" : @"CA", @"Colorado" : @"CO", @"Connecticut" : @"CT", @"Delaware" : @"DE", @"Florida" : @"FL", @"Georgia" : @"GA", @"Hawaii" : @"HI", @"Idaho" : @"ID", @"Illinois" : @"IL", @"Indiana" : @"IN", @"Iowa" : @"IA", @"Kansas" : @"KS", @"Kentucky" : @"KY", @"Louisiana" : @"LA", @"Maine" : @"ME", @"Maryland" : @"MD", @"Massachusetts" : @"MA", @"Michigan" : @"MI", @"Minnesota" : @"MN", @"Mississippi" : @"MS", @"Missouri" : @"MO", @"Montana" : @"MT", @"Nebraska" : @"NE", @"Nevada": @"NV", @"New Hampshire" : @"NH", @"New Jersey" : @"NJ", @"New Mexico" : @"NM", @"New York" : @"NY", @"North Carolina" : @"NC", @"North Dakota" : @"ND", @"Ohio" : @"OH", @"Oklahoma" : @"OK", @"Oregon" : @"OR", @"Pennsylvania" : @"PA", @"Rhode Island" : @"RI", @"South Carolina" : @"SC", @"South Dakota" : @"SD", @"Tennessee" : @"TN", @"Texas" : @"TX", @"Utah" : @"UT", @"Vermont" : @"VT", @"Virginia" : @"VA", @"Washington" : @"WA", @"West Virginia" : @"WV", @"Wisconsin" : @"WI", @"Wyoming" : @"WY" };
	
	if ([states objectForKey:[NSString stringWithFormat:@"%@", [locationNameArray objectAtIndex:1]]] != nil) {
		[newLocation setState:[states objectForKey:[locationNameArray objectAtIndex:1]]];
		[newLocation setCountryName:@"USA"];
	} else {
		[newLocation setCountryName:[locationNameArray objectAtIndex:1]];
	}
	
	[newLocation setLatitude:incomingLatitude];
	[newLocation setLongitude:incomingLongitude];
	
	return newLocation;
}

-(void)addLocation:(WeatherLocation *)incomingLocation {
	[context insertObject:incomingLocation];
	
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Something appears to have gone awry! Error message: %@", [error localizedDescription]);
	}
}

-(void)removeLocation:(NSInteger)index {
	
	[context deleteObject:[[self getAllLocations] objectAtIndex:index]];
	
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
