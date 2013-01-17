//
//  TicketController.h
//  EWS
//
//  Created by Jay Chae  on 1/16/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocalNotificationTicket;

@interface TicketController : NSObject

@property (nonatomic, strong) NSMutableArray *tickets;
//@property (nonatomic, retain) NSMutableArray *tickets;

+ (TicketController *) getTickets;
+ (void)initialize;
- (void)sendNotification;
+ (void)addTicket:(LocalNotificationTicket *)ticket;
- (LocalNotificationTicket *)ticketAtIndex:(NSUInteger)index;

@end
