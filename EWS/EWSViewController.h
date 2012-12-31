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
@interface EWSViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    IBOutlet UITableView *machinesTableView;
    UIScrollView *pageControlView;
}

#pragma mark - View properties
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) EWSDataController *dataController;

@property (strong, nonatomic) IBOutlet UIScrollView *pageControlView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end
