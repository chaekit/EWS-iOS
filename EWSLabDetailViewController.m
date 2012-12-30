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
    

//    CLLocationCoordinate2D coordinate;
//    coordinate.latitude = 40.1164;
//    coordinate.longitude = 88.2433;

    
    LabMKAnnotation *labAnnotation = [[LabMKAnnotation alloc] initWithCoordinate:self.lab.geoLocation Location:@"Basement"];
    [self.mapView addAnnotation:labAnnotation];
    NSLog(@"annotation    %f", labAnnotation.coordinate.latitude );
    NSLog(@"annotation    %f", labAnnotation.coordinate.longitude );
    [self.navigationItem.titleView setBackgroundColor:[UIColor blackColor]];
    

    UIBarButtonItem *backbutton =  [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [backbutton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor blackColor],UITextAttributeTextColor,[UIFont fontWithName:@"Monaco" size:16.0f],UITextAttributeFont,
                                        nil] forState:UIControlStateNormal];
    
    self.navigationController.navigationItem.backBarButtonItem = backbutton;

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
