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
        NSLog(@"Invalid JSON  %@", JSON);
        @throw NSInvalidArgumentException;
    }
    
    [self setMachineCount:JSON[@"machinecount"]];
    [self setInuseCount:JSON[@"inusecount"]];
}

- (BOOL)_isValidJSON:(NSDictionary *)JSON {
    NSArray *validKeys = @[@"labname", @"inusecount", @"machinecount"];
    
    for (NSString *key in validKeys) {
        if ([[JSON allKeys] containsObject:key] == NO) return NO;
    }
    return YES;
}

- (NSString *)usageFractionInString {
    return [NSString stringWithFormat:@"%@/%@", self.inuseCount, self.machineCount];
}

- (BOOL)isValidForNotification {
    return self.machineCountValue - self.inuseCountValue <= 10;
}


@end
