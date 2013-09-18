//
//  EWSAppDelegate.m
//  EWS
//
//  Created by Jay Chae  on 9/8/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import "EWSAppDelegate.h"
#import "EWSDataModel.h"
#import "EWSMainViewController.h"
#import <NewRelicAgent/NewRelicAgent.h>


@implementation EWSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NewRelicAgent startWithApplicationToken:@"AA7729b591fec1f44aa03cb07d6f938182ca2aacba"];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge];
 
    [[NSUserDefaults standardUserDefaults] setObject:@"D418D4EC5C96C7234A8FA4B7CEE2837933F1AB9AFF5824642AFBF3A3FF9EF0FB" forKey:@"deviceToken"];
   
    /*     sanity check on core data     */
    NSManagedObjectContext *context = [[EWSDataModel sharedDataModel] mainContext];
    if (context) {
        NSLog(@"CoreData set up");
    } else {
        NSLog(@"you fucked it up");
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[EWSMainViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const char *data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    NSLog(@"token  %@", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSError *error;
    [[[EWSDataModel sharedDataModel] mainContext] save:&error];
    if (error) {
        NSLog(@"Failed to save db on termination   %@", [error localizedDescription]);
    }
}

@end
