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
        
        it(@"should not highlight on selection", ^{
            tableViewCell.selectionStyle should equal(UITableViewCellSelectionStyleNone);
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
            
            it(@"should change the labTicketStatusButton's title if the lab is registered", ^{
                [tableViewCell updateWithLab:[EWSLab labFactoryRegisteredForNotification]];
                tableViewCell.labTicketStatusButton.titleLabel.text should equal(@"RR");
            });
        });
        
        describe(@"#registerForNotification", ^{
            __block id<CedarDouble, EWSMainLabTableViewCellLabNotificationProtocol> fakeDelegate;

            beforeEach(^{
                fakeDelegate = fake_for([EWSMainViewController class]);
                [tableViewCell setDelegate:fakeDelegate];
                fakeDelegate stub_method("userTappedTicketStatusButton:");
                spy_on(fakeDelegate);
            });
            
            it(@"should send userTappedTicketStatusButtonCell: to the cell's delegate", ^{
                [tableViewCell setLabObject:[EWSLab labFactoryValidForNotification]];
                [tableViewCell registerForNotification:nil];
                fakeDelegate should have_received("userTappedTicketStatusButton:").with(tableViewCell);
            });
            
//            it(@"should not send userTappedTicketStatusButtonCell if the lab is already registered", ^{
//                [tableViewCell setLabObject:[EWSLab labFactoryNotValidForNotification]];
//                [tableViewCell registerForNotification:nil];
//                fakeDelegate should have_received("userTappedTicketStatusButton:").with(tableViewCell);
//            });
            
        });
        
        describe(@"#markAsRegistered", ^{
            it(@"should change the registration status of the associated labObject", ^{
                [tableViewCell setLabObject:[EWSLab labFactoryValidForNotification]];
                [tableViewCell markAsRegistered];
                tableViewCell.labObject.registeredForNotification should equal([NSNumber numberWithBool:YES]);
            });
            
            it(@"should change the title of the labTicketStatusButton", ^{
                [tableViewCell markAsRegistered];
                tableViewCell.labTicketStatusButton.titleLabel.text should equal(@"RR");
            });
        });
        
        describe(@"#markAsUnregistered", ^{
            it(@"should change the registration status of the associated labObject", ^{
                [tableViewCell setLabObject:[EWSLab labFactoryRegisteredForNotification]];
                [tableViewCell markAsUnregistered];
                tableViewCell.labObject.registeredForNotification should equal([NSNumber numberWithBool:NO]);
            });
            
            it(@"should change the title of the labTicketStatusButton", ^{
                [tableViewCell markAsUnregistered];
                tableViewCell.labTicketStatusButton.titleLabel.text should equal(@"UR");
            });
        });
    });
    
});

SPEC_END
