//
//  SpecFactories.m
//  EWS
//
//  Created by Jay Chae  on 9/9/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import "SpecFactories.h"

@implementation SpecFactories

@end

@implementation EWSLab (SpecFactory)

+ (id)labFactoryWithStandardAttributes {
    static EWSLab *factory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        factory = [[EWSLab alloc] init];
        [factory setLabName:@"DCL 416"];
        [factory setInuseCount:@30];
        [factory setMachineCount:@40];
        [factory setLabIndex:@0];
    });
    return factory;
}

@end