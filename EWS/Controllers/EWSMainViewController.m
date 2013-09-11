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
    [self _initFetchedRequestController];
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

- (void)_initAllSubViews {
    [self _initMainTableView];
}

/* @private */

- (void)_initMainTableView {
    CGRect frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    mainTableView = [[UITableView alloc] initWithFrame:frame];
    [mainTableView setDelegate:self];
    [mainTableView setDataSource:self];
    
    [self.view addSubview:mainTableView];
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
    }
    
    NSArray *fetchedLabs = [[fetchedRequestController sections][0] objects];
//    NSLog(@"lab  %@", [((EWSLab *)[fetchedLabs objectAtIndex:indexPath.row]) valueForKey:@"labName"]);
    [cell updateWithLab:[fetchedLabs objectAtIndex:indexPath.row]];
    return cell;
}


@end
