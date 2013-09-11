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
});

SPEC_END
