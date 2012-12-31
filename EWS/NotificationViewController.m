//
//  NotificationViewController.m
//  EWS
//
//  Created by Jay Chae  on 12/30/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController


@synthesize closeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCloseButton];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
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

@end
