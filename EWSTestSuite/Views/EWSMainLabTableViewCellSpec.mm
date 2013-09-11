#import "EWSMainLabTableViewCell.h"
#import "EWSLab.h"
#import "EWSDataModel.h"
#import "SpecFactories.h"
#import "EWSMainViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(EWSMainLabTableViewCellSpec)

describe(@"EWSMainLabTableViewCell", ^{
    __block EWSMainLabTableViewCell *tableViewCell;

    beforeEach(^{
        tableViewCell = [[EWSMainLabTableViewCell alloc] init];
    });
    
    context(@"valid properties", ^{
        it(@"should respond to valid UI properties", ^{
            [tableViewCell respondsToSelector:@selector(labNameLabel)] should be_truthy;
            [tableViewCell respondsToSelector:@selector(labTicketStatusButton)] should be_truthy;
            [tableViewCell respondsToSelector:@selector(labDetailUsageLabel)] should be_truthy;
        });
        
        it(@"should have a dedicate EWSLab object", ^{
            [tableViewCell respondsToSelector:@selector(labObject)] should be_truthy;
        });
        
        it(@"should have 3 subviews in its contentView", ^{
            [tableViewCell.contentView.subviews count] should equal(3);
        });
        
        describe(@"labNameLabel", ^{
            it(@"should be an instance of UILabel", ^{
                tableViewCell.labNameLabel should be_instance_of([UILabel class]);
            });
        });
        
        describe(@"labTicketStatusButton", ^{
            it(@"should be an instance of UIButton", ^{
                tableViewCell.labTicketStatusButton should be_instance_of([UIButton class]);
            });
            
            it(@"should register for a push notification after tapping", ^{
                spy_on(tableViewCell);
                [tableViewCell.labTicketStatusButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                tableViewCell should have_received("registerForNotification:");
            });
        });
        
        describe(@"labDetailUsageLabel", ^{
            it(@"should an instance of UILabel", ^{
                tableViewCell.labDetailUsageLabel should be_instance_of([UILabel class]);
            });
        });
        
        context(@"before updateWithLab", ^{
            it(@"should have UI properties that do not have contents", ^{
                tableViewCell.labNameLabel.text == nil should be_truthy;
                tableViewCell.labDetailUsageLabel.text == nil should be_truthy;
                tableViewCell.labTicketStatusButton.imageView.image == nil should be_truthy;
            });
            it(@"should have a nil labObject property", ^{
                tableViewCell.labObject == nil should be_truthy;
            });
        });
        
        context(@"after updateWithLab", ^{
            beforeEach(^{
                [tableViewCell updateWithLab:[EWSLab labFactoryWithStandardAttributes]];
            });

            it(@"should have UI properties whose contents match labObject's", ^{
                EWSLab *lab = tableViewCell.labObject;
                tableViewCell.labNameLabel.text should equal(lab.labName);
                tableViewCell.labDetailUsageLabel.text should equal([lab usageFractionInString]);
            });

            xit(@"should have a labTicketStatusImageView that has an Image", ^{
                tableViewCell.labTicketStatusButton.imageView.image != nil should be_truthy;
            });
            
            it(@"should have a non nil labObject", ^{
                tableViewCell.labObject == nil should_not be_truthy;
            });
            
        });
    });
    
    
    context(@"valid instance methods", ^{
        describe(@"#updateWithLab:", ^{
            it(@"should throw an NSInvalidArgumentException if the argument is not an instance of EWSLab", ^{
                id bogusParam = @"bogus";
                ^{ [tableViewCell updateWithLab:bogusParam]; } should raise_exception([NSInvalidArgumentException class]);
            });
        });
        
        describe(@"#registerForNotification", ^{
            it(@"should send userTappedTicketStatusButtonCell: to the cell's delegate", ^{
                id<CedarDouble, EWSMainLabTableViewCellLabNotificationProtocol> fakeDelegate = fake_for([EWSMainViewController class]);
                [tableViewCell setDelegate:fakeDelegate];
                fakeDelegate stub_method("userTappedTicketStatusButton:");
                spy_on(fakeDelegate);
                [tableViewCell registerForNotification:nil];
                fakeDelegate should have_received("userTappedTicketStatusButton:").with(tableViewCell);
            });
        });
    });
    
});

SPEC_END
