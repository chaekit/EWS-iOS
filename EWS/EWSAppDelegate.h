//
//  EWSAppDelegate.h
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeviceDataModel;

@interface EWSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DeviceDataModel *deviceData;

@end
