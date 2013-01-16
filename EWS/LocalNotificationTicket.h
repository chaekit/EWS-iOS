//
//  LocalNotificationTicket.h
//  EWS
//
//  Created by Jay Chae  on 1/15/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocalNotificationTicket : NSObject

@property (nonatomic, strong) UILocalNotification *notification;

@property (nonatomic, strong) NSString *labName;
@property (nonatomic) NSUInteger requestedLabSize;

@end
