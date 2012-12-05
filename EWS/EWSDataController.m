//
//  EWSDataController.m
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSDataController.h"
#import "Lab.h"

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
    
    Lab *lab1 = [[Lab alloc] initWithName:@"SIEBL 0220" Capacity:21];
    Lab *lab2 = [[Lab alloc] initWithName:@"SIEBL 0222" Capacity:21];
    Lab *lab3 = [[Lab alloc] initWithName:@"SIEBL 0218" Capacity:16];
    Lab *lab4 = [[Lab alloc] initWithName:@"GELIB 057" Capacity:40];
    Lab *lab5 = [[Lab alloc] initWithName:@"GELIB 4th" Capacity:39];
    Lab *lab6 = [[Lab alloc] initWithName:@"EVRT 252" Capacity:39];
    Lab *lab7 = [[Lab alloc] initWithName:@"MEL 1001" Capacity:25];
    
    self.mainLabList =  [[NSMutableArray alloc] initWithObjects:lab1, lab2, lab3, lab4, lab5, lab6, lab7, nil];
   // self.mainLabList = [[NSMutableArray alloc] initWithObjects:@"lol", @"hehe", @"heehee", nil];
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
