//
//  EWSNotificationViewController.m
//  EWS
//
//  Created by Jay Chae  on 9/11/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import "EWSNotificationViewController.h"
#import "EWSAPIClient.h"
#import "EWSLab.h"
#import "EWSMainLabTableViewCell.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface EWSNotificationViewController ()

@end

@implementation EWSNotificationViewController

@synthesize timePickerView;
@synthesize titlesForTimePickerView;
@synthesize confirmationButton;
@synthesize cellObject;
@synthesize cancelButton;
@synthesize openStationSegmentControl;
@synthesize menuToolBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initAllProperties];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initAllSubViews];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

/* @private */

- (void)_initAllSubViews {
    [self _initTimePickerView];
    [self _initConfirmationButton];
    [self _initCancelButton];
    [self _initMenuToolBar];
    [self _initOpenSegmentControl];
}

- (void)_initAllProperties {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self setTitlesForTimePickerView:@[@"1 hour",
                                       @"2 hours",
                                       @"3 hours",
                                       @"4 hours",
                                       @"5 hours"]];
}


/* @private */

- (void)_initConfirmationButton {
    CGRect frame = CGRectMake(103, 467, 114, 30);
    
    confirmationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confirmationButton setFrame:frame];
    [confirmationButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmationButton addTarget:self
                           action:@selector(userConfirmedNotification:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmationButton];
}

/* @private */

- (void)_initCancelButton {
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                 target:self
                                                                 action:@selector(dismissNotificationViewController)];
}

/* @private */

- (void)_initMenuToolBar {
    CGRect frame = CGRectMake(0, 0, 320, 44);
    menuToolBar = [[UIToolbar alloc] initWithFrame:frame];
    [menuToolBar setItems:@[cancelButton]];
    
    [self.view addSubview:menuToolBar];
}


- (void)dismissNotificationViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/* Triggered when the user taps the confirmation button */

- (void)userConfirmedNotification:(id)sender {
    if ([self _hasAllUIInputs] == NO) return;
 
    NSDictionary *params = [self paramsForLabNotification];

    [[EWSAPIClient sharedAPIClient] registerNotificationParams:params Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
    [SVProgressHUD showSuccessWithStatus:@"Done!"];
    [self.cellObject markAsRegistered];
//    [self.cellObject.labObject setRegisteredForNotification:[NSNumber numberWithBool:YES]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma Request param builder

- (BOOL)_hasAllUIInputs {
    if (openStationSegmentControl.selectedSegmentIndex == -1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"wtf"
                                                            message:@"wtf"
                                                           delegate:nil
                                                  cancelButtonTitle:@"wtf"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)requestedLabName {
    return cellObject.labObject.labName;
}

- (NSNumber *)requestedOpenLabCount {
    NSUInteger selectedIndex = openStationSegmentControl.selectedSegmentIndex;
    NSString *selectedTitle = [openStationSegmentControl titleForSegmentAtIndex:selectedIndex];
    NSInteger selectedLabCountInNumber = [selectedTitle integerValue];
    NSLog(@"selectedLabCount   %d", selectedLabCountInNumber);
    
    return [NSNumber numberWithInteger:selectedLabCountInNumber];
}

- (NSNumber *)requestedExpirationDateInCtime {
    NSInteger selectedRow = [timePickerView selectedRowInComponent:0];
    NSString *selectedTimeInString = [titlesForTimePickerView[selectedRow] componentsSeparatedByString:@" "][0];
    
    NSTimeInterval expirationDateInInteger = (NSInteger)[[NSDate date] timeIntervalSince1970];
    expirationDateInInteger += [selectedTimeInString integerValue] * 60;
    NSNumber *expirationDate = @(expirationDateInInteger);
    return expirationDate;
}

- (NSString *)requestedDeviceToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
}


- (NSDictionary *)paramsForLabNotification {
    
    NSString *requestedLabName = [self requestedLabName];
    NSString *requestedDeviceToken = [self requestedDeviceToken];
    NSNumber *requestedExpirationDate = [self requestedExpirationDateInCtime];
    NSNumber *requestedOpenLabCount = [self requestedOpenLabCount];
    
    if (requestedDeviceToken == nil) {
        @throw NSInvalidArgumentException;
    }
    
    NSDictionary *retVal = @{@"ticket" :
                                @{@"expires_at": requestedExpirationDate,
                                  @"labname": requestedLabName,
                                  @"requested_size": requestedOpenLabCount,
                                  @"device_token": requestedDeviceToken }
                            };

    return retVal;
}

/* @private */

- (void)_initTimePickerView {
    CGRect frame = CGRectMake(0, 239, 320, 162);
    
    timePickerView = [[UIPickerView alloc] initWithFrame:frame];
    [timePickerView setDelegate:self];
    [timePickerView setDataSource:self];
    
    [self.view addSubview:timePickerView];
}

/* @private */

- (void)_initOpenSegmentControl {
    CGRect frame = CGRectMake(43, 189, 235, 28);
    
    NSArray *items = @[@"5 Stations", @"10 stations"];
    openStationSegmentControl = [[UISegmentedControl alloc] initWithItems:items];
    [openStationSegmentControl setFrame:frame];
    
    [self.view addSubview:openStationSegmentControl];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [titlesForTimePickerView objectAtIndex:row];
}


@end
