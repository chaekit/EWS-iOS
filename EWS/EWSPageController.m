//
//  EWSPageController.m
//  EWS
//
//  Created by Jay Chae  on 12/21/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSPageController.h"

@interface EWSPageController ()

@end

@implementation EWSPageController


-(id) initWithPageNumber:(NSInteger) page
{
    self = [super init];
    if (self) {
        self.pageNumber = page;
        return self;
    }
    return nil;
}

@end
