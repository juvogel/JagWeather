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

@property (nonatomic) NSString *postalCode;
@property (nonatomic) NSString *countryName;
@property (nonatomic) NSString *state;
@property (nonatomic) NSString *city;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSInteger tempF;
@property (nonatomic) NSString *condition;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSInteger high;
@property (nonatomic) NSInteger low;
@property (nonatomic) NSString *humidity;
@property (nonatomic) NSString *wind;
@property (nonatomic) NSString *pressure;
@property (nonatomic) NSInteger feelsLike;

-(instancetype)initWithCity:strCity
                      State:strState
                    Country:strCountryName;

-(NSString *)fullName;

@end
