//
//  EWSLabDetailViewController.h
//  EWS
//
//  Created by Jay Chae  on 12/29/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class Lab;
@class DeviceDataModel;

@interface EWSLabDetailViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate,
                                                            UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UILabel *labLocationTip;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *closeButton;
@property (nonatomic, strong) IBOutlet UILabel *labUsageLabel;
@property (nonatomic, strong) IBOutlet UIButton *notifyButton;
@property (nonatomic, strong) IBOutlet UISegmentedControl *labFeaturesSegCtrl;

@property (nonatomic, strong) UIActionSheet *notifyMeActionSheet;

-(IBAction) closeDetailMapView:(id)sender;

@property (nonatomic, strong) Lab *lab;
@property (nonatomic, strong) DeviceDataModel *deviceData;

@end
