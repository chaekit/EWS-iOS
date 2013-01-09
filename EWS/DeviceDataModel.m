//
//  DeviceDataModel.m
//  EWS
//
//  Created by Jay Chae  on 1/6/13.
//  Copyright (c) 2013 com.chaebacca. All rights reserved.
//

#import "DeviceDataModel.h"

static NSString* const DeviceTokenKey = @"DeviceToken";
static NSString* const SecretCodeKey = @"SecretCode";

static DeviceDataModel *instance = nil;

@implementation DeviceDataModel

@synthesize udid, secretCode, deviceToken;

+(DeviceDataModel *) getInstance {
    @synchronized(self) {
        if (instance == nil) {
            [[NSUserDefaults standardUserDefaults] registerDefaults:
                [NSDictionary dictionaryWithObjectsAndKeys:
                    @"", SecretCodeKey,
     
                    // ADD THIS LINE:
                    @"0", DeviceTokenKey,
     
                    nil]];
            instance = [DeviceDataModel new];
            
            UIDevice* device = [UIDevice currentDevice];
            
            instance.udid = [device.uniqueIdentifier stringByReplacingOccurrencesOfString:@"-" withString:@""];
            instance.deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:DeviceTokenKey];
            instance.secretCode = [[NSUserDefaults standardUserDefaults] stringForKey:SecretCodeKey];
        }
    }
    return instance;
}

+ (void)setDeviceToken:(NSString*)token
{
    instance.deviceToken = token;
	//[[NSUserDefaults standardUserDefaults] setObject:token forKey:DeviceTokenKey];
}


@end
