#import <CoreData/CoreData.h>
#import "EWSMainViewController.h"
#import "EWSAPIClient.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface EWSMainViewController (SpecTest)

@property (nonatomic, strong) NSFetchedResultsController *fetchedRequestController;

@end

SPEC_BEGIN(EWSMainViewControllerSpec)

describe(@"EWSMainViewController", ^{
    __block EWSMainViewController *mainVC;

    beforeEach(^{
        mainVC = [[EWSMainViewController alloc] initWithNibName:nil bundle:nil];
        [mainVC viewDidLoad];
    });
    
    context(@"valid properties", ^{
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
                
                it(@"should always return 13 elements in the section", ^{
                    NSArray *sections = mainVC.fetchedRequestController.sections;
                    [[sections[0] objects] count] should equal(13);
                });
            });
        });
        
    });
    
    context(@"instance methods", ^{
        describe(@"updateLabUsage:Success:Failure", ^{
            it(@"should call pollLabUsage:Success:Failure using EWSAPIClient", ^{
                
            });
        });
    });
    
    context(@"valid protocols", ^{
        it(@"should conform to UITableView delegate and datasource protocols", ^{
            [mainVC conformsToProtocol:@protocol(UITableViewDelegate)] should be_truthy;
            [mainVC conformsToProtocol:@protocol(UITableViewDataSource)] should be_truthy;
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
    
});

SPEC_END
