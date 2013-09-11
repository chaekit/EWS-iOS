//
//  EWSMainLabTableViewCell.m
//  EWS
//
//  Created by Jay Chae  on 9/8/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import "EWSMainLabTableViewCell.h"
#import "EWSLab.h"

NSString *const UNREGISTERED_CELL_IDENTIFIER = @"UnregisteredCell";
NSString *const REGISTERED_CELL_IDENTIFIER = @"RegisteredCell";

@implementation EWSMainLabTableViewCell

@synthesize labObject;
@synthesize labNameLabel;
@synthesize labTicketStatusButton;
@synthesize labDetailUsageLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self _initAllSubViews];
    }
    return self;
}

/* @private */

- (void)_initAllSubViews {
    [self _initLabNameLabel];
    [self _initLabDetailUsageLabel];
    [self _initLabTicketStatusButton];
}

/* @private */

- (void)_initLabNameLabel {
    CGRect frame = CGRectMake(114, 20, 92, 19);
    
    labNameLabel = [[UILabel alloc] initWithFrame:frame];
    [self.contentView addSubview:labNameLabel];
}


/* @private */

- (void)_initLabDetailUsageLabel {
    CGRect frame = CGRectMake(0, 0, 0, 0);

    labDetailUsageLabel = [[UILabel alloc] initWithFrame:frame];
    [self.contentView addSubview:labDetailUsageLabel];
}

/* @private */

- (void)_initLabTicketStatusButton {
    CGRect frame = CGRectMake(0, 0, 0, 0);
    
    labTicketStatusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [labTicketStatusButton setFrame:frame];
    [labTicketStatusButton addTarget:self action:@selector(registerForNotification:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:labTicketStatusButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)registerForNotification:(id)sender {
    NSLog(@"wtf");
}

- (void)updateWithLab:(EWSLab *)lab {
    if ([lab isKindOfClass:[EWSLab class]] == NO) {
        @throw NSInvalidArgumentException;
    }
    [self setLabObject:lab];
   
    [labNameLabel setText:[lab labName]];
    [labDetailUsageLabel setText:[lab usageFractionInString]];
}

@end
