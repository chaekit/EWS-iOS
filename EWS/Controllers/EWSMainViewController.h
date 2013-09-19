//
//  EWSMainViewController.h
//  EWS
//
//  Created by Jay Chae  on 9/10/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EWSMainLabTableViewCell.h"


@class AFHTTPRequestOperation;

@interface EWSMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
                                                    EWSMainLabTableViewCellLabNotificationProtocol,
                                                    UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) EWSMainLabTableViewCell *cellForCancellation;

- (void)updateLabUsage;
- (void)promptRegistrationCancellation:(EWSMainLabTableViewCell *)cell;
- (NSDictionary *)paramsForTicketCancellation;


@end
