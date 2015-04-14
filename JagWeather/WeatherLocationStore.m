//
//  WeatherLocationStore.m
//  JagWeather
//
//  Created by Bobby Vogel on 3/11/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "WeatherLocationStore.h"
#import "APIManager.h"
#import "AppDelegate.h"

@implementation WeatherLocationStore

@synthesize newLocation;

static WeatherLocationStore *sharedStore = nil;

-(instancetype)init {
    self = [super init];
    
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
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"WeatherLocation" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSError *error;
	
	return [context executeFetchRequest:fetchRequest error:&error];
}

-(void)createLocationWithCity:(NSString *)incomingCity
						State:(NSString *)incomingState
					  Country:(NSString *)incomingCountry
					 Latitude:(NSNumber *)incomingLatitude
					Longitude:(NSNumber *)incomingLongitude {
    
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	
	newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherLocation" inManagedObjectContext:context];
	
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
		NSLog(@"Something appears to have went awry! Error message: %@", [error localizedDescription]);
	}
}

-(void)createLocationFromString:(NSString *)incomingString
					   Latitude:(NSNumber *)incomingLatitude
					  Longitude:(NSNumber *)incomingLongitude {
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	
	newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherLocation" inManagedObjectContext:context];
	
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
}

-(void)removeLocation:(NSInteger)index {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	
	[context deleteObject:[[self getAllLocations] objectAtIndex:index]];
	
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Something appears to have went awry! Error message: %@", [error localizedDescription]);
	}
}

-(void)reorderLocationFromIndex:(NSInteger)fromIndex toIndexPath:(NSInteger)toIndex {
    WeatherLocation *object = [[self getAllLocations] objectAtIndex:fromIndex];
    [self removeLocation:fromIndex];
    [allLocations insertObject:object atIndex:toIndex];
}

@end
