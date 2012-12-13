//
//  Lab.m
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "Lab.h"


@implementation Lab

-(id)initWithName:(NSString *)labName Capacity:(NSUInteger)labCapacity Building:(NSString *)buildingName Platform:(NSString *)computerPlatFormName
{
    self = [super init];
    if (self)
    {
        self.name = labName;
        self.maxCapacity = labCapacity;
        self.currentLabUsage = 0;
        self.buildingName = buildingName;
        self.computerPlatformName = computerPlatFormName;
        return self;
    }
    return nil;
}

//-(id)initWithName:(NSString *)labName Capacity:(NSUInteger)labCapacity
//{
//    // creates an NSObject
//    self = [super init];
//    if (self)
//    {
//        self.name = labName;
//        self.maxCapacity = labCapacity;
//        self.currentLabUsage = 0;
//        return self;
//    }
//    return nil;
//}
//
@end
