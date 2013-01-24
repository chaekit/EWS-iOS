//
//  EWSCustomLocalNotification.m
//  EWS
//
//  Created by Jay Chae  on 1/15/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import "EWSCustomLocalNotification.h"

@interface EWSCustomLocalNotification()

@end

@implementation EWSCustomLocalNotification

@synthesize labName, requestedOpenStations, labIndex;

- (id)init {
    self = [super init];
    if (self) {
        self.labName = @"TWTW";
        self.requestedOpenStations = 12;
    }
    return self;
}
@end
