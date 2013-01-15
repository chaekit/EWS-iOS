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

//Import QuartzCore into frameworks
//#import <QuartzCore/QuartzCore.h>
//UILabel *label;
//[label.layer setCornerRadius:10];

//#import "EWSAsyncDemoCode.h"

@interface EWSDataController ()
-(void)initDefault;
@end

@implementation EWSDataController

static EWSDataController *sharedEWSLabSingleton;

+(EWSDataController *) sharedEWSLabSingleton {
    @synchronized(self) {
        if (!sharedEWSLabSingleton) {
            sharedEWSLabSingleton = [[EWSDataController alloc] init];
        }
        return sharedEWSLabSingleton;
    }
}

-(id) init {
    if (self = [super init]) {
        [self initDefault];
        [self pollCurrentLabUsage];
        return self;
    }
    return nil;
}

//+(void) initialize {
//    static BOOL initialized = NO;
//    if (!initialized) {
//        initialized = YES;
//        sharedEWSLabSingleton = [[EWSDataController alloc] init];
//    }
//}

-(void)initDefault
{
    NSString *pathToLabPlist = [[NSBundle mainBundle] pathForResource:@"lab_info" ofType:@"plist"];
    NSArray *testArray = [NSArray arrayWithContentsOfFile:pathToLabPlist];
    self.mainLabList = [[NSMutableArray alloc] init];

    for (int i =0; i < [testArray count]; i++) {
        NSLog(@"class of cap   %@",[[[testArray objectAtIndex:i] objectForKey:@"capacity"] class]);
        NSString *name = [[testArray objectAtIndex:i] objectForKey:@"name"];
        NSUInteger capacity = [[[testArray objectAtIndex:i] objectForKey:@"capacity"] unsignedIntegerValue];
        NSString *building = [[testArray objectAtIndex:i] objectForKey:@"building"];
        NSString *platform = [[testArray objectAtIndex:i] objectForKey:@"platform_name"];
        NSDictionary *geoLocation = [[testArray objectAtIndex:i] objectForKey:@"geoLocation"];
        NSString *locationTip = [[testArray objectAtIndex:i] objectForKey:@"location_tip"];
       
        
        Lab *lab = [[Lab alloc] initWithName:name Capacity:capacity Building:building Platform:platform LatLng:geoLocation LocationTip:locationTip];
        
        [self.mainLabList addObject:lab];
    }
}

- (NSUInteger)countOfMainLabList {
    return [self.mainLabList count];
}

- (Lab *)objectAtIndex:(NSUInteger)index {
    return [self.mainLabList objectAtIndex:index];
}

//-(void)asyncDownload {
//    //Set yourself as the delegate in the header file!
//    EWSAsyncDemoCode *manager = [[EWSAsyncDemoCode alloc] initWithDelegate:self];
//    [manager downloadDataAtUrlStr:@"http://www.google.com/?q=cats"];
//}
//
//-(void)downloadData:(NSData*)data withError:(NSError *)error {
//    //Process the data
//}

-(void)pollCurrentLabUsage
{
    // Create new SBJSON parser object

    // Prepare URL request to download statuses from Twitter
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:  @"https://my.engr.illinois.edu/labtrack/util_data_json.asp?callback="]];

    NSLog(@"wtf");
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    NSLog(@"%@", response);
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSDictionary *results = [json_string JSONValue];
    NSArray *labJsonData = [results objectForKey:@"data"];

    NSLog(@"%@", results);
    //NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //[formatter setNumberStyle:NSNumberFormatterNoStyle];
    NSUInteger indexForMainList = 0;
    for (NSDictionary *lab in labJsonData) {
        NSUInteger currentUsage = [[lab objectForKey:@"inusecount"] integerValue];
        ((Lab *)[self.mainLabList objectAtIndex:indexForMainList]).currentLabUsage = currentUsage;
        indexForMainList++;
    }
}
@end
