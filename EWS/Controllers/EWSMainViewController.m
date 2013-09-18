//
//  EWSMainViewController.m
//  EWS
//
//  Created by Jay Chae  on 9/10/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "EWSMainViewController.h"
#import "EWSMainLabTableViewCell.h"
#import "EWSSharedProjectConstants.h"
#import "EWSDataModel.h"
#import "EWSLab.h"
#import "EWSAPIClient.h"
#import "EWSNotificationViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

static EWSMainLabTableViewCell *potentialCellForCancellation = nil;

@interface EWSMainViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedRequestController;

@end

@implementation EWSMainViewController

@synthesize mainTableView;
@synthesize fetchedRequestController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initAllProperties];
    [self _initFetchedRequestController];
    [self updateLabUsage];
    [self _initAllSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* @private */

- (void)_initFetchedRequestController {
    NSManagedObjectContext *mainContext = [[EWSDataModel sharedDataModel] mainContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"EWSLab"
                                   inManagedObjectContext:mainContext]];
  
    NSArray *sortArray = @[[[NSSortDescriptor alloc] initWithKey:@"labIndex" ascending:YES]];
    [request setSortDescriptors:sortArray];
    [request setReturnsObjectsAsFaults:NO];
    fetchedRequestController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                   managedObjectContext:mainContext
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:@"Master"];
    NSError *error;
    [fetchedRequestController performFetch:&error];
    if (error) {
        NSLog(@"Could not perform fetch");
    }
}

- (NSMutableArray *)fetchedLabObjects {
    NSArray<NSFetchedResultsSectionInfo> *sections = [fetchedRequestController sections][0];
    return [[sections objects] mutableCopy];
}

- (void)updateLabUsage {
    [self showProgressHudWhilePolling];
    [[EWSAPIClient sharedAPIClient] pollUsageFromAPISucess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self matchAndUpdateLabUsage:responseObject];
        [self.mainTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"Done!"];
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Failed to Update!"];
    }];
}

- (void)matchAndUpdateLabUsage:(id)responseObject {
    NSArray *labData = responseObject[@"data"];
    NSMutableArray *fetchedLabData = [self fetchedLabObjects];
    for (NSInteger i = 0; i < [labData count]; i++) {
        for (NSInteger j= 0; j < [fetchedLabData count];  j++) {
            BOOL isMatching = [labData[i][@"labname"] isEqualToString:[fetchedLabData[j] labName]];
            if (isMatching) {
                EWSLab *fetchedLabObject = (EWSLab *)fetchedLabData[j];
                [fetchedLabObject updateWithJSON:labData[i]];
            }
        }
    }
}

/* @private */

- (void)_initAllProperties {

    [self setEdgesForExtendedLayout:UIRectEdgeNone];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


/* @private */
- (void)_initAllSubViews {
    [self _initMainTableView];
}

/* @private */

- (void)showProgressHudWhilePolling {
    [SVProgressHUD showWithStatus:@"Updating Usage"];
}

- (void)_initMainTableView {
    CGRect frame = CGRectMake(0, 20, 320, self.view.frame.size.height - 20);
    mainTableView = [[UITableView alloc] initWithFrame:frame];
    [mainTableView setDelegate:self];
    [mainTableView setDataSource:self];
    
    [self.view addSubview:mainTableView];
}

#pragma mark -
#pragma EWSMainLabTableViewCellLabNotificationProtocol methods

- (void)userTappedTicketStatusButton:(EWSMainLabTableViewCell *)cell {
    EWSLab *correspondingLab = cell.labObject;
    if ([[correspondingLab registeredForNotification] boolValue]) {
        [self promptRegistrationCancellation:cell];
    } else if ([correspondingLab isValidForNotification]) {
        EWSNotificationViewController *notificationVC = [[EWSNotificationViewController alloc] initWithNibName:nil
                                                                                                    bundle:nil];
        [notificationVC setCellObject:cell];
        [self presentViewController:notificationVC animated:YES completion:nil];
    } else {
        [self showAlertViewForIneligibleLabNotification];
    }
}

+ (EWSMainLabTableViewCell *)potentialCellForCancellation {
    return potentialCellForCancellation;
}

- (void)showAlertViewForIneligibleLabNotification {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoa"
                                                        message:@"There are enough machines. Carry on"
                                                       delegate:self
                                              cancelButtonTitle:@"Cool"
                                              otherButtonTitles: nil];
    [alertView show];
}

- (void)promptRegistrationCancellation:(EWSMainLabTableViewCell *)cell {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You Sure?"
                                                        message:@"this will cancel notification"
                                                       delegate:self
                                              cancelButtonTitle:@"Yeah"
                                              otherButtonTitles:@"Oops", nil];
    potentialCellForCancellation = cell;
    [alertView show];
}


#pragma mark -
#pragma UIAlertViewProtocol methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { //clicked Yeah
        [potentialCellForCancellation markAsRegistered];
        return;
    } else if (buttonIndex == 1) {
        return;
    } else {
        return;
    }
    
    potentialCellForCancellation = nil; //makes sure tha this is always clean
}

#pragma mark -
#pragma UITableViewProtocol methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [fetchedRequestController sections];
    return [sections[0] numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedRequestController sections] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EWSMainLabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UNREGISTERED_CELL_IDENTIFIER];
    
    if (cell == nil) {
        cell = [[EWSMainLabTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UNREGISTERED_CELL_IDENTIFIER];
        [cell setDelegate:self];
    }
    
    NSArray *fetchedLabs = [self fetchedLabObjects];
    [cell updateWithLab:[fetchedLabs objectAtIndex:indexPath.row]];
    return cell;
}
@end
