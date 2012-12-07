//
//  EWSAsyncDemoCode.m
//  EWS
//
//  Created by Jay Chae  on 12/6/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSAsyncDemoCode.h"

@implementation EWSAsyncDemoCode

-(id)initWithDelegate:(id<AsyncDemoDelegate>)delegate {
    if(self = [super init]) {
        _delegate = delegate;
        requestData = [NSMutableData data];
    }
    return self;
}

#pragma mark -
#pragma mark Download Methods

-(void)downloadDataAtUrlStr:(NSString *)urlStr {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    bool connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(!connection) NSLog(@"Connection error");
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    requestData = [NSMutableData data];
    
    NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse*)response;
    if([httpresponse statusCode] != 200) NSLog(@"Response error!");
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[self delegate] downloadData:requestData withError:error];
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection {
    [[self delegate] downloadData:requestData withError:NULL];
}

@end
