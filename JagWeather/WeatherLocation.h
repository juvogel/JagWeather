//
//  WeatherLocation.h
//  JagWeather
//
//  Created by Bobby Vogel on 4/20/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeatherLocation : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * condition;
@property (nonatomic, retain) NSString * countryName;
@property (nonatomic, retain) NSNumber * feelsLike;
@property (nonatomic, retain) NSNumber * high;
@property (nonatomic, retain) NSString * humidity;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * low;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * pressure;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * sunrise;
@property (nonatomic, retain) NSString * sunset;
@property (nonatomic, retain) NSNumber * tempF;
@property (nonatomic, retain) NSString * timeZone;
@property (nonatomic, retain) NSString * wind;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * link;

-(NSString *)fullName;

@end
