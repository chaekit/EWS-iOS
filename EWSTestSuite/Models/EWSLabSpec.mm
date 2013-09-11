#import <CoreData/CoreData.h>
#import "EWSLab.h"
#import "EWSDataModel.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(EWSLabSpec)

describe(@"EWSLab", ^{

    __block EWSLab *lab;
    
    beforeEach(^{
        NSManagedObjectContext *context = [[EWSDataModel sharedDataModel] mainContext];
        lab = [EWSLab insertInManagedObjectContext:context];
        lab.labName = @"DCL 416";
        lab.machineCount = @46;
        lab.inuseCount = @12;
    });
    
    context(@"valid properties", ^{
        it(@"has acceptable properties", ^{
            [lab respondsToSelector:@selector(labName)] should be_truthy;
            [lab respondsToSelector:@selector(machineCount)] should be_truthy;
            [lab respondsToSelector:@selector(inuseCount)] should be_truthy;
            [lab respondsToSelector:@selector(labIndex)] should be_truthy;
        });
        
        describe(@"labName", ^{
            it(@"should be an instance of NSString", ^{
                lab.labName should be_instance_of([NSString class]).or_any_subclass();
            });
        });
        
        describe(@"machineCount", ^{
            it(@"should be an instance of NSUInteger", ^{
                lab.machineCount should be_instance_of([NSNumber class]).or_any_subclass();
            });
        });
        
    });
    
    context(@"instance methods", ^{
        describe(@"#percantageInUse", ^{
           
            it(@"should have valid instance methods", ^{
                [lab respondsToSelector:@selector(fractionInUse)] should be_truthy;
            });
            
            it(@"should be the same value as inuseCount/machineCount in percentage", ^{
                NSUInteger useCount = [lab.inuseCount integerValue];
                NSUInteger machineCount = [lab.machineCount integerValue];
                CGFloat percentage = (CGFloat)useCount / machineCount;
                [lab fractionInUse] should equal(percentage);
            });
        });
        
        describe(@"#updateWithJSON:", ^{
            it(@"should throw an exception if the parameter has wrong keys", ^{
                NSDictionary *badJSONFormat = @{@"strlabname": @"abc",
                                                @"inusecount": @10,
                                                @"machinecount": @12};
                
                ^{[lab updateWithJSON:badJSONFormat];} should raise_exception([NSInvalidArgumentException class]);
            });
        });
        
        describe(@"#usageFractionInString", ^{
            it(@"should return an NSString in format inusecount/machinecount", ^{
                NSString *usageFraction = [NSString stringWithFormat:@"%@/%@", lab.inuseCount, lab.machineCount];
                [lab usageFractionInString] should equal(usageFraction);
            });
        });
    });
});

SPEC_END