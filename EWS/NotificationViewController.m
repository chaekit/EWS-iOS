//
//  NotificationViewController.m
//  EWS
//
//  Created by Jay Chae  on 1/15/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import "NotificationViewController.h"
#import "EWSCustomLocalNotification.h"
#import "Lab.h"
#import "EWSDataController.h"

#import "LocalNotificationTicket.h"
#import "TicketController.h"


#define VALID_NOTIFICATION 0
#define HAS_ENOUGH_STATIONS 1
#define DID_NOT_SET_TIMER 2

@interface NotificationViewController ()

@property NSUInteger requestedOpenLabSize;
@property (nonatomic, strong) UIAlertView *noSetTimerAlert;
@property (nonatomic, strong) UIAlertView *enoughStationAlert;

@property NSTimeInterval countDown;

@end

@implementation NotificationViewController

@synthesize closeButton, datePicker, lab, requestedOpenLabSize, cancelButton, alertTimeNavigationItem;
@synthesize openLabSizeSegCtrl, noSetTimerAlert, enoughStationAlert, countDown;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCloseButton];
    
    noSetTimerAlert = [[UIAlertView alloc] initWithTitle:@"Timer Not Set"
                                                        message:@"Forgot to set the timer"
                                                           delegate:nil
                                                              cancelButtonTitle:@"Wow ok. Thanks"
                                                                  otherButtonTitles:nil];
    
    enoughStationAlert = [[UIAlertView alloc] initWithTitle:@"Open Stations"
                                                    message:@"There are already enough open stations."
                                                       delegate:nil
                                                          cancelButtonTitle:@"Wow ok. Thanks"
                                                              otherButtonTitles:nil];
//initial segemented control value is 5
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initCloseButton {
    [closeButton setTitle:@"Close"];
    [closeButton setAction:@selector(closeNotificaitonView)];
}


- (void) closeNotificaitonView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setTimerAlertLabelWithCountdown:(NSString *)countDown {
    
}

- (void)initOpenLabSizeSegCtrl {
    [openLabSizeSegCtrl setSelectedSegmentIndex:0];
}

- (NSString *)getConvertedCountdownInString:(NSTimeInterval)time {
    int timeInInteger = (int) rint(time);
    if ((timeInInteger%100 - 60) == 0) {
        timeInInteger -= 60;
    }
    
    int hours = timeInInteger / 3600;
    int minutes = (timeInInteger % 3600) / 60;
    return [NSString stringWithFormat:@"In: %d hours, %d minutes", hours, minutes];
}

- (NSUInteger)getConvertedCountdownInMinutes:(NSTimeInterval)time {
    int timeInInteger = (int) rint(time);
    if ((timeInInteger%100 - 60) == 0) {
        timeInInteger -= 60;
    }
  
    return timeInInteger / 60;
}


- (int)notificationIsValid {
    if (((int)[datePicker countDownDuration]) - 60 == 0)
        return DID_NOT_SET_TIMER;
    
    NSUInteger numOpenstations = lab.maxCapacity - lab.currentLabUsage;
    if (numOpenstations >= requestedOpenLabSize)
        return HAS_ENOUGH_STATIONS;

    return VALID_NOTIFICATION;
}

- (IBAction)addNotification:(id)sender {
    int validation = [self notificationIsValid];
    if (validation == VALID_NOTIFICATION) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        LocalNotificationTicket *ticket = [[LocalNotificationTicket alloc] initWithName:lab.name
                                                Size:requestedOpenLabSize Notification:notification
                                                    IndexPath:lab.indexInPlist
                                                        Timer:[self getConvertedCountdownInString:[self getConvertedCountdownInMinutes:self.countDown]]];

        [TicketController addTicket:ticket];
        [self closeNotificaitonView];
    } else if (validation == DID_NOT_SET_TIMER) {
        [noSetTimerAlert show];
    } else if (validation == HAS_ENOUGH_STATIONS) {
        [enoughStationAlert show];
    } else {
        NSLog(@"WTF?");
    }
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segementControl = (UISegmentedControl *) sender;
    NSUInteger selectedSegment = segementControl.selectedSegmentIndex;

    /* selected the first one which is 5 */
    if (selectedSegment == 0) {
        requestedOpenLabSize = 5;
    } else if (selectedSegment == 1)  {
        requestedOpenLabSize = 10;
    }
    NSLog(@"Segment is set  %d", requestedOpenLabSize);
}

- (IBAction)cancelNotification:(id)sender {
    [self closeNotificaitonView];
}

- (IBAction)setTimer:(UIDatePicker *)sender {
    NSTimeInterval countDownFromTicker = [sender countDownDuration];
    [alertTimeNavigationItem setTitle:[self getConvertedCountdownInString:countDownFromTicker]];
    self.countDown = [self getConvertedCountdownInMinutes:countDownFromTicker];
}
@end
