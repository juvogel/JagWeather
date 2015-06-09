//
//  RadarOverlayRenderer.h
//  JagWeather
//
//  Created by Bobby Vogel on 6/6/15.
//  Copyright (c) 2015 Bobby Vogel. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface RadarOverlayRenderer : MKOverlayRenderer

@property (nonatomic, strong) UIImage *overlayImage;

-(instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;

@end
