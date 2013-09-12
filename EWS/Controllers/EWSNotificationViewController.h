//
//  EWSNotificationViewController.h
//  EWS
//
//  Created by Jay Chae  on 9/11/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EWSMainLabTableViewCell;

@interface EWSNotificationViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *timePickerView;
@property (nonatomic, strong) UISegmentedControl *openStationSegmentControl;
@property (nonatomic, strong) NSArray *titlesForTimePickerView;
@property (nonatomic, strong) UIButton *confirmationButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIToolbar *menuToolBar;

@property (nonatomic, strong) EWSMainLabTableViewCell *cellObject;

- (NSDictionary *)paramsForLabNotification;
@end
