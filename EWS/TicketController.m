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

static NSString *POST_NOTIFICATION = @"polledUsage";

@interface TicketController()

- (void)startTimer;
- (void)endTimer;

@property (nonatomic, strong) NSTimer *pollUsageTimer;
@property (nonatomic) NSUInteger ticketCounter;
@property (nonatomic, strong) NSMutableArray *tickets;

@end

@implementation TicketController

@synthesize tickets, pollUsageTimer, ticketCounter;

static TicketController *sharedTicketControllerInstance = nil;

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
        ticketCounter = 0;
        [self registerNotificationCenter];
        return self;
    }
    return nil;
}


//Add ASSERT FOR OPTIMIZATION
- (void)sendNotificationWithTicket:(LocalNotificationTicket *)ticket {
    // send notification
    [[UIApplication sharedApplication] scheduleLocalNotification:ticket.notification];
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
}

- (void)endTimer {
    [pollUsageTimer invalidate];
}

- (void)pollCurrentLabUsage:(id)sender {
    [[EWSDataController sharedEWSLabSingleton] pollCurrentLabUsage];
}

- (void)checkTickets {
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
                [sharedTicketControllerInstance.tickets replaceObjectAtIndex:i withObject:[NSNull null]];
                ticketCounter--;
            }
        }
    }
}

+ (void)addTicket:(LocalNotificationTicket *)ticket {
    if (sharedTicketControllerInstance) {
        if ([[sharedTicketControllerInstance.tickets objectAtIndex:ticket.labIndex] isEqual:[NSNull null]]) {
            // starts the timer for the ticket and add it the controller
            [ticket startTimer];
            [sharedTicketControllerInstance.tickets replaceObjectAtIndex:ticket.labIndex withObject:ticket];
        } else {
            NSLog(@"There are other shit in here");
        }
    }
}

- (void)registerNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTickets) name:POST_NOTIFICATION object:nil];
}

@end