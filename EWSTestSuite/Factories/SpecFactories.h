//
//  SpecFactories.h
//  EWS
//
//  Created by Jay Chae  on 9/9/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EWSLab.h"

@interface SpecFactories : NSObject

@end

@interface EWSLab (SpecFactory)

+ (id)labFactoryWithStandardAttributes;
+ (id)labFactoryNotValidForNotification;
+ (id)labFactoryValidForNotification;
    
@end

