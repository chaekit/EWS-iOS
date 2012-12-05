//
//  EWSDataController.m
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSDataController.h"

@interface EWSDataController ()
-(void)initDefault;
@end

@implementation EWSDataController

-(id) init
{
    if (self = [super init]) {
        [self initDefault];
        return self;
    }
    return nil;
}

-(void)initDefault
{
    self.mainLabList = [[NSMutableArray alloc] initWithObjects:@"lol", @"hehe", @"heehee", nil];
}

- (NSUInteger)countOfMainLabList
{
    return [self.mainLabList count];
}

- (NSString *)objectAtIndex:(NSUInteger)index
{
    return [self.mainLabList objectAtIndex:index];
}

@end
