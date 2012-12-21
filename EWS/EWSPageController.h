//
//  EWSPageController.h
//  EWS
//
//  Created by Jay Chae  on 12/21/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EWSPageController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *pageIcon;
@property (nonatomic) NSInteger pageNumber;

-(id) initWithPageNumber:(NSInteger) page;
@end
