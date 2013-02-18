//
//  LabMKAnnotation.h
//  EWS
//
//  Created by Jay Chae  on 12/29/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface LabMKAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *locationInBuilding;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coord Location:(NSString *)location;
    
@end
