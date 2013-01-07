//
//  DeviceDataModel.h
//  EWS
//
//  Created by Jay Chae  on 1/6/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeviceDataModel : NSObject

-(NSString *) udid;
-(NSString *) deviceToken;
-(NSString *) secretCode;

- (void)setDeviceToken:(NSString*)token;

@end
