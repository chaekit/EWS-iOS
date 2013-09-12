#import "EWSNotificationViewController.h"
#import "EWSAPIClient.h"
#import "EWSMainLabTableViewCell.h"
#import "SpecFactories.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(EWSNotificationViewControllerSpec)

describe(@"EWSNotificationViewController", ^{
    __block EWSNotificationViewController *notificationVC;

    beforeEach(^{
        notificationVC = [[EWSNotificationViewController alloc] init];
        [notificationVC viewDidLoad];
    });
    
    context(@"properties", ^{

        it(@"should make transition in crossDissolveStyle", ^{
            notificationVC.modalTransitionStyle should equal(UIModalTransitionStyleCrossDissolve);
        });
        
        
        context(@"UI componenets", ^{
            it(@"should have a picker", ^{
                [notificationVC respondsToSelector:@selector(timePickerView)] should be_truthy;
            });
            
            it(@"should have a segment control", ^{
                [notificationVC respondsToSelector:@selector(openStationSegmentControl)] should be_truthy;
            });
            
            it(@"should have a confirmation button", ^{
                [notificationVC respondsToSelector:@selector(confirmationButton)] should be_truthy;
            });
            
            describe(@"timePickerView", ^{
                it(@"'s delegate should be notificationVC", ^{
                    notificationVC.timePickerView.delegate should equal(notificationVC);
                });
                
                it(@"'s datasource should be notificationVC", ^{
                    notificationVC.timePickerView.dataSource should equal(notificationVC);
                });
            });
            
            describe(@"closeButton", ^{
                it(@"should have proper target/action", ^{
                    notificationVC.cancelButton.target should equal(notificationVC);
                    notificationVC.cancelButton.action should equal(@selector(dismissNotificationViewController));
                });
            });
            
            describe(@"confirmationButton", ^{
                
                beforeEach(^{
                    spy_on(notificationVC);
                    NSDictionary *fakeParam = @{@"ticket" :
                                                    @{@"expires_at": [NSDate date],
                                                      @"labname": @"DCL 416",
                                                      @"requested_size": @5,
                                                      @"device_udid": @"lolcat"}
                                                };
                    notificationVC stub_method("paramsForLabNotification").and_return(fakeParam);
                });
                it(@"should send userConfirmedNotification: to the notificationVC", ^{
                    [notificationVC.confirmationButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    notificationVC should have_received("userConfirmedNotification:");
                });
                
                it(@"should dismiss notificationVC", ^{
                    notificationVC stub_method("dismissViewControllerAnimated:completion:").with(YES, nil);
                    [notificationVC.confirmationButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    notificationVC should have_received("dismissViewControllerAnimated:completion:").with(YES, nil);
                });
                
                it(@"should send a request to /ticket endpoint", ^{
                    spy_on([EWSAPIClient sharedAPIClient]);
                    [EWSAPIClient sharedAPIClient] stub_method("registerNotificationParams:Success:Failure:");
                    [notificationVC.confirmationButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    [EWSAPIClient sharedAPIClient] should have_received("registerNotificationParams:Success:Failure:");
                });
            });
        });
    });
    
    context(@"instance methods", ^{
        describe(@"#paramsForLabNotification", ^{
            __block NSDictionary *paramForEndpoint;
            
            beforeEach(^{
                EWSMainLabTableViewCell *cell = [[EWSMainLabTableViewCell alloc] init];
                [cell setLabObject:[EWSLab labFactoryWithStandardAttributes]];
                [notificationVC setCellObject:cell];
                paramForEndpoint = [notificationVC paramsForLabNotification];
            });
            it(@"should return an NSDictionary", ^{
                paramForEndpoint should be_instance_of([NSDictionary class]).or_any_subclass();
            });
            
            it(@"should have ticket as the root key", ^{
                [paramForEndpoint valueForKey:@"ticket"] != nil should be_truthy;
            });
            
            it(@"should have valid subroot keys", ^{
                NSDictionary *contentDict = [paramForEndpoint valueForKey:@"ticket"];
                [contentDict valueForKey:@"expires_at"] != nil should be_truthy;
                [contentDict valueForKey:@"device_udid"] != nil should be_truthy;
                [contentDict valueForKey:@"requested_size"] != nil should be_truthy;
                [contentDict valueForKey:@"labname"] != nil should be_truthy;
            });
        });
    });
    
    context(@"protocols", ^{
        it(@"should conform to UIPickerViewDelegate", ^{
            [notificationVC conformsToProtocol:@protocol(UIPickerViewDelegate)] should be_truthy;
        });
        
        it(@"should conform to UIPickerViewDataSource", ^{
            [notificationVC conformsToProtocol:@protocol(UIPickerViewDataSource)] should be_truthy;
        });
        
    });
    
    context(@"UIPickerViewDelegate methods", ^{
        describe(@"#pickerViewNumberOfRowsInComponent", ^{
            it(@"should return 5", ^{
                [notificationVC pickerView:nil numberOfRowsInComponent:0] should equal(5);
            });
        });
        
        describe(@"#numberOfComponentsInPickerView", ^{
            it(@"should return 1", ^{
                [notificationVC numberOfComponentsInPickerView:nil] should equal(1);
            });
        });
        
        describe(@"#pickerViewTitleForRowForComponent", ^{
            it(@"should return the corresponding titles from tilesForTimePickerView", ^{
                NSString *title = [notificationVC pickerView:nil titleForRow:0 forComponent:0];
                title should equal([notificationVC.titlesForTimePickerView objectAtIndex:0]);
            });
        });
    });

});

SPEC_END
