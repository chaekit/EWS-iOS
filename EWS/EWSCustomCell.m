//
//  EWSCustomCell.m
//  EWS
//
//  Created by Jay Chae  on 12/14/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSCustomCell.h"
#import "Lab.h"
#import <QuartzCore/QuartzCore.h>


@interface EWSCustomCell ()

-(void) setUsageFractionLabel;
-(void) setPlatformIcon;
-(void) setMeterView;
-(void) setLabNameLabel;
-(void) adjustSubViewOverlay;

@end

@implementation EWSCustomCell

@synthesize lab;
@synthesize meterContainerView, detailView, usageFractionLabel, platformIcon, meterView, labNameLabel, labNameLabelInDetailView;
@synthesize meterViewOpen;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initSubViewsWithLab:(Lab *)labAtIndex
{
    meterViewOpen = NO;
    lab = labAtIndex;
    [self setUsageFractionLabel];
    //[self setPlatformIcon];
    [self setLabNameLabelInDetailView];
    [self setMeterView];
    [self setLabNameLabel];
    [self adjustSubViewOverlay];
    [self setAccessoryType:UITableViewCellAccessoryNone];
}

- (void) setUsageFractionLabel
{
    NSString *labUsageString = [NSString stringWithFormat:@"%d/%d", lab.currentLabUsage, lab.maxCapacity];
    [usageFractionLabel setText:labUsageString];
    [usageFractionLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
    [usageFractionLabel.layer setBorderWidth:2.0];
}

/*
-(void) setPlatformIcon
{
    // optimize by having to load up these images only once
    UIImage *linuxIcon = [UIImage imageNamed:@"tux.png"];
    UIImage *windowsIcon = [UIImage imageNamed:@"windowsIcon.png"];
    
    if ([lab.computerPlatformName isEqualToString:@"Linux"]) {
        [platformIcon setImage:linuxIcon];
    } else {
        [platformIcon setImage:windowsIcon];
    }
    
}
*/

-(void) setLabNameLabelInDetailView
{
    [labNameLabelInDetailView setText:lab.name];
}

-(void) setMeterView
{
    double widthBasedOnUsage = ((double) lab.currentLabUsage/(double)lab.maxCapacity)*320;
    [meterView setFrame:CGRectMake(meterView.frame.origin.x, meterView.frame.origin.y, widthBasedOnUsage, meterView.frame.size.height)];
    
    float alphaAdjuster = widthBasedOnUsage/320;
    meterView.alpha = alphaAdjuster * 0.5 + 0.5;
}

-(void) setLabNameLabel
{
    [labNameLabel setText:lab.name];
}

-(void) adjustSubViewOverlay
{
    [meterContainerView insertSubview:labNameLabel aboveSubview:meterView];
    [detailView insertSubview:meterContainerView aboveSubview:usageFractionLabel];
}

-(void) scrollMeterViewWithPageControl:(NSNumber *) newTXOfCellObject {
    [self.meterContainerView setTransform:CGAffineTransformMakeTranslation([newTXOfCellObject floatValue], 0)];
}

@end
