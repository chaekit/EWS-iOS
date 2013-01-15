//
//  LabUsageTrackerController.m
//  EWS
//
//  Created by Jay Chae  on 1/15/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import "LabUsageTrackerController.h"
#import "EWSDataController.h"

@interface LabUsageTrackerController()

- (void)pollUsage:(id)sender;

@end

@implementation LabUsageTrackerController

@synthesize dataController;

+ (void) initialize {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
    }
}

+ (void)checkUsageEvery5min {
    [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(pollUsage:) userInfo:nil repeats:YES];
}

- (void)pollUsage:(id)sender {
    
}

@end
