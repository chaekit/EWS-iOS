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
    EWSCustomLocalNotification *notification = [[EWSCustomLocalNotification alloc] init];
    NSLog(@"notification before  %@",[notification class]);
    [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:[datePicker countDownDuration]]];
    [notification setAlertBody:@"wtf"];

    NSLog(@"class this shit %@", [notification class]);
    NSLog(@"class this shit %@", [[EWSDataController sharedEWSLabSingleton] class]);
    [notification setLabName:lab.name];
    //notification.labName = lab.name;
    NSLog(@"size is set      %d", requestedOpenLabSize);
    [notification setRequestedOpenStations:requestedOpenLabSize];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
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
