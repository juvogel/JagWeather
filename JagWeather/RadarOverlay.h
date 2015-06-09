//
//  RadarOverlay.h
//  JagWeather
//
//  Created by Bobby Vogel on 6/6/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RadarOverlay : NSObject <MKOverlay>

-(instancetype)initWithRegion:(MKCoordinateRegion)region;

@end
