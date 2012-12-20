//
//  EWSCustomCell.h
//  EWS
//
//  Created by Jay Chae  on 12/14/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EWSCustomCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *meterView;
@property (nonatomic, strong) IBOutlet UIView *detailView;


#pragma DetailView
@property (nonatomic, strong) IBOutlet UILabel *usageFractionLabel;
@property (nonatomic, strong) IBOutlet UIButton *notifyButton;
@property (nonatomic, strong) IBOutlet UIImageView *platformIcon;
//@property (nonatomic, strong) IBOutlet UILabel *platformNameLabel;

@end
