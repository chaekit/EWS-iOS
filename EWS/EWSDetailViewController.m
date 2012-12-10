//
//  EWSDetailViewController.m
//  EWS
//
//  Created by Jay Chae  on 12/9/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSDetailViewController.h"
#import "Lab.h"
@interface EWSDetailViewController ()

@end

@implementation EWSDetailViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

-(void)configureView
{
    Lab *theLab = self.ewsLab;
    self.detailViewNavigationHeader.title = theLab.name;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
