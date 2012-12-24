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
@property (strong, nonatomic) UITableView *tableView;

#pragma mark - Model property
@property (strong, nonatomic) EWSDataController *dataController;

#pragma mark - Helper properties for gestures
@property (nonatomic) float openCellLastTX;
@property (nonatomic, strong) UIView *openGestureView;
- (void)snapView:(UIView *)view toX:(float)x animated:(BOOL)animated;

#pragma mark - PageControl Stuff
@property (strong, nonatomic) IBOutlet UIScrollView *pageControlView;
@property (strong, nonatomic) NSMutableArray *pageControllers;
//@property (strong, nonatomic) IBOutlet UIScrollView *pageControlView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

//@property (nonatomic) BOOL pageControlUsed;
@property (nonatomic) BOOL tableViewInGlanceMode;

@property (nonatomic, strong) NSMutableArray *meterViewArray;
@end
