//
//  EWSCustomLocalNotification.h
//  EWS
//
//  Created by Jay Chae  on 1/15/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EWSCustomLocalNotification : UILocalNotification {
    NSString *labName;
    NSUInteger requestedOpenStations;
    NSUInteger labIndex;
}

@property (nonatomic, retain) NSString *labName;
@property (nonatomic) NSUInteger requestedOpenStations;
@property (nonatomic) NSUInteger labIndex;

@end
