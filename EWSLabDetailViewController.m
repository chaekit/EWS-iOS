//
//  EWSLabDetailViewController.m
//  EWS
//
//  Created by Jay Chae  on 12/29/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSLabDetailViewController.h"
#import "LabMKAnnotation.h"

@interface EWSLabDetailViewController ()

@end

@implementation EWSLabDetailViewController

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
    

    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 40.1164;
    coordinate.longitude = 88.2433;

    
    LabMKAnnotation *labAnnotation = [[LabMKAnnotation alloc] initWithCoordinate:coordinate Location:@"Basement"];
    [self.mapView addAnnotation:labAnnotation];
    NSLog(@"annotation    %f", labAnnotation.coordinate.longitude );
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *labPAV = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    //labPAV.enabled = YES;
    return labPAV;
}
@end
