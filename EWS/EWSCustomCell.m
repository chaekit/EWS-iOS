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
@synthesize meterContainerView, detailView, usageFractionLabel, platformIcon, meterView, labNameLabel;


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
    lab = labAtIndex;
    [self setUsageFractionLabel];
    [self setPlatformIcon];
    [self setMeterView];
    [self setLabNameLabel];
    [self adjustSubViewOverlay];
}

- (void) setUsageFractionLabel
{
    NSString *labUsageString = [NSString stringWithFormat:@"%d/%d", lab.currentLabUsage, lab.maxCapacity];
    [usageFractionLabel setText:labUsageString];
    [usageFractionLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
    [usageFractionLabel.layer setBorderWidth:2.0];
}

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


@end
