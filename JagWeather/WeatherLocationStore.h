//
//  WeatherLocationStore.h
//  JagWeather
//
//  Created by Bobby Vogel on 3/11/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherLocation.h"
#import "AppDelegate.h"

@interface WeatherLocationStore : NSObject

@property (nonatomic) AppDelegate *appDelegate;
@property (nonatomic) NSManagedObjectContext *context;

+(WeatherLocationStore *)sharedStore;

-(NSArray *)getAllLocations;
-(WeatherLocation *)getWeatherLocationAtIndex:(NSInteger)index;
-(void)createLocationWithCity:(NSString *)incomingCity
						state:(NSString *)incomingState
					  country:(NSString *)incomingCountry
					 latitude:(NSNumber *)incomingLatitude
					longitude:(NSNumber *)incomingLongitude;
-(WeatherLocation *)createLocationFromLatitude:(NSNumber *)incomingLatitude
									 longitude:(NSNumber *)incomingLongitude
								  withLink:(NSString *)incomingLink;
-(void)updateLocationInfo:(WeatherLocation *)incomingLocation;
-(void)addLocation:(WeatherLocation *)incomingLocation;
-(void)removeLocation:(NSInteger)index;
-(void)saveLocation;
//-(void)reorderLocationFromIndex:(NSInteger)fromIndex toIndexPath:(NSInteger)toIndex;

@end
