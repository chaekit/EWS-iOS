/*

USE PRIVATE SINGLETON VARIABLE DUDE. CHANGE THIS LATER
 
*/

//
//  EWSDataController.m
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSDataController.h"
#import "Lab.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "EWSProjectConstants.h"



@interface EWSDataController ()
-(void)initDefault;
@end

@implementation EWSDataController

static EWSDataController *sharedEWSLabSingleton = nil;


-(id) init {
    if (self = [super init]) {
        [self initDefault];
        //[self pollCurrentLabUsage];
        return self;
    }
    return nil;
}

+ (void)initialize {
    @synchronized(self) {
        if (!sharedEWSLabSingleton) {
            sharedEWSLabSingleton = [[EWSDataController alloc] init];
        }
    }
}


+ (void)postPollUsageNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:POST_NOTIFICATION object:self];
}

-(void)initDefault {
    NSString *pathToLabPlist = [[NSBundle mainBundle] pathForResource:@"lab_info" ofType:@"plist"];
    NSArray *testArray = [NSArray arrayWithContentsOfFile:pathToLabPlist];
    self.mainLabList = [[NSMutableArray alloc] init];

    for (int i =0; i < [testArray count]; i++) {
        NSString *name = [[testArray objectAtIndex:i] objectForKey:@"name"];
        NSUInteger capacity = [[[testArray objectAtIndex:i] objectForKey:@"capacity"] unsignedIntegerValue];
        NSString *building = [[testArray objectAtIndex:i] objectForKey:@"building"];
        NSString *platform = [[testArray objectAtIndex:i] objectForKey:@"platform_name"];
        NSDictionary *geoLocation = [[testArray objectAtIndex:i] objectForKey:@"geoLocation"];
        NSString *locationTip = [[testArray objectAtIndex:i] objectForKey:@"location_tip"];
       
        
        Lab *lab = [[Lab alloc] initWithName:name Capacity:capacity
                                    Building:building Platform:platform
                                      LatLng:geoLocation LocationTip:locationTip Index:i];
        
        [self.mainLabList addObject:lab];
    }
}

+ (NSUInteger)countOfMainLabList {
    return [sharedEWSLabSingleton.mainLabList count];
}

+ (Lab *)objectAtIndex:(NSUInteger)index {
    return [sharedEWSLabSingleton.mainLabList objectAtIndex:index];
}


+ (void)pollCurrentLabUsage {
    // Create new SBJSON parser object
    // Prepare URL request to download statuses from Twitter
    NSURL *url = [NSURL URLWithString:EWS_URL];
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://my.engr.illinois.edu/labtrack/util_data_json.asp?callback="]];
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

    [request setCompletionBlock:^{
        NSData *response = [request responseData];
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSDictionary *results = [json_string JSONValue];
        NSArray *labJsonData = [results objectForKey:@"data"];
        NSUInteger indexForMainList = 0;
        for (NSDictionary *lab in labJsonData) {
            NSUInteger currentUsage = [[lab objectForKey:@"inusecount"] integerValue];
            ((Lab *)[sharedEWSLabSingleton.mainLabList objectAtIndex:indexForMainList]).currentLabUsage = currentUsage;
            indexForMainList++;
        }
        
        [self postPollUsageNotification];
    }];
    
    [request startAsynchronous];
}
@end
