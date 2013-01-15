//
//  NotificationViewController.h
//  EWS
//
//  Created by Jay Chae  on 1/15/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Lab;

@interface NotificationViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIDatePicker *notificationTimePicker;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *closeButton;

@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *setButton;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
//@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, strong) Lab *lab;

@end
