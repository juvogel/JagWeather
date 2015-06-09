//
//  RadarOverlay.m
//  JagWeather
//
//  Created by Bobby Vogel on 6/6/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "RadarOverlay.h"

@implementation RadarOverlay

@synthesize coordinate, boundingMapRect;

-(instancetype)initWithRegion:(MKCoordinateRegion)region {
	self = [super init];
	if (self) {
		MKMapPoint a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
																		  region.center.latitude + region.span.latitudeDelta / 2,
																		  region.center.longitude - region.span.longitudeDelta / 2));
		MKMapPoint b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
																		  region.center.latitude - region.span.latitudeDelta / 2,
																		  region.center.longitude + region.span.longitudeDelta / 2));
		boundingMapRect =  MKMapRectMake(MIN(a.x,b.x), MIN(a.y,b.y), ABS(a.x-b.x), ABS(a.y-b.y));
		coordinate = region.center;
	}
	return self;
}

@end
