//
//  SpecFactories.m
//  EWS
//
//  Created by Jay Chae  on 9/9/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import "SpecFactories.h"
#import "EWSDataModel.h"

@implementation SpecFactories

@end

@implementation EWSLab (SpecFactory)


+ (id)labFactoryWithStandardAttributes {
    static EWSLab *factory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSManagedObjectContext *mainContext = [[EWSDataModel sharedDataModel] mainContext];
        factory = [EWSLab insertInManagedObjectContext:mainContext];
        [factory setLabName:@"DCL 416"];
        [factory setInuseCount:@30];
        [factory setMachineCount:@40];
        [factory setLabIndex:@0];
        [factory setRegisteredForNotification:NO];
    });
    return factory;
}

/*
 Factories with 10+ vacant machines aren't eligible for notification;
 */

+ (id)labFactoryNotValidForNotification {
    static EWSLab *factory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSManagedObjectContext *mainContext = [[EWSDataModel sharedDataModel] mainContext];
        factory = [EWSLab insertInManagedObjectContext:mainContext];
        [factory setLabName:@"DCL 416"];
        [factory setInuseCount:@15];
        [factory setMachineCount:@40];
        [factory setLabIndex:@0];
        [factory setRegisteredForNotification:NO];
    });
    return factory;
}

+ (id)labFactoryValidForNotification {
    static EWSLab *factory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSManagedObjectContext *mainContext = [[EWSDataModel sharedDataModel] mainContext];
        factory = [EWSLab insertInManagedObjectContext:mainContext];
        [factory setLabName:@"DCL 416"];
        [factory setInuseCount:@39];
        [factory setMachineCount:@40];
        [factory setLabIndex:@0];
        [factory setRegisteredForNotification:NO];
    });
    return factory;
}


@end