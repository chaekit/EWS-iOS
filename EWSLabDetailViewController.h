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

@interface EWSLabDetailViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>


@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) Lab *lab;

@end
