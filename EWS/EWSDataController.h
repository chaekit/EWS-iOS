//
//  EWSDataController.h
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EWSDataController : NSObject
{
    NSMutableData *responseData;
}

@property (nonatomic, copy) NSMutableArray *mainLabList;

-(NSUInteger) countOfMainLabList;
-(NSString *) objectAtIndex:(NSUInteger) index;
@end
