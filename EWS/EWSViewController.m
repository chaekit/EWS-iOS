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

#import <QuartzCore/QuartzCore.h>


#define FAST_ANIMATION_DURATION 0.35
#define SLOW_ANIMATION_DURATION 0.75

#define CELL_OPEN_X -300
#define CELL_CLOSED_X 0

#define NUM_OF_CTRL_PAGES 2

@interface EWSViewController ()

@property (nonatomic, strong) UIView *meterView1;
@property (nonatomic, strong) UIView *meterView2;
@property (nonatomic, strong) UIView *meterView3;
@property (nonatomic, strong) UIView *meterView4;
@property (nonatomic, strong) UIView *meterView5;
@property (nonatomic, strong) UIView *meterView6;
@property (nonatomic, strong) UIView *meterView7;
@property (nonatomic, strong) UIView *meterView8;
@property (nonatomic, strong) UIView *meterView9;
@property (nonatomic, strong) UIView *meterView10;
@property (nonatomic, strong) UIView *meterView11;
@property (nonatomic, strong) UIView *meterView12;
@property (nonatomic, strong) UIView *meterView13;

@end

@implementation EWSViewController

@synthesize pageControlView;
@synthesize meterView1, meterView2, meterView3, meterView4, meterView5, meterView6, meterView7, meterView8, meterView9,
    meterView10, meterView11, meterView12, meterView13;

@synthesize pageControl, tableViewInGlanceMode;

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[EWSDataController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view insertSubview:self.pageControl aboveSubview:pageControlView];
    
    pageControl.hidesForSinglePage = NO;
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;

    // pageControlView initialization
    self.pageControlView.pagingEnabled = YES;
    self.pageControlView.delegate = self;
    self.pageControlView.showsVerticalScrollIndicator = NO;
    self.pageControlView.showsHorizontalScrollIndicator = NO;
    
    
    self.pageControlView.contentSize = CGSizeMake(self.pageControlView.frame.size.width * 2, self.pageControlView.frame.size.height);
   
    // pageController initialization
    self.pageControllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        [self.pageControllers addObject:[NSNull null]];
    }
    
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    //[self.view insertSubview:self.pageControlView aboveSubview:self.tableView];
    
    // Experiment
    
    self.meterViewArray = [[NSMutableArray alloc] initWithCapacity:13];
    for (NSInteger i = 0; i < 10; i++) {
        self.meterViewArray[i] = [NSNull null];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    //[super viewDidAppear:animated];
    [machinesTableView reloadData];
    
    meterView1 = [self.meterViewArray objectAtIndex:0];
    meterView2 = [self.meterViewArray objectAtIndex:1];
    meterView3 = [self.meterViewArray objectAtIndex:2];
    meterView4 = [self.meterViewArray objectAtIndex:3];
    meterView5 = [self.meterViewArray objectAtIndex:4];
    meterView6 = [self.meterViewArray objectAtIndex:5];
    meterView7 = [self.meterViewArray objectAtIndex:6];
    meterView8 = [self.meterViewArray objectAtIndex:7];
    meterView9 = [self.meterViewArray objectAtIndex:8];
    meterView10 = [self.meterViewArray objectAtIndex:9];
    meterView11 = [self.meterViewArray objectAtIndex:10];
//    meterView12 = [self.meterViewArray objectAtIndex:11];
//    meterView13 = [self.meterViewArray objectAtIndex:12];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate
{
    return NO;
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


static int cellCounter = 0;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Interfaces
    static NSString *CellIdentifier = @"LabInfoCell";
    EWSCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[EWSCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSLog(@"It was nil");
    }

    Lab *labAtIndex = [self.dataController objectAtIndex:indexPath.row];
    [cell initSubViewsWithLab:labAtIndex];
    
    // Gesture initialization
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panGestureRecognizer setDelegate:self];
    [cell.meterContainerView addGestureRecognizer:panGestureRecognizer];
    
    // experiment purpose@!#!@$@!#@$#!@#@!$
    
    if ([self.meterViewArray count] == 11) {
        [self.meterViewArray removeObjectAtIndex:0];
    }
    [self.meterViewArray addObject:cell.meterContainerView];


    NSLog(@"row reused  %d", indexPath.row);
    //NSLog(@"# of cells %d", cellCounter++);
    
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
    if (page < 0)
        return;
    if (page >= NUM_OF_CTRL_PAGES)
        return;
    
    // replace the placeholder if necessary
    EWSPageController *currentPageController = [self.pageControllers objectAtIndex:page];
    if ((NSNull *)currentPageController == [NSNull null])
    {
        currentPageController = [[EWSPageController alloc] initWithPageNumber:page];
        [self.pageControllers replaceObjectAtIndex:page withObject:currentPageController];
    }
    
    // add the controller's view to the scroll view
    if (currentPageController.view.superview == nil)
    {
        CGRect frame = self.pageControlView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        currentPageController.view.frame = frame;
        
        
        [self.pageControlView addSubview:currentPageController.view];

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
}

static float lastPage = 0;

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.pageControlView.frame.size.width;
   
    float contentOffset = self.pageControlView.contentOffset.x;
    
    int page = floor((self.pageControlView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    if (contentOffset <= 320.000 && contentOffset >= 0.0f) {
        if (lastPage == 0.0f) {
            [self.pageControlView setAlpha:(1 - contentOffset/320 * 0.5)];
        } else {
            [self.pageControlView setAlpha:(0.5 + (320 - contentOffset)/320 * 0.5)];
        }
    }
    NSLog(@"content offset %f", contentOffset);
  
    
    float viewTXofCell = 0;
    viewTXofCell -= contentOffset;

    // Doesn't pass beyond the left boundary of the screen when it is on glancemode
    if (viewTXofCell < 0) {
        [meterView1 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
        [meterView2 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
        [meterView3 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
        [meterView4 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
        [meterView5 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
        [meterView6 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
        [meterView7 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
        [meterView8 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
        [meterView9 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
        [meterView10 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
        [meterView11 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
    }
//    [meterView12 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
//    [meterView13 setTransform:CGAffineTransformMakeTranslation(viewTXofCell, 0)];
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

#pragma UIScrollViewDelegate methods

// At the end of scroll set lastPage for alpha manipulation
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    lastPage = pageControl.currentPage;
}

@end
