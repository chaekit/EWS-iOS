//
//  EWSDetailViewController.h
//  EWS
//
//  Created by Jay Chae  on 12/9/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Lab;

@interface EWSDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UINavigationItem *detailViewNavigationHeader;

@property (strong, nonatomic) Lab *ewsLab;

@end
