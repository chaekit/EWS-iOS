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
#import <QuartzCore/QuartzCore.h>

@interface EWSViewController ()
@end

@implementation EWSViewController

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
    [super viewDidAppear:animated];
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
    UILabel *fractionText;
    UIView *loadingView;
    UITableViewCell *cell;
    UIPanGestureRecognizer *panGestureRecognizer;
    static NSString *CellIdentifier = @"LabInfoCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryView = UITableViewCellAccessoryNone;
    }
    
    nameLabel = (UILabel*)[cell.contentView viewWithTag:3];
    fractionText = (UILabel*)[cell.contentView viewWithTag:1];
    loadingView = (UIView *)[cell.contentView viewWithTag:4];

//    progressView = (UIProgressView*)[cell.contentView viewWithTag:2];
//    progressView.progressViewStyle = UIProgressViewStyleBar;
    
    Lab *labAtIndex = [self.dataController objectAtIndex:indexPath.row];
    NSString *usageInString = [NSString stringWithFormat:@"%d/%d", labAtIndex.currentLabUsage, labAtIndex.maxCapacity];
    [nameLabel setText:labAtIndex.name];
    [fractionText setText:usageInString];
    
//    [progressView setProgress:(double)labAtIndex.currentLabUsage/(double)labAtIndex.maxCapacity];

    double widthBasedOnUsage = ((double) labAtIndex.currentLabUsage/(double)labAtIndex.maxCapacity)*320;
    [loadingView setFrame:CGRectMake(loadingView.frame.origin.x, loadingView.frame.origin.y, widthBasedOnUsage, loadingView.frame.size.height)];
    loadingView.alpha = widthBasedOnUsage/320;
   
    //Added Gesture
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGestureRecognizer setDelegate:self];
    [cell addGestureRecognizer:panGestureRecognizer];
    //[UIView beginAnimations:@"" context:nil];
    //[UIView setAnimationDuration:5.0f];
    //[UIView commitAnimations];
    
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

#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowLabDetails"]) {
        EWSDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.ewsLab = [self.dataController objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}




#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
}

@end
