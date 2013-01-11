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

@interface EWSLabDetailViewController ()

@end

@implementation EWSLabDetailViewController


@synthesize notifyButton, notifyMeActionSheet, labFeaturesSegCtrl, deviceData;

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
   
    [self setIcons];
    
    [self.labLocationTip.layer setBorderWidth:1.0f];
    [self.labLocationTip.layer setBorderColor:[UIColor grayColor].CGColor];
    [self setTextForLabUsage];
    
    [self setMapView];

    LabMKAnnotation *labAnnotation = [[LabMKAnnotation alloc] initWithCoordinate:self.lab.geoLocation Location:@"Basement"];
    [self.mapView addAnnotation:labAnnotation];
    [self.mapView setCenterCoordinate:self.lab.geoLocation];
    
    NSLog(@"annotation    %f", labAnnotation.coordinate.latitude );
    NSLog(@"annotation    %f", labAnnotation.coordinate.longitude );
    //    BackButton shit
//    UIBarButtonItem *backbutton =  [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:nil action:nil];
//    
//    [backbutton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                        [UIColor blackColor],UITextAttributeTextColor,[UIFont fontWithName:@"Monaco" size:16.0f],UITextAttributeFont,
//                                        nil] forState:UIControlStateNormal];
//    
//    self.navigationController.navigationItem.backBarButtonItem = backbutton;

	// Do any additional setup after loading the view.
}

-(void) viewDidAppear {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) handleTapOnMap {
    [self performSegueWithIdentifier:@"ShowDetailMapView" sender:self];
}


#pragma Segue Controller

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"ShowDetailMapView"]) {
        EWSDetailLabMapViewController  *detailMapViewController = [segue destinationViewController];
        [detailMapViewController setMapCenter:self.lab.geoLocation];
        [detailMapViewController setTitle:self.lab.name];
    }
    
//    else if ([segueIdentifier isEqualToString:@"SetNotification"]) {
//        NotificationViewController *notificationController = [segue destinationViewController];
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
    [notifyButton addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.notifyButton.layer.borderWidth = 0.5f;
//    self.notifyButton.layer.cornerRadius = 10.0f;
}




-(void) setIcons {
    UIImage *platformIcon = [UIImage imageNamed:@"detail_tux.png"];
    UIImage *windowIcon = [UIImage imageNamed:@"windowsIcon.png"];
    UIImage *dualScreenIcon = [UIImage imageNamed:@"dual_screen_icon.png"];
    [labFeaturesSegCtrl setImage:platformIcon forSegmentAtIndex:1];
    [labFeaturesSegCtrl setImage:windowIcon forSegmentAtIndex:0];
    [labFeaturesSegCtrl setImage:dualScreenIcon forSegmentAtIndex:2];
}


#pragma mark - MKMapView protocols

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *labPAV = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    return labPAV;
}

 
@end