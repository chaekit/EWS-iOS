#import "EWSLab.h"


@interface EWSLab ()

// Private interface goes here.

@end


@implementation EWSLab


- (CGFloat)fractionInUse {
    return ((CGFloat)[self.inuseCount integerValue]) / [self.machineCount integerValue];
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
    return [NSString stringWithFormat:@"%@/%@", self.inuseCount, self.machineCount];
}

@end
