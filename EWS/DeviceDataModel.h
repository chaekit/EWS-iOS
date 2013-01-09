//
//  DeviceDataModel.h
//  EWS
//
//  Created by Jay Chae  on 1/6/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeviceDataModel : NSObject


@property (nonatomic, strong) NSString *udid;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *secretCode;

+ (void)setDeviceToken:(NSString*)token;
+(DeviceDataModel *) getInstance;

@end
