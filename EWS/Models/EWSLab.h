#import "_EWSLab.h"

@interface EWSLab : _EWSLab {}

- (CGFloat)fractionInUse;
- (void)updateWithJSON:(NSDictionary *)JSON;
- (NSString *)usageFractionInString;

- (BOOL)isValidForNotification;
+ (id)sharedLabData;

@end
