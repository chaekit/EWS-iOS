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

-(id) init {
    if (self = [super init]) {
        [self initDefault];
        [self pollCurrentLabUsage];
        return self;
    }
    return nil;
}

-(void)initDefault
{
    NSString *pathToLabPlist = [[NSBundle mainBundle] pathForResource:@"lab_info" ofType:@"plist"];
    Lab *lab1 = [[Lab alloc] initWithName:@"DCL L416" Capacity:26 Building:@"DCL" Platform:@"Linux"];
    Lab *lab2 = [[Lab alloc] initWithName:@"DCL L440" Capacity:29 Building:@"DCL" Platform:@"Linux"];
    Lab *lab3 = [[Lab alloc] initWithName:@"DCL L520" Capacity:41 Building:@"DCL" Platform:@"Linux"];
    Lab *lab4 = [[Lab alloc] initWithName:@"EH 406B1" Capacity:40 Building:@"EH" Platform:@"Windows"];
    Lab *lab5 = [[Lab alloc] initWithName:@"EH 406B8" Capacity:40 Building:@"EH" Platform:@"Windows"];
    Lab *lab6 = [[Lab alloc] initWithName:@"EVRT 252" Capacity:39 Building:@"EVRT" Platform:@"Linux"];
    Lab *lab7 = [[Lab alloc] initWithName:@"GELIB 057" Capacity:40 Building:@"GE" Platform:@"Linux"];
    Lab *lab8 = [[Lab alloc] initWithName:@"GELIB 4th" Capacity:39 Building:@"GE" Platform:@"Windows"];
    Lab *lab9 = [[Lab alloc] initWithName:@"MEL 1001" Capacity:25 Building:@"MEL" Platform:@"Linux"];
    Lab *lab10 = [[Lab alloc] initWithName:@"MEL 1009" Capacity:40 Building:@"MEL" Platform:@"Linux"];
    Lab *lab11 = [[Lab alloc] initWithName:@"SIEBL 0218" Capacity:21 Building:@"SIEBL" Platform:@"Linux"];
    Lab *lab12 = [[Lab alloc] initWithName:@"SIEBL 0220" Capacity:21 Building:@"SIEBL" Platform:@"Linux"];
    Lab *lab13 = [[Lab alloc] initWithName:@"SIEBL 0222" Capacity:21 Building:@"SIEBL" Platform:@"Windows"];
    self.mainLabList =  [[NSMutableArray alloc] initWithObjects:lab1, lab2, lab3, lab4, lab5, lab6, lab7, lab8, lab9, lab10, lab11, lab12, lab13, nil];
    
    
//    NSArray *testArray = [NSArray arrayWithContentsOfFile:pathToLabPlist];
//    self.mainLabList = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    Lab *lab;
//    for (int i =0; i < [testArray count]; i++) {
//        NSLog(@"class of cap   %@",[[[testArray objectAtIndex:i] objectForKey:@"capacity"] class]);
//        NSString *name = [[testArray objectAtIndex:i] objectForKey:@"name"];
//        NSUInteger capacity = [[[testArray objectAtIndex:i] objectForKey:@"capacity"] unsignedIntegerValue];
//        NSString *building = [[testArray objectAtIndex:i] objectForKey:@"building"];
//        NSString *platform = [[testArray objectAtIndex:i] objectForKey:@"platform_name"];
//       
//        
////        Lab *lab = [[Lab alloc] initWithName:name Capacity:capacity Building:building Platform:platform];
//        
//        lab = [[Lab alloc] initWithName:@"SIEBL 0222" Capacity:21 Building:@"SIEBL" Platform:@"Windows"];
//        NSLog(@"name   %@", lab.name);
//        NSLog(@"capactiy   %d", lab.maxCapacity);
//        NSLog(@"building   %@", lab.buildingName);
//        NSLog(@"platform   %@", lab.computerPlatformName);
//        NSLog(@"lab     %@", lab);
//        [self.mainLabList addObject:lab];
//    }
//    NSLog(@"mainLablist     %@", testArray);
}

- (NSUInteger)countOfMainLabList
{
    return [self.mainLabList count];
}

- (Lab *)objectAtIndex:(NSUInteger)index
{
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
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:  @"https://my.engr.illinois.edu/labtrack/util_data_json.asp?callback="]];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:  @"http://127.0.0.1:8080"]];
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSDictionary *results = [json_string JSONValue];
    NSArray *labJsonData = [results objectForKey:@"data"];
  
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
