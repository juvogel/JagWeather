//
//  APIManager.h
//  JagWeather
//
//  Created by Bobby Vogel on 3/11/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WeatherLocation.h"

@interface APIManager : NSObject {
    NSString *weatherAPIURL;
    NSMutableData *jsonAPIData;
    NSArray *searchResults;
	UIImage *radar;
}

@property (nonatomic, strong) NSURLSession *session;

+(APIManager *)sharedManager;

-(void)fetchWeatherForLocation:(WeatherLocation *)incomingLocation informationType:(NSString *)keyword;
-(void)fetchRadar:(MKCoordinateRegion)region;
-(UIImage *)getRadar;
-(void)fetchJSONFromAPI:(NSURL *)url withLocation:(WeatherLocation *)incomingLocation;
-(void)parseJSON:(NSDictionary *)locationAPIData withLocation:(WeatherLocation *)incomingLocation;
-(void)fetchLocationsFromAPI:(NSString *)searchString;
-(void)parseJSONSearchResults:(NSDictionary *)apiData;
-(NSArray *)getSearchResults;
-(NSString *)getCurrentTimeWithTimeZone:(NSString *)incomingTimeZone;
-(BOOL)isDaytimeForLocation:(WeatherLocation *)incomingLocation;

@end
