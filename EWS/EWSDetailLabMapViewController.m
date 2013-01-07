//
//  EWSDetailLabMapViewController.m
//  EWS
//
//  Created by Jay Chae  on 12/30/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSDetailLabMapViewController.h"
#import "LabMKAnnotation.h"
#import <MapKit/MapKit.h>

@implementation EWSDetailLabMapViewController

@synthesize detailMapView, closeButton, mapCenter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    [self setMapView];
    [self setLabAnnotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setMapView {
    [detailMapView setScrollEnabled:YES];
    [detailMapView setZoomEnabled:YES];
    MKCoordinateSpan regionForMap = MKCoordinateSpanMake(0.003f, 0.00020f);
    [detailMapView setRegion:MKCoordinateRegionMake(mapCenter, regionForMap)];
    [closeButton setAction:@selector(closeMapView)];
}

-(void) closeMapView {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) setLabAnnotation {
    LabMKAnnotation *labAnnotation = [[LabMKAnnotation alloc] initWithCoordinate:mapCenter Location:@"Basement"];
    [detailMapView addAnnotation:labAnnotation];
    [detailMapView setCenterCoordinate:mapCenter];
}


#pragma mark - MKMapViewDelegate protocols

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *labPAV = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    //labPAV.enabled = YES;
    return labPAV;
}
@end
