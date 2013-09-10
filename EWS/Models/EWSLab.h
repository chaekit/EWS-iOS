#import "_EWSLab.h"

@interface EWSLab : _EWSLab {}

@property (nonatomic, strong) NSNumber *labIndex;

- (CGFloat)fractionInUse;
- (void)updateWithJSON:(NSDictionary *)JSON;
- (NSString *)usageFractionInString;

@end
