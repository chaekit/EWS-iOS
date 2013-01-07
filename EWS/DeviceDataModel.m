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

@implementation DeviceDataModel

+ (void)initialize
{
	if (self == [DeviceDataModel class])
	{
		[[NSUserDefaults standardUserDefaults] registerDefaults:
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"", SecretCodeKey,
 
				// ADD THIS LINE:
				@"0", DeviceTokenKey,
 
				nil]];
	}
}
- (NSString*)udid
{
	UIDevice* device = [UIDevice currentDevice];
	return [device.uniqueIdentifier stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (NSString*)deviceToken
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:DeviceTokenKey];
}
 
- (void)setDeviceToken:(NSString*)token
{
	[[NSUserDefaults standardUserDefaults] setObject:token forKey:DeviceTokenKey];
}

- (NSString *)secretCode
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:SecretCodeKey];
}
@end
