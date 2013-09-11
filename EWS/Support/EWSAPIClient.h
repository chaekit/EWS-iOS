//
//  EWSAPIClient.h
//  EWS
//
//  Created by Jay Chae  on 9/10/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "EWSLab.h"

@interface EWSAPIClient : AFHTTPClient

+ (EWSAPIClient *)sharedAPIClient;

- (void)pollUsageFromAPISucess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                       Failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

- (void)registerNotificationParams:(id)params
                     Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                     Failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;



@end



