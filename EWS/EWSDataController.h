//
//  EWSDataController.h
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Lab;
@class EWSDataController;

@protocol EWSDataControllerDelegate <NSObject>

@required
- (void)dataControllerDidPollUsage:(EWSDataController *)dataController;

@end

@interface EWSDataController : NSObject {
    __weak id <EWSDataControllerDelegate> dataControllerDelegate;
    NSMutableData *responseData;
}

@property (nonatomic, weak) id <EWSDataControllerDelegate> dataControllerDelegate;
@property (nonatomic, retain) NSMutableArray *mainLabList;

+(EWSDataController *) sharedEWSLabSingleton;
-(NSUInteger) countOfMainLabList;
-(Lab *) objectAtIndex:(NSUInteger) index;
-(void) pollCurrentLabUsage;
@end
