//
//  EWSViewController.m
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "EWSViewController.h"
#import "EWSDataController.h"
#import "EWSDetailViewController.h"
#import "Lab.h"
#import "EWSCustomCell.h"
#import <QuartzCore/QuartzCore.h>

#define FAST_ANIMATION_DURATION 0.35
#define SLOW_ANIMATION_DURATION 0.75
#define PAN_CLOSED_X 0
#define PAN_OPEN_X -500

#define CELL_OPEN_X -500
#define CELL_CLOSED_X 0

@interface EWSViewController ()
@end

@implementation EWSViewController
@synthesize openCellLastTX, openCellIndexPath;

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[EWSDataController alloc] init];
}

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    //[super viewDidAppear:animated];
    [machinesTableView reloadData];
    
    //[UIView beginAnimations:@"fade out" context:nil];
    //[UIView setAnimationDuration:1.0f];
    //[UIView setAnimationRepeatAutoreverses:YES];
    //machinesTableView.transform =  CGAffineTransformMakeRotation(3.14159623);
    //[UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataController countOfMainLabList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Interfaces
    UILabel *nameLabel;
    //UILabel *fractionText;
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

    double widthBasedOnUsage = ((double) labAtIndex.currentLabUsage/(double)labAtIndex.maxCapacity)*320;
    [meterView setFrame:CGRectMake(meterView.frame.origin.x, meterView.frame.origin.y, widthBasedOnUsage, meterView.frame.size.height)];
    meterView.alpha = widthBasedOnUsage/320;

    // Gesture initialization
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGestureRecognizer setDelegate:self];
    [cell.meterView addGestureRecognizer:panGestureRecognizer];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Demo gesture handler
-(void) handlePan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    float threshold = (PAN_OPEN_X+PAN_CLOSED_X)/2.0;
    UIView *gestureView = [panGestureRecognizer view];
    CGPoint translation;
    float vX = 0.0;
    float newTXOfOpenCell;
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.openCellLastTX = 0.0;
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
            NSLog(@"updating TX     %f", newTXOfOpenCell);
            break;
        case UIGestureRecognizerStateEnded:
            // WTF is this
            //vX = (FAST_ANIMATION_DURATION/2.0)*[panGestureRecognizer velocityInView:[gestureView superview]].x;
            vX = (FAST_ANIMATION_DURATION/2.0)*[panGestureRecognizer velocityInView:self.view].x;
            newTXOfOpenCell = vX + gestureView.transform.tx;
           
            if (newTXOfOpenCell < threshold) {
                [self snapView:gestureView toX:CELL_OPEN_X animated:YES];
                self.openCellLastTX = gestureView.transform.tx;
//                NSLog(@"Snapped open, transfor TX %f", gestureView.transform.tx);
            } else {
                [self snapView:gestureView toX:CELL_CLOSED_X animated:YES];
                self.openCellLastTX = 0;
//                NSLog(@"Snapped CLOSED, transfor TX %f", gestureView.transform.tx);
            }
            
//            NSLog(@"the view is  %@", [gestureView superview]);
//            NSLog(@"self view is  %@", self.view);
//            NSLog(@"self is  %@", self);
            break;
        default:
            break;
    }
}



#pragma mark - Gesture recognizer delegate
//- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
//{
//    NSLog(@"SHould begin");
//    NSLog(@"%@", self.openCellIndexPath);
//    EWSCustomCell *cell = (EWSCustomCell *)[panGestureRecognizer view];
//    CGPoint translation = [panGestureRecognizer translationInView:[cell superview] ];
//    //NSLog(@"Super View %@", [cell superview]);
//    NSLog(@"The cell : %@", cell);
//    (fabs(translation.x) / fabs(translation.y) > 1) ? NSLog(@"YESSSS") : NSLog(@"NOOOOO");
//    NSLog(@"-------");
//    //return YES;
//    return (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
//}
//
//#pragma mark - Gesture handlers
//
//-(void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer
//{
//    
//    float threshold = (PAN_OPEN_X+PAN_CLOSED_X)/2.0;
//    float vX = 0.0;
//    float compare;
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:(EWSCustomCell *)[panGestureRecognizer view]];
//    UIView *view = ((EWSCustomCell *)panGestureRecognizer.view).meterView;
//    //UIView *view = panGestureRecognizer.view;
//    
//    switch ([panGestureRecognizer state]) {
//        case UIGestureRecognizerStateBegan:
//            if (self.openCellIndexPath.section != indexPath.section || self.openCellIndexPath.row != indexPath.row) {
//                [self snapView:((EWSCustomCell *)[self.tableView cellForRowAtIndexPath:self.openCellIndexPath]).meterView toX:PAN_CLOSED_X animated:YES];
//                [self setOpenCellIndexPath:nil];
//                [self setOpenCellLastTX:0];
//            }
//           
//            NSLog(@"Started");
//            NSLog(@"indexPath bro %@", indexPath);
//            NSLog(@"--------");
//            break;
//        case UIGestureRecognizerStateEnded:
//            vX = (FAST_ANIMATION_DURATION/2.0)*[panGestureRecognizer velocityInView:self.view].x;
//            compare = view.transform.tx + vX;
//            if (compare > threshold) {
//                [self snapView:view toX:PAN_CLOSED_X animated:YES];
//                [self setOpenCellIndexPath:nil];
//                [self setOpenCellLastTX:0];
//            } else {
//                [self snapView:view toX:PAN_OPEN_X animated:YES];
//                [self setOpenCellIndexPath:[self.tableView indexPathForCell:(EWSCustomCell *)panGestureRecognizer.view] ];
//                [self setOpenCellLastTX:view.transform.tx];
//            }
//            NSLog(@"Ended");
//            NSLog(@"%@", self.openCellIndexPath);
//            NSLog(@"--------");
//            break;
//        case UIGestureRecognizerStateChanged:
//            compare = self.openCellLastTX+[panGestureRecognizer translationInView:self.view].x;
//            if (compare > PAN_CLOSED_X)
//                compare = PAN_CLOSED_X;
//            else if (compare < PAN_OPEN_X)
//                compare = PAN_OPEN_X;
//            [view setTransform:CGAffineTransformMakeTranslation(compare, 0)];
//            
//            NSLog(@"Changing");
//            //NSLog(@"%@", self.openCellIndexPath);
//            break;
//        default:
//            NSLog(@"Didn't WOrk");
//            break;
//    }
//}
-(void)snapView:(UIView *)view toX:(float)x animated:(BOOL)animated
{
    NSLog(@"SnapView");
    NSLog(@"Snapview  X  %f", view.transform.tx);
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

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"ShowLabDetails"]) {
//        EWSDetailViewController *detailViewController = [segue destinationViewController];
//        detailViewController.ewsLab = [self.dataController objectAtIndex:[self.tableView indexPathForSelectedRow].row];
//    }
//}
@end
