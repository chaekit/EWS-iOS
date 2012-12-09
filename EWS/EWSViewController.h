//
//  EWSViewController.h
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EWSDataController;

@interface EWSViewController : UITableViewController

@property (strong, nonatomic) EWSDataController *dataController;

@end
