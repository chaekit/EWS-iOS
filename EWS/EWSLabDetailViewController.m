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
@synthesize iconContainerView, labNameLabel;

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

    [self initRefreshButton];
    [self setIcons];
    
    [self.labLocationTip.layer setBorderWidth:1.0f];
    [self.labLocationTip.layer setBorderColor:[UIColor grayColor].CGColor];
    [self setTextForLabUsage];
    
    [self setMapView];

    [labNameLabel setText:lab.name];
    LabMKAnnotation *labAnnotation = [[LabMKAnnotation alloc] initWithCoordinate:self.lab.geoLocation Location:@"Basement"];
    [self.mapView addAnnotation:labAnnotation];
    [self.mapView setCenterCoordinate:self.lab.geoLocation];
    [self.backgroundImageView initWithImage:[UIImage imageNamed:@"paper_fibers.png"]];
    [self addShadowToIconContainerView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViewBackground {
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_fibers.png"]]];
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


#pragma mark - UIActionSheet protocols

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"lol");
    }
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

@end