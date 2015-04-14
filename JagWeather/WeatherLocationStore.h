//
//  WeatherLocationStore.h
//  JagWeather
//
//  Created by Bobby Vogel on 3/11/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherLocation.h"

@interface WeatherLocationStore : NSObject

@property (nonatomic) WeatherLocation *newLocation;

+(WeatherLocationStore *)sharedStore;

-(NSArray *)getAllLocations;
-(WeatherLocation *)getWeatherLocationAtIndex:(NSInteger)index;
-(void)createLocationWithCity:(NSString *)incomingCity
						State:(NSString *)incomingState
					  Country:(NSString *)incomingCountry
					 Latitude:(NSNumber *)incomingLatitude
					Longitude:(NSNumber *)incomingLongitude;
-(void)createLocationFromString:(NSString *)incomingString
					   Latitude:(NSNumber *)incomingLatitude
					  Longitude:(NSNumber *)incomingLongitude;
-(void)removeLocation:(NSInteger)index;
-(void)reorderLocationFromIndex:(NSInteger)fromIndex toIndexPath:(NSInteger)toIndex;

@end
