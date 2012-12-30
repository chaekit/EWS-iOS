//
//  EWSViewController.m
//  EWS
//
//  Created by Jay Chae  on 12/5/12.
//  Copyright (c) 2012 com.chaebacca. All rights reserved.
//

#import "Lab.h"
#import "EWSPageController.h"
#import "EWSViewController.h"
#import "EWSDataController.h"
#import "EWSCustomCell.h"
#import "EWSLabDetailViewController.h"

//Frameworks
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#define FAST_ANIMATION_DURATION 0.35
#define SLOW_ANIMATION_DURATION 0.75

#define CELL_OPEN_X -300
#define CELL_CLOSED_X 0

#define NUM_OF_CTRL_PAGES 2

@interface EWSViewController ()

@property (nonatomic) int previousPage;
@property (nonatomic) float openCellLastTX;
@property (nonatomic, strong) UIView *openGestureView;
- (void)snapView:(UIView *)view toX:(float)x animated:(BOOL)animated;
- (void)initPageControViews;

@end

@implementation EWSViewController

@synthesize pageControlView, pageControl, previousPage;

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[EWSDataController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initPageControViews];
    self.setOfTableViewCells = [[NSMutableSet alloc] init];
}

-(void)viewDidAppear:(BOOL)animated {
    //[super viewDidAppear:animated];
    [machinesTableView reloadData];

    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    return NO;
}

-(void)initPageControViews
{
    [self.view insertSubview:self.pageControl aboveSubview:pageControlView];

    previousPage = 0;
    
    pageControl.hidesForSinglePage = NO;
    pageControl.numberOfPages = NUM_OF_CTRL_PAGES;
    pageControl.currentPage = 0;

    // pageControlView initialization
    pageControlView.pagingEnabled = YES;
    pageControlView.delegate = self;
    pageControlView.showsVerticalScrollIndicator = NO;
    pageControlView.showsHorizontalScrollIndicator = NO;
    
    
    pageControlView.contentSize = CGSizeMake(pageControlView.frame.size.width * 2, pageControlView.frame.size.height);
   
    // pageController initialization
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataController countOfMainLabList];
}

static int numNils = 0;
static int numNonNils = 0;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Interfaces
    static NSString *CellIdentifier = @"LabInfoCell";
    EWSCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[EWSCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        numNils++;
    }
    Lab *labAtIndex = [self.dataController objectAtIndex:indexPath.row];
    [cell initSubViewsWithLab:labAtIndex];
    
    // Gesture initialization
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panGestureRecognizer setDelegate:self];
    [cell.meterContainerView addGestureRecognizer:panGestureRecognizer];
    
    
    //EXPERIMENT
    //[self.setOfTableViewCells addObject:cell];

    
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


#pragma mark - PullToRefresh method override

-(void) refresh {
    [self performSelector:@selector(refreshLabUsage) withObject:nil afterDelay:2.0];
}

-(void) refreshLabUsage {
    [self.dataController pollCurrentLabUsage];
    [self.tableView reloadData];
    //[self stopLoading];
}


#pragma mark - ScrollView delegate stuff

-(void) loadScrollViewWithPage:(NSInteger) page
{
    if (page < 0 || page >= NUM_OF_CTRL_PAGES)
        return;
   
    CGRect frame = self.pageControlView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;

    // Might need to change this later
    UIView *pgView = [[UIView alloc] initWithFrame:frame];

    [self.pageControlView addSubview:pgView];

    UILabel *pageControlLabel = [[UILabel alloc] init];
    [pageControlLabel setFrame:CGRectMake(118 + 320 * page, 23, 90, 21)];
    [pageControlLabel setBackgroundColor:[UIColor clearColor]];
    [pageControlLabel setTextColor:[UIColor whiteColor]];
    [pageControlLabel setFont:[UIFont fontWithName:@"Futura" size:17]];
    [pageControlLabel setTextAlignment:NSTextAlignmentCenter];
    [self.pageControlView addSubview:pageControlLabel];
    
    if (page == 0) {
        [pageControlLabel setText:@"Glance"];
    } else if (page == 1) {
        [pageControlLabel setText:@"Detail"];
    }
}


-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"tableView   %@", self.tableView);
    NSLog(@"visible Cells   %@", self.tableView.visibleCells);
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.pageControlView.frame.size.width;
   
    float contentOffset = self.pageControlView.contentOffset.x;
    
    int newPage = floor((self.pageControlView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = newPage;
    
    if (contentOffset <= 320.000 && contentOffset >= 0.0f) {
        if (previousPage == 0) {
            [self.pageControlView setAlpha:(1 - contentOffset/320 * 0.5)];
        } else {
            [self.pageControlView setAlpha:(0.5 + (320 - contentOffset)/320 * 0.5)];
        }
    }
    
    float viewTXofCell = 0;
    viewTXofCell -= contentOffset;

    // Doesn't pass beyond the left boundary of the screen when it is on glancemode
    if (viewTXofCell < 0) {
        [self.tableView.visibleCells makeObjectsPerformSelector:@selector(scrollMeterViewWithPageControl:) withObject:[NSNumber numberWithFloat:viewTXofCell]];
        //[self.setOfTableViewCells makeObjectsPerformSelector:@selector(scrollMeterViewWithPageControl:) withObject:[NSNumber numberWithFloat:viewTXofCell]];
    }

    NSLog(@"WTFFFFFFFFFFFFF");
}


#pragma UIScrollViewDelegate methods

// At the end of scroll set lastPage for alpha manipulation
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    previousPage = pageControl.currentPage;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowLabDetail"]) {
        EWSLabDetailViewController *labDetailViewController = [segue destinationViewController];
        labDetailViewController.lab = [self.dataController objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

@end