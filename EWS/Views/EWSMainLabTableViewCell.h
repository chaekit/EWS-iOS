//
//  EWSMainLabTableViewCell.h
//  EWS
//
//  Created by Jay Chae  on 9/8/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EWSLab;

FOUNDATION_EXPORT NSString *const UNREGISTERED_CELL_IDENTIFIER;
FOUNDATION_EXPORT NSString *const REGISTERED_CELL_IDENTIFIER;

@interface EWSMainLabTableViewCell : UITableViewCell

@property (nonatomic, strong) EWSLab *labObject;

@property (nonatomic, strong) UILabel *labNameLabel;
@property (nonatomic, strong) UIButton *labTicketStatusButton;
@property (nonatomic, strong) UILabel *labDetailUsageLabel;

- (void)updateWithLab:(EWSLab *)lab;

- (void)registerForNotification:(id)sender;

@end
