//
//  EWSViewController.h
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
@class EWSDataController;

@interface EWSViewController : PullRefreshTableViewController <UIGestureRecognizerDelegate> {
    IBOutlet UITableView *machinesTableView;
}

@property (strong, nonatomic) EWSDataController *dataController;

@property (nonatomic) float openCellLastTX;
@property (nonatomic, strong) UIView *openGestureView;

- (void)snapView:(UIView *)view toX:(float)x animated:(BOOL)animated;


@end
