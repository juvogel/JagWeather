//
//  APIManager.h
//  JagWeather
//
//  Created by Bobby Vogel on 3/11/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface APIManager : NSObject {
    NSString *serviceURL;
    NSURLConnection *connectionInProgress;
    NSMutableData *jsonAPIData;
    id jsonAPIObject;
}

+(APIManager *)sharedManager;

-(void)fetchInfoFromAPI:(CLLocationCoordinate2D)incomingCoordinates;
-(void)populateLocationInfo:(NSMutableData *)incomingData;

@end
