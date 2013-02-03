//
//  LocalNotificationTicket.m
//  EWS
//
//  Created by Jay Chae  on 1/15/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import "LocalNotificationTicket.h"
#import "EWSDataController.h"

@interface LocalNotificationTicket()


@property (nonatomic, strong) NSTimer *pollUsageTimer;

@end

@implementation LocalNotificationTicket

@synthesize pollUsageTimer, labTimer;

- (id)initWithName:(NSString *)labName Size:(NSUInteger)requestedSize
      Notification:(UILocalNotification *)notification IndexPath:(NSUInteger)index
            Timer:(int)timer {

    self = [super init];
    if (self) {
        self.labName = labName;
        self.requestedLabSize = requestedSize;
        self.notification = notification;
        self.labIndex = index;
        self.labTimer = timer;
        return self;
    }
    return nil;
}


- (void)startTimer {
    pollUsageTimer = [NSTimer scheduledTimerWithTimeInterval:(labTimer * 60) target:self selector:@selector(pollCurrentLabUsage) userInfo:nil repeats:YES];
}

- (void)pollCurrentLabUsage {
    [[EWSDataController sharedEWSLabSingleton] pollCurrentLabUsage];
}


@end
