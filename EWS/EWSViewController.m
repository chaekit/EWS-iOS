//
//  EWSViewController.m
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSViewController.h"
#import "EWSDataController.h"
#import "Lab.h"
#import "EWSCustomCell.h"
#import <QuartzCore/QuartzCore.h>

#define FAST_ANIMATION_DURATION 0.35
#define SLOW_ANIMATION_DURATION 0.75

#define CELL_OPEN_X -300
#define CELL_CLOSED_X 0

@interface EWSViewController ()
@end

@implementation EWSViewController
//@synthesize openCellLastTX, openGestureView;

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[EWSDataController alloc] init];
    
   
    // pageControl initialization
    self.pageControl.hidesForSinglePage = NO;
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage = 0;

//    self.pageControlView = [[UIView alloc] init];
//    [self.pageControlView setBackgroundColor:[UIColor blackColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view insertSubview:self.pageControlView aboveSubview:self.tableView];
}

-(void)viewDidAppear:(BOOL)animated {
    //[super viewDidAppear:animated];
    [machinesTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dataController countOfMainLabList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Interfaces
    UILabel *nameLabel;
    UIView *meterView;
    EWSCustomCell *cell;

    
    static NSString *CellIdentifier = @"LabInfoCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[EWSCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.accessoryView = UITableViewCellAccessoryNone;
    }
    
    nameLabel = (UILabel*)[cell.contentView viewWithTag:3];
    //loadingView = (UIView *)[cell.contentView viewWithTag:4];
    meterView = cell.meterView;

    Lab *labAtIndex = [self.dataController objectAtIndex:indexPath.row];
    [nameLabel setText:labAtIndex.name];

    UIView *loadingView = (UIView *)[cell.contentView viewWithTag:5];
    double widthBasedOnUsage = ((double) labAtIndex.currentLabUsage/(double)labAtIndex.maxCapacity)*320;
    //NSLog(@"%f", widthBasedOnUsage);
    [loadingView setFrame:CGRectMake(loadingView.frame.origin.x, loadingView.frame.origin.y, widthBasedOnUsage, loadingView.frame.size.height)];
    
    float alphaAdjuster = widthBasedOnUsage/320;
    loadingView.alpha = alphaAdjuster * 0.5 + 0.5;

    NSString *labUsageSring = [NSString stringWithFormat:@"%d/%d", labAtIndex.currentLabUsage, labAtIndex.maxCapacity];
    // Adjusts the subview overlays
    //always have the name label on top of the loadingView
    // sets up the usageFractionLabel
    [meterView insertSubview:nameLabel aboveSubview:loadingView];
    [cell.detailView insertSubview:meterView aboveSubview:cell.usageFractionLabel];
    [cell.usageFractionLabel setText:labUsageSring];
    
    UIImage *linuxIcon = [UIImage imageNamed:@"tux.png"];
    UIImage *windowsIcon = [UIImage imageNamed:@"windowsIcon.png"];
    
    if ([labAtIndex.computerPlatformName isEqualToString:@"Linux"]) {
        [cell.platformIcon setImage:linuxIcon];
    } else {
        [cell.platformIcon setImage:windowsIcon];
    }
    
    cell.usageFractionLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.usageFractionLabel.layer.borderWidth = 2.0;
    

    // Gesture initialization
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panGestureRecognizer setDelegate:self];
    [cell.meterView addGestureRecognizer:panGestureRecognizer];
    
    return cell;
}




#pragma mark - Gesture recognizer delegate

// Makes sure that the recognizer doesn't block vertical gesutre, which is scrolling
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    return (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
}

-(void)snapView:(UIView *)view toX:(float)x animated:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:FAST_ANIMATION_DURATION];
    }
    
    [view setTransform:CGAffineTransformMakeTranslation(x, 0)];
    
    if (animated) {
        [UIView commitAnimations];
    }
}

-(void) handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    float threshold = (CELL_CLOSED_X + CELL_OPEN_X)/2.0;
    UIView *gestureView = [panGestureRecognizer view];
    CGPoint translation;
    float vX = 0.0;
    float newTXOfOpenCell;
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (![self.openGestureView isEqual:gestureView]) {
                [self snapView:self.openGestureView toX:CELL_CLOSED_X animated:YES];
                self.openGestureView = nil;
                self.openCellLastTX = 0.0;
            }
            break;
        
        case UIGestureRecognizerStateChanged:
            //translation = [panGestureRecognizer translationInView:[gestureView superview]];
            translation = [panGestureRecognizer translationInView:self.view];
            newTXOfOpenCell = self.openCellLastTX + translation.x;
            
            if (newTXOfOpenCell > CELL_CLOSED_X)
                newTXOfOpenCell = CELL_CLOSED_X;
            else if (newTXOfOpenCell < CELL_OPEN_X)
                newTXOfOpenCell = CELL_OPEN_X;
            
            [gestureView setTransform:CGAffineTransformMakeTranslation(newTXOfOpenCell, 0)];
            break;
        case UIGestureRecognizerStateEnded:
            // WTF is this
            //vX = (FAST_ANIMATION_DURATION/2.0)*[panGestureRecognizer velocityInView:[gestureView superview]].x;
            vX = (FAST_ANIMATION_DURATION/2.0)*[panGestureRecognizer velocityInView:self.view].x;
            newTXOfOpenCell = vX + gestureView.transform.tx;
           
            if (newTXOfOpenCell > threshold) {
                [self snapView:gestureView toX:CELL_CLOSED_X animated:YES];
                self.openCellLastTX = 0;
            } else {
                [self snapView:gestureView toX:CELL_OPEN_X animated:YES];
                self.openCellLastTX = gestureView.transform.tx;
                self.openGestureView = gestureView;
            }
            break;
        default:
            break;
    }
}
#pragma mark - Table view delegate

-(void) refresh {
    [self performSelector:@selector(refreshLabUsage) withObject:nil afterDelay:2.0];
}

-(void) refreshLabUsage {
    [self.dataController pollCurrentLabUsage];
    [self.tableView reloadData];
    //[self stopLoading];
}


@end
