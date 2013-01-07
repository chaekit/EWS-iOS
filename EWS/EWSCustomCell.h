//
//  EWSCustomCell.h
//  EWS
//
//  Created by Jay Chae  on 12/14/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Lab;

@interface EWSCustomCell : UITableViewCell

@property (nonatomic, strong) Lab *lab;

#pragma Major views
@property (nonatomic, strong) IBOutlet UIView *meterContainerView;
@property (nonatomic, strong) IBOutlet UIView *detailView;
@property (nonatomic, strong) IBOutlet UIView *meterView;


#pragma DetailView
@property (nonatomic, strong) IBOutlet UILabel *usageFractionLabel;
@property (nonatomic, strong) IBOutlet UIButton *notifyButton;
@property (nonatomic, strong) IBOutlet UIImageView *platformIcon;
@property (nonatomic, strong) IBOutlet UILabel *labNameLabelInDetailView;

//@property (nonatomic, strong) IBOutlet UILabel *platformNameLabel;

// methods
-(void) initSubViewsWithLab:(Lab *) labAtIndex;

//-(void) setLoadi

#pragma MeterView
@property (nonatomic,strong) IBOutlet UILabel *labNameLabel;

@property BOOL meterViewOpen;


-(void) scrollMeterViewWithPageControl:(NSNumber *) newTXOfCellObject;

@end
