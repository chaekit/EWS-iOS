//
//  Lab.m
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "Lab.h"
#import <CoreLocation/CoreLocation.h>

@implementation Lab

-(id)initWithName:(NSString *)labName Capacity:(NSUInteger)labCapacity
         Building:(NSString *)buildingName Platform:(NSString *)computerPlatFormName
           LatLng:(NSDictionary *)geoLoc
            LocationTip:(NSString *)locTip
                Index:(NSUInteger)index
{
    self = [super init];
    if (self)
    {
        self.name = labName;
        self.maxCapacity = labCapacity;
        self.currentLabUsage = 0;
        self.buildingName = buildingName;
        self.computerPlatformName = computerPlatFormName;
        
        NSLog(@"geoloc object shit    %@", [geoLoc objectForKey:@"latitude"]);
        NSLog(@"class of this object shit    %@", [[geoLoc objectForKey:@"latitude"] class]);
        self.geoLocation = CLLocationCoordinate2DMake([[geoLoc objectForKey:@"latitude"] doubleValue],
                                                      [[geoLoc objectForKey:@"longitude"] doubleValue]);
        
        self.locationTip = locTip;
        self.indexInPlist = index;
        self.timerSet = NO;
        return self;
    }
    return nil;
}

@end
