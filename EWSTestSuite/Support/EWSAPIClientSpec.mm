#import "EWSAPIClient.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(EWSAPIClientSpec)

describe(@"EWSAPIClient", ^{
    __block EWSAPIClient *client;

    beforeEach(^{
        client = [EWSAPIClient sharedAPIClient];
    });
    
    context(@"default values", ^{
        it(@"should accept application/json as the default mime type", ^{
            [client defaultValueForHeader:@"Accept"] should equal(@"application/json");
        });
        
        describe(@"baseURL", ^{
            it(@"should have baseURL pointing to the Heroku production api for production mode", ^{
                [client baseURL] should equal([NSURL URLWithString:@"http://ews-api.herokuapp.com"]);
            });
        });
        
    });
    

    context(@"instance methods", ^{
        describe(@"#pollUsageFromAPI:Success:Failure:", ^{
            it(@"should poll labUsage from the server", ^{
                spy_on(client);
                [client pollUsageFromAPISucess:nil Failure:nil];
                client should have_received("getPath:parameters:success:failure:").with(@"/labusage",
                                                                                        nil, nil, nil);
            });
        });
        
        describe(@"#registerNotificationForParams:Success:Failure:", ^{
            it(@"should send a POST request to register endpoint", ^{
                spy_on(client);
                [client registerNotificationParams:nil Success:nil Failure:nil];
                client should have_received("postPath:parameters:success:failure:").with(@"/ticket",
                                                                                        nil,nil,nil);
            });
        });
    });

});

SPEC_END
