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

#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

#import "EWSDataController.h"
#import "NotificationViewController.h"


static NSString *POST_NOTIFICATION = @"polledUsage";

@interface EWSLabDetailViewController ()

@end

@implementation EWSLabDetailViewController


@synthesize notifyButton, notifyMeActionSheet, labFeaturesSegCtrl, deviceData, refreshButton, lab;
@synthesize iconContainerView, labNameLabel, mapContainerView, screenSizeIcon, platformIcon, dualScreenIcon;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:lab.name];

    [self initRefreshButton];
    [self setTextForLabUsage];
    [self setMapView];

    [labNameLabel setText:lab.name];
    LabMKAnnotation *labAnnotation = [[LabMKAnnotation alloc] initWithCoordinate:self.lab.geoLocation Location:@"Basement"];
    [self.mapView addAnnotation:labAnnotation];
    [self.mapView setCenterCoordinate:self.lab.geoLocation];
    [self addShadowToIconContainerView];
    [self addShadowToMapContainerView];
    [self initViewBackground];
    [self initIcons];
}

- (void)initIcons {
    [platformIcon.layer setMasksToBounds:YES];
    [dualScreenIcon.layer setMasksToBounds:YES];
    [screenSizeIcon.layer setMasksToBounds:YES];
    
    [platformIcon.layer setBorderColor:[UIColor blackColor].CGColor];
    [platformIcon.layer setBorderWidth:2.0f];
    
    [dualScreenIcon.layer setBorderColor:[UIColor blackColor].CGColor];
    [dualScreenIcon.layer setBorderWidth:2.0f];
    
    [screenSizeIcon.layer setBorderColor:[UIColor blackColor].CGColor];
    [screenSizeIcon.layer setBorderWidth:2.0f];
    
    [platformIcon.layer setCornerRadius:5];
    [dualScreenIcon.layer setCornerRadius:5];
    [screenSizeIcon.layer setCornerRadius:5];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViewBackground {
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"solid.png"]]];
}

- (void)addShadowToIconContainerView {
    [iconContainerView.layer setMasksToBounds:NO];
    [iconContainerView.layer setCornerRadius:3];
    [iconContainerView.layer setShadowOffset:CGSizeMake(0, 1)];
    [iconContainerView.layer setShadowRadius:1];
    [iconContainerView.layer setShadowOpacity:0.5];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:iconContainerView.bounds];
    [iconContainerView.layer setShadowPath:path.CGPath];
}

- (void)addShadowToMapContainerView {
    [mapContainerView.layer setMasksToBounds:NO];
    [mapContainerView.layer setCornerRadius:3];
    [mapContainerView.layer setShadowOffset:CGSizeMake(0, 1)];
    [mapContainerView.layer setShadowRadius:1];
    [mapContainerView.layer setShadowOpacity:0.5];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:mapContainerView.bounds];
    [mapContainerView.layer setShadowPath:path.CGPath];
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


-(void) initRefreshButton {
    [refreshButton setTarget:self];
    [refreshButton setAction:@selector(refreshLabUsage:)];
}

-(void) refreshLabUsage:(id) sender {
    [[EWSDataController sharedEWSLabSingleton] pollCurrentLabUsage];
    [self setTextForLabUsage];
}

- (void)registerNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLabUsage:) name:POST_NOTIFICATION object:nil];
}


#pragma mark - MKMapView protocols

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *labPAV = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    return labPAV;
}

@end