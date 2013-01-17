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

@interface NotificationViewController ()

@property NSUInteger requestedOpenLabSize;
@end


@implementation NotificationViewController

@synthesize closeButton, datePicker, lab, requestedOpenLabSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCloseButton];
    
    //initial segemented control value is 5
    requestedOpenLabSize = 5;
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



- (IBAction) addNotification:(id)sender {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //[notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:[datePicker countDownDuration]]];
    [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:8]];
    [notification setAlertBody:@"wtf"];

    LocalNotificationTicket *ticket = [[LocalNotificationTicket alloc] init];
    [ticket setLabName:lab.name];
    [ticket setRequestedLabSize:requestedOpenLabSize];
    [ticket setNotification:notification];
    [ticket setLabIndex:lab.indexInPlist];

    [TicketController addTicket:ticket];
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    NSLog(@"notification   %f", [datePicker countDownDuration]);
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
@end
