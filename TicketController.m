//
//  TicketController.m
//  EWS
//
//  Created by Jay Chae  on 1/16/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import "TicketController.h"
#import "LocalNotificationTicket.h"
#import "EWSDataController.h"
#import "Lab.h"

#define TICKET_ARRAY_SIZE 13

@interface TicketController()

- (void)startTimer;
- (void)endTimer;

@property (nonatomic, strong) NSTimer *pollUsageTimer;

@end

@implementation TicketController

@synthesize tickets, pollUsageTimer;

static TicketController *sharedTicketControllerInstance = nil;
static int ticketCounter = 0;

+ (void)initialize {
    @synchronized(self) {
        if (!sharedTicketControllerInstance) {
            sharedTicketControllerInstance = [[TicketController alloc] init];
            NSLog(@"ticketcontroller   %@", sharedTicketControllerInstance.tickets);
        }
    }
}

- (id)init {
    self = [super init];
    if (self) {
        tickets = [[NSMutableArray alloc] initWithCapacity:TICKET_ARRAY_SIZE];
        for (int i = 0; i < TICKET_ARRAY_SIZE; i ++) {
            [tickets insertObject:[NSNull null] atIndex:i];
        }
        return self;
    }
    return nil;
}


//Add ASSERT FOR OPTIMIZATION
- (void)sendNotificationWithTicket:(LocalNotificationTicket *)ticket {
    // send notification
    
    [[UIApplication sharedApplication] scheduleLocalNotification:ticket.notification];
    //[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification.notification];
    if ([sharedTicketControllerInstance.tickets count] == 0) {
        [sharedTicketControllerInstance endTimer];
        NSLog(@"timer ended bitch");
    }
}

- (void)startTimer {
    //poll usage
    [[EWSDataController sharedEWSLabSingleton] pollCurrentLabUsage];
    [sharedTicketControllerInstance checkTickets];
    pollUsageTimer = [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(pollCurrentLabUsage:) userInfo:nil repeats:YES];
    //[sharedTicketControllerInstance sendNotification];
}

- (void)endTimer {
    [pollUsageTimer invalidate];
}

- (void)pollCurrentLabUsage:(id)sender {
    [[EWSDataController sharedEWSLabSingleton] pollCurrentLabUsage];
//    [sharedTicketControllerInstance checkTickets];
}

- (void)checkTickets {
    NSLog(@"size of array  %d", [sharedTicketControllerInstance.tickets count]);
    for (int i = 0; i < TICKET_ARRAY_SIZE; i++) {
        NSLog(@"index of the array  %d", i);
        if ( ![[sharedTicketControllerInstance.tickets objectAtIndex:i] isEqual:[NSNull null]] ) {
            LocalNotificationTicket *ticket = [sharedTicketControllerInstance.tickets objectAtIndex:i];
            Lab *lab = [[EWSDataController sharedEWSLabSingleton] objectAtIndex:i];
            NSUInteger numOpenStations = lab.maxCapacity - lab.currentLabUsage;
           
            NSLog(@"Not Null");
            if (ticket.requestedLabSize <= numOpenStations) {
                NSLog(@"ticket matches at index   %d", i);
                [sharedTicketControllerInstance sendNotificationWithTicket:ticket];
                //[sharedTicketControllerInstance.tickets removeObjectAtIndex:i];
                [sharedTicketControllerInstance.tickets replaceObjectAtIndex:i withObject:[NSNull null]];
                ticketCounter--;
            }
        }
    }
    
}

+ (void)addTicket:(LocalNotificationTicket *)ticket {
    if (sharedTicketControllerInstance) {
        NSLog(@"inside addTicket");
        if ([[sharedTicketControllerInstance.tickets objectAtIndex:ticket.labIndex] isEqual:[NSNull null]]) {
            
            Lab *lab = [[EWSDataController sharedEWSLabSingleton] objectAtIndex:ticket.labIndex];
            NSUInteger numOpenstations = lab.maxCapacity - lab.currentLabUsage;
           
            if (numOpenstations >= ticket.requestedLabSize) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open Stations"
                                                                message:@"There are already enough open stations."
                                                                   delegate:nil
                                                                      cancelButtonTitle:@"Wow ok. Thanks"
                                                                          otherButtonTitles:nil];
                [alert show];
                
            } else {
                [sharedTicketControllerInstance.tickets replaceObjectAtIndex:ticket.labIndex withObject:ticket];
                ticketCounter++;
                // change 0 to 1 if necessary in the future
                if (ticketCounter == 1) {
                    [sharedTicketControllerInstance startTimer];
                }
                NSLog(@"lab index bro   %d",ticket.labIndex);
            }
        } else {
            NSLog(@"There are other shit in here");
        }
    }
}

@end