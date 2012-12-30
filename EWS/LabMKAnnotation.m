//
//  LabMKAnnotation.m
//  EWS
//
//  Created by Jay Chae  on 12/29/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "LabMKAnnotation.h"
#import <CoreLocation/CoreLocation.h>

@implementation LabMKAnnotation

@synthesize coordinate, locationInBuilding;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coord Location:(NSString *)location {
    if (self  = [super init]) {
        coordinate = CLLocationCoordinate2DMake(coord.latitude, coord.longitude);
        locationInBuilding = location;
    }
    return self;
}

@end
