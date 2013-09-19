#import <CoreData/CoreData.h>
#import "EWSMainViewController.h"
#import "EWSAPIClient.h"
#import "EWSMainLabTableViewCell.h"
#import "SpecFactories.h"
#import <objc/runtime.h>

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface EWSMainViewController (SpecTest)

@property (nonatomic, strong) NSFetchedResultsController *fetchedRequestController;

@end

SPEC_BEGIN(EWSMainViewControllerSpec)

describe(@"EWSMainViewController", ^{
    __block EWSMainViewController<UITableViewDataSource, UITableViewDelegate, EWSMainLabTableViewCellLabNotificationProtocol>
    *mainVC;

    beforeEach(^{
        mainVC = [[EWSMainViewController alloc] initWithNibName:nil bundle:nil];
        [mainVC viewDidLoad];
        NSLog(@"mainVc conforms   %@", [NSNumber numberWithBool:[mainVC conformsToProtocol:@protocol(UITableViewDelegate)]]);
        NSLog(@"mainVc conforms   %@", [NSNumber numberWithBool:[mainVC conformsToProtocol:@protocol(UITableViewDataSource)]]);

        spy_on(mainVC);
        
        mainVC stub_method("showProgressHudWhilePolling");
        mainVC stub_method("updateLabUsage");
    });
    
    context(@"valid properties", ^{
        it(@"should have a blackOpaqueStatusBar", ^{
            [mainVC preferredStatusBarStyle] should equal(UIStatusBarStyleLightContent);
        });
        it(@"should have a mainTableView", ^{
            [mainVC respondsToSelector:@selector(mainTableView)] should be_truthy;
        });
        
        describe(@"mainTableView", ^{
            it(@"should have mainVC as its delegates for protocols", ^{
                mainVC.mainTableView.delegate should equal(mainVC);
                mainVC.mainTableView.dataSource should equal(mainVC);
            });
        });
        
        context(@"private properties", ^{
            describe(@"fetchedRequestController", ^{
                it(@"should always return exactly one section", ^{
                    [[mainVC.fetchedRequestController sections] count] should equal(1);
                });
            });
        });
    });
    
    context(@"instance methods", ^{
        describe(@"#paramsForTicketCancellation", ^{
            __block NSDictionary *params;
            __block EWSLab *labForCancellation;
            
            beforeEach(^{
                labForCancellation = [EWSLab labFactoryWithStandardAttributes];
                mainVC.cellForCancellation = [[EWSMainLabTableViewCell alloc] init];
                mainVC.cellForCancellation.labObject = labForCancellation;

                spy_on([NSUserDefaults standardUserDefaults]);
                [NSUserDefaults standardUserDefaults] stub_method("objectForKey:").
                                                                    with(@"deviceToken").
                                                                    and_return(@"abcdef");
               
                params = [mainVC paramsForTicketCancellation];
            });
            
            it(@"should be an instance of NSDictionary", ^{
                params should be_instance_of([NSDictionary class]).or_any_subclass();
            });
            
            it(@"should have 'ticket' as the root key", ^{
                params[@"ticket"] != nil should be_truthy;
            });
            
            
            context(@"subkeys", ^{
                describe(@"labname key", ^{
                    it(@"should have labname key", ^{
                        params[@"ticket"][@"labname"] != nil should be_truthy;
                    });
                    
                    it(@"should equal the labname property of cellForCancellation.labObject", ^{
                        params[@"ticket"][@"labname"] should equal(@"DCL 416");
                    });
                });
                
                describe(@"devicetoken key", ^{
                    it(@"should have devicetoken key", ^{
                        params[@"ticket"][@"devicetoken"] != nil should be_truthy;
                    });
                    
                    it(@"should equal deviceToken key in NSUserDefaults", ^{
                        params[@"ticket"][@"devicetoken"] should equal(@"abcdef");
                    });
                });
            });
            
            afterEach(^{
                mainVC.cellForCancellation = nil;
            });
        });
    });
 
    context(@"UITableViewProtocol methods", ^{
        describe(@"tableView:heightForRowAtIndexPath:", ^{
            it(@"should return 64", ^{
                CGFloat height = [mainVC tableView:mainVC.mainTableView heightForRowAtIndexPath:nil];
                height should equal(64);
            });
        });
    });
    
    context(@"UIAlertViewDelegate methods", ^{
        describe(@"alertView:ClickedButtonAtIndex:", ^{
            __block EWSMainLabTableViewCell *cell;
            __block UIAlertView *testAlertView;
            
            beforeEach(^{
                cell = [[EWSMainLabTableViewCell alloc] init];
                mainVC.cellForCancellation = cell;
                testAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                           message:nil
                                                          delegate:mainVC
                                                 cancelButtonTitle:@"wtf"
                                                 otherButtonTitles:@"hi", nil];
            });
            
            context(@"when the user decides to cancel", ^{
                it(@"should unregister the cell at index 0", ^{
                    EWSMainLabTableViewCell *dummyCell = mainVC.cellForCancellation;
                    spy_on(dummyCell);
                    [mainVC alertView:testAlertView clickedButtonAtIndex:0];
                    dummyCell should have_received("markAsUnregistered");
                    dummyCell = nil;
                });
                
                it(@"should send delete request to the server", ^{
                    spy_on([EWSAPIClient sharedAPIClient]);
                    [mainVC alertView:testAlertView clickedButtonAtIndex:0];
                    [EWSAPIClient sharedAPIClient] should have_received("deleteNotificationParams:Success:Failure:");
                });
            
                it(@"should clear the cellForCancellation", ^{
                    spy_on(mainVC.cellForCancellation);
                    [mainVC alertView:testAlertView clickedButtonAtIndex:0];
                    mainVC.cellForCancellation == nil should be_truthy;
                });
            });
          
            context(@"when the user decides not to cancel", ^{
                it(@"should clear the cellForCancellation", ^{
                    spy_on(mainVC.cellForCancellation);
                    [mainVC alertView:testAlertView clickedButtonAtIndex:0];
                    mainVC.cellForCancellation == nil should be_truthy;
                });
            });
        });
    });

    context(@"EWSMainLabTableViewCellLabNotificationProtocol methods", ^{
        describe(@"#userTappedTicketStatusButton:", ^{
            context(@"lab eligibility", ^{
                __block EWSMainLabTableViewCell *testCell;
                
                beforeEach(^{
                    testCell = [[EWSMainLabTableViewCell alloc] init];
                    [testCell setDelegate:mainVC];
                    spy_on(mainVC);
                    mainVC stub_method("showAlertViewForIneligibleLabNotification");
                    mainVC stub_method("promptRegistrationCancellation:");
                });
                
                it(@"should present a modalViewController if it is eligible for notification", ^{
                    EWSLab *eligibleLab = [EWSLab labFactoryValidForNotification];
                    [testCell setLabObject:eligibleLab];
                    [mainVC userTappedTicketStatusButton:testCell];
                    mainVC should have_received("presentViewController:animated:completion:");
                });
                
                it(@"should not present a modalViewController if it is ineligible for notification", ^{
                    EWSLab *ineligibleLab = [EWSLab labFactoryNotValidForNotification];
                    [testCell setLabObject:ineligibleLab];
                    [mainVC userTappedTicketStatusButton:testCell];
                    mainVC should_not have_received("presentViewController:animated:completion:");
                });
                
                it(@"should show an alertView when the lab is ineligible for notification", ^{
                    EWSLab *ineligibleLab = [EWSLab labFactoryNotValidForNotification];
                    [testCell setLabObject:ineligibleLab];
                    //                mainVC stub_method("showAlertViewForIneligibleLabNotification");
                    [mainVC userTappedTicketStatusButton:testCell];
                    mainVC should have_received("showAlertViewForIneligibleLabNotification");
                });
                
            });
            
            context(@"when the cell is already registered", ^{
                __block EWSMainLabTableViewCell *testCell;
                
                beforeEach(^{
                    testCell = [[EWSMainLabTableViewCell alloc] init];
                    [testCell setLabObject:[EWSLab labFactoryRegisteredForNotification]];
                    [testCell setDelegate:mainVC];
                });
                
                it(@"should not present notificationViewController", ^{
                    spy_on(mainVC);
                    mainVC stub_method("promptRegistrationCancellation:");
                    [mainVC userTappedTicketStatusButton:testCell];
                    mainVC should_not have_received("presentViewController:animated:completion:");
                });
                
                it(@"should call promptRegistrationCancellation", ^{
                    spy_on(mainVC);
                    mainVC stub_method("promptRegistrationCancellation:");
                    [mainVC userTappedTicketStatusButton:testCell];
                    mainVC should have_received("promptRegistrationCancellation:");
                });
            });
        });
    });
    
});

SPEC_END
