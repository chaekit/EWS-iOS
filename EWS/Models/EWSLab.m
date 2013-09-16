#import "EWSLab.h"
#import "EWSDataModel.h"


static NSMutableArray *sharedLabData;


@interface EWSLab ()

// Private interface goes here.

@end


@implementation EWSLab

@synthesize registeredForNotification;

+ (id)sharedLabData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLabData = [[NSMutableArray alloc] init];
    });
    
    if (sharedLabData && [sharedLabData count] == 0) {
        [self fetchFromCoreData];
    }
    return sharedLabData;
}


+ (void)fetchFromCoreData {
    static NSFetchedResultsController *fetchedRequestController = nil;
    NSManagedObjectContext *context = [[EWSDataModel sharedDataModel] mainContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"EWSLab"
                                   inManagedObjectContext:context]];
    NSArray *sortArray = @[[[NSSortDescriptor alloc] initWithKey:@"labIndex" ascending:YES]];
    
    [request setSortDescriptors:sortArray];
    [request setReturnsObjectsAsFaults:NO];
    
    fetchedRequestController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                   managedObjectContext:context
                                                                     sectionNameKeyPath:nil cacheName:@"Master"];
    
    NSError *error;
    if (error) {
        NSLog(@"Could not do shit");
    }

    sharedLabData = [[[fetchedRequestController sections][0] allObjects] mutableCopy];
}


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
