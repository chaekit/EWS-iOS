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
        [self _initAllProperties];
    }
    return self;
}

/* Non UI properties */

- (void)_initAllProperties {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
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
    CGRect frame = CGRectMake(258, 22, 42, 21);

    labDetailUsageLabel = [[UILabel alloc] initWithFrame:frame];
    [self.contentView addSubview:labDetailUsageLabel];
}

/* @private */

- (void)_initLabTicketStatusButton {
    CGRect frame = CGRectMake(20, 15, 46, 30);
    
    labTicketStatusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [labTicketStatusButton setFrame:frame];
    [labTicketStatusButton addTarget:self action:@selector(registerForNotification:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:labTicketStatusButton];
}

- (void)_initButtonForRegisteredLab {
    [labTicketStatusButton setTitle:@"RR" forState:UIControlStateNormal];
}

- (void)_initButtonForUnRegisteredLab {
    [labTicketStatusButton setTitle:@"UR" forState:UIControlStateNormal];
}

- (UIImage *)ticketStatusButtonImage {
    if ([[labObject registeredForNotification] boolValue]) {
        return nil; // return an icon for registered lab
    } else {
        return nil; // return an icon for unregistered lab
    }
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)registerForNotification:(id)sender {
    [self.delegate userTappedTicketStatusButton:self];
}

- (void)markAsRegistered {
    [labObject setRegisteredForNotification:[NSNumber numberWithBool:YES]];
    [labTicketStatusButton setTitle:@"RR" forState:UIControlStateNormal];
}

- (void)markAsUnregistered {
    [labObject setRegisteredForNotification:[NSNumber numberWithBool:NO]];
    [labTicketStatusButton setTitle:@"UR" forState:UIControlStateNormal];
}

- (void)updateWithLab:(EWSLab *)lab {
    if ([lab isKindOfClass:[EWSLab class]] == NO) {
        @throw NSInvalidArgumentException;
    }
    [self setLabObject:lab];
   
    [labNameLabel setText:[lab labName]];
    [labDetailUsageLabel setText:[lab usageFractionInString]];
    if ([[labObject registeredForNotification] boolValue] == YES) {
        [self _initButtonForRegisteredLab];
    } else {
        [self _initButtonForUnRegisteredLab];
    }

}

@end
