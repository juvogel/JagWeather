//
//  APIManager.h
//  JagWeather
//
//  Created by Bobby Vogel on 3/11/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherLocation.h"

@interface APIManager : NSObject {
    NSString *weatherAPIURL;
    NSMutableData *jsonAPIData;
    NSDictionary *locationAPIData;
    id jsonAPIObject;
}

@property (nonatomic, strong) NSURLSession *session;

+(APIManager *)sharedManager;

-(void)fetchWeatherConditions:(WeatherLocation *)incomingLocation;
-(void)fetchWeatherForecast:(WeatherLocation *)incomingLocation;
-(void)fetchJSONFromAPI:(NSURL *)url location:(WeatherLocation *)incomingLocation;
-(void)parseJSON:(WeatherLocation *)incomingLocation;

@end
