//
//  EWSLabDetailViewController.m
//  EWS
//
//  Created by Jay Chae  on 12/29/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSLabDetailViewController.h"
#import "LabMKAnnotation.h"
#import "Lab.h"
#import "EWSDetailLabMapViewController.h"

//#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

#import <QuartzCore/QuartzCore.h>

#import "EWSDataController.h"
#import "NotificationViewController.h"
@interface EWSLabDetailViewController ()

@end

@implementation EWSLabDetailViewController


@synthesize notifyButton, notifyMeActionSheet, labFeaturesSegCtrl, deviceData, refreshButton, lab;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:self.lab.name];

    [self setNotifyButton];
    [self setNotifyMeActionSheet];
    [self initRefreshButton];
    [self setIcons];
    
    [self.labLocationTip.layer setBorderWidth:1.0f];
    [self.labLocationTip.layer setBorderColor:[UIColor grayColor].CGColor];
    [self setTextForLabUsage];
    
    [self setMapView];

    LabMKAnnotation *labAnnotation = [[LabMKAnnotation alloc] initWithCoordinate:self.lab.geoLocation Location:@"Basement"];
    [self.mapView addAnnotation:labAnnotation];
    [self.mapView setCenterCoordinate:self.lab.geoLocation];
}

-(void) viewDidAppear {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) handleTapOnMap {
    [self performSegueWithIdentifier:@"ShowDetailMapView" sender:self];
}

- (void)initNotfiyButton {
    if (lab.timerSet) {
        [notifyButton setBackgroundColor:[UIColor redColor]];
        [notifyButton setTitle:@"Cancel Notification" forState:UIControlStateNormal];
    }
}

#pragma Segue Controller

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"ShowDetailMapView"]) {
        EWSDetailLabMapViewController  *detailMapViewController = [segue destinationViewController];
        [detailMapViewController setMapCenter:self.lab.geoLocation];
        [detailMapViewController setTitle:self.lab.name];
    } else if ([segueIdentifier isEqualToString:@"ShowNotificationView"]) {
        NotificationViewController *notificationController = [segue destinationViewController];
        [notificationController setLab:self.lab];
    }
    
//    else if ([segueIdentifier isEqualToString:@"SetNotification"]) {
//    }
}

-(void) setMapView {
    [self.mapView setScrollEnabled:NO];
    [self.mapView setZoomEnabled:NO];
    MKCoordinateSpan regionForMap = MKCoordinateSpanMake(0.0015f, 0.00010f);
    [self.mapView setRegion:MKCoordinateRegionMake(self.lab.geoLocation, regionForMap)];
    
    UITapGestureRecognizer *mapTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnMap)];
    [mapTapRecognizer setDelegate:self];
    [self.mapView addGestureRecognizer:mapTapRecognizer];
    
    [self.labLocationTip setText:self.lab.locationTip];
}

-(void) setTextForLabUsage {
    NSString *labUsageString = [NSString stringWithFormat:@"%d/%d", self.lab.currentLabUsage, self.lab.maxCapacity];
    [self.labUsageLabel setText:labUsageString];
    [self.labUsageLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.labUsageLabel.layer setBorderWidth:2.0];
}

-(void) setNotifyButton {
    //[notifyButton addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.notifyButton.layer.borderWidth = 0.5f;
//    self.notifyButton.layer.cornerRadius = 10.0f;
}


-(void) initRefreshButton {
    [refreshButton setTarget:self];
    [refreshButton setAction:@selector(refreshLabUsage:)];
}

-(void) refreshLabUsage:(id) sender {
    [[EWSDataController sharedEWSLabSingleton] pollCurrentLabUsage];
    [self setTextForLabUsage];
}

#pragma mark - UIActionSheet protocols

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"lol");
    }
}

-(void) setNotifyMeActionSheet {
    notifyMeActionSheet = [[UIActionSheet alloc] initWithTitle:@"Notify me when there are ..." delegate:self
                                             cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"1 to 5", nil];
}

-(void) showActionSheet:(id)sender {
    [notifyMeActionSheet showInView:self.view];
}

-(void) setIcons {
    UIImage *platformIcon = [UIImage imageNamed:@"detail_tux.png"];
    UIImage *windowIcon = [UIImage imageNamed:@"windowsIcon.png"];
    UIImage *dualScreenIcon = [UIImage imageNamed:@"dual_screen_icon.png"];
    [labFeaturesSegCtrl setImage:platformIcon forSegmentAtIndex:0];
    [labFeaturesSegCtrl setImage:windowIcon forSegmentAtIndex:1];
    [labFeaturesSegCtrl setImage:dualScreenIcon forSegmentAtIndex:2];
}


#pragma mark - MKMapView protocols

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *labPAV = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    return labPAV;
}


-(void)postNotifyRequest {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	progressHud.labelText = @"Sending";
    
	NSURL* url = [NSURL URLWithString:@"http://localhost:8080"];
  
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  
    [request startSynchronous];
    

    [request setCompletionBlock:^ {
        NSLog(@"lol");
    }];
    [request setFailedBlock:^ {
        NSLog(@"lol");
    }];
}

 
@end