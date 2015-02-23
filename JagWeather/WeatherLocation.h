//
//  WeatherLocation.h
//  JagWeather
//
//  Created by Bobby Vogel on 2/9/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WeatherLocation : NSObject

@property (nonatomic)NSString *postalCode;
@property (nonatomic)NSString *countryName;
@property (nonatomic)NSString *state;
@property (nonatomic)NSString *city;
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic)int tempF;
@property (nonatomic)NSString *weather;
@property (nonatomic)NSString *icon;
@property (nonatomic)int high;
@property (nonatomic)int low;
@property (nonatomic)int relativeHumidity;
@property (nonatomic)NSString *wind;

-(instancetype)initWithCity:strCity
                      State:strState
                    Country:strCountryName;

-(NSString *)fullName;

@end
