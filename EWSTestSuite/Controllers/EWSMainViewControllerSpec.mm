#import "EWSMainViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

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
    });
    
    context(@"valid protocols", ^{
        it(@"should conform to UITableView delegate and datasource protocols", ^{
            [mainVC conformsToProtocol:@protocol(UITableViewDelegate)] should be_truthy;
            [mainVC conformsToProtocol:@protocol(UITableViewDataSource)] should be_truthy;
        });
    });
    
});

SPEC_END
