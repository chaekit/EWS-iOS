#import "EWSLab.h"


@interface EWSLab ()

// Private interface goes here.

@end


@implementation EWSLab

@synthesize labName;
@synthesize machineCount;
@synthesize inuseCount;
@synthesize labIndex;

- (CGFloat)fractionInUse {
    return ((CGFloat)[inuseCount integerValue]) / [machineCount integerValue];
}

- (void)updateWithJSON:(NSDictionary *)JSON {
    if ([self _isValidJSON:JSON] == NO) {
        @throw NSInvalidArgumentException;
    }
}

- (BOOL)_isValidJSON:(NSDictionary *)JSON {
    NSArray *validKeys = @[@"labname", @"inusecount", @"machinecount"];
    return [validKeys isEqualToArray:[JSON allKeys]];
}

- (NSString *)usageFractionInString {
    return [NSString stringWithFormat:@"%@/%@", inuseCount, machineCount];
}

@end
