//
//  EWSAsyncDemoCode.h
//  EWS
//
//  Created by Jay Chae  on 12/6/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AsyncDemoDelegate <NSObject>
@required
-(void)downloadData:(NSData*)data withError:(NSError*)error;
@end

@interface EWSAsyncDemoCode : NSObject <NSURLConnectionDelegate> {
    NSMutableData *requestData;
}
@property(nonatomic, assign) id <AsyncDemoDelegate> delegate;

-(id)initWithDelegate:(id <AsyncDemoDelegate>)delegate;

#pragma mark -
#pragma mark Download Code

-(void)downloadDataAtUrlStr:(NSString*)urlStr;

@end
