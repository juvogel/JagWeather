//
//  RadarOverlayRenderer.m
//  JagWeather
//
//  Created by Bobby Vogel on 6/6/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import "RadarOverlayRenderer.h"

@implementation RadarOverlayRenderer

-(instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage {
	self = [super initWithOverlay:overlay];
	if (self) {
		_overlayImage = overlayImage;
	}
	
	return self;
}

-(void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
	MKMapRect theMapRect = [[self overlay] boundingMapRect];
	CGRect rect = [self rectForMapRect:theMapRect];
	UIGraphicsPushContext(context);
	[self.overlayImage drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
	UIGraphicsPopContext();
}

@end
