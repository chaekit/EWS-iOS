//
//  DataControllerDelegate.m
//  EWS
//
//  Created by Jay Chae  on 1/19/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import "DataControllerDelegate.h"

@class EWSDataController;

@protocol DataControllerDelegate <NSObject>

@required
- (void)dataControllerDidPollUsage:(EWSDataController *)dataController;


@end