//
//  WeatherLocationStore.h
//  JagWeather
//
//  Created by Bobby Vogel on 3/11/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherLocation.h"

@interface WeatherLocationStore : NSObject {
    NSMutableArray *allLocations;
}

+(WeatherLocationStore *)sharedStore;

-(NSArray *)getAllLocations;
-(WeatherLocation *)createLocation;

@end
