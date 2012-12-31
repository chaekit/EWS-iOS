//
//  EWSDetailLabMapViewController.h
//  EWS
//
//  Created by Jay Chae  on 12/30/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface EWSDetailLabMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *detailMapView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *closeButton;

@property (nonatomic) CLLocationCoordinate2D mapCenter;
@property (nonatomic) MKCoordinateSpan mapSpan;

@end
