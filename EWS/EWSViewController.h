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

//@interface EWSViewController : PullRefreshTableViewController <UIGestureRecognizerDelegate> {
@interface EWSViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *machinesTableView;
}

#pragma mark - View properties
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *pageControlView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

#pragma mark - Model property
@property (strong, nonatomic) EWSDataController *dataController;

#pragma mark - Helper properties for gestures
@property (nonatomic) float openCellLastTX;
@property (nonatomic, strong) UIView *openGestureView;
- (void)snapView:(UIView *)view toX:(float)x animated:(BOOL)animated;


@end
