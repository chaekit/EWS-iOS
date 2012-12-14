//
//  EWSCustomCell.m
//  EWS
//
//  Created by Jay Chae  on 12/14/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSCustomCell.h"

@implementation EWSCustomCell

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

@end
