//
//  EWSDataModel.m
//  EWS
//
//  Created by Jay Chae  on 9/8/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import "EWSDataModel.h"
#import "EWSLab.h"

@implementation EWSDataModel

@synthesize mainContext;
@synthesize persistentStoreCoordinator;
@synthesize managedObjectModel;


+ (id)sharedDataModel {
    static EWSDataModel *shareDataModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDataModel = [[EWSDataModel alloc] init];
    });
    return shareDataModel;
}


- (id)init {
    self = [super init];
    if (self) {
        [self initManagedObjectModel];
        [self initPersistentCoordinator];
        [self initMainContext];
        [self _checkIfDatabaseIsEmpty];
    }
    return self;
}


/* @private */

- (void)_checkIfDatabaseIsEmpty {
    NSManagedObjectContext *context = mainContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"EWSLab" inManagedObjectContext:context]];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"An error has occured while fetching request");
        return;
    }
    
    if ([results count] == 0) {
        NSLog(@"Database is Empty");
        [self _fillDatabaseWithDefaultLabData];
    } else {
        NSLog(@"Fetch result  %@", results);
    }
}

/* @private */

- (void)_fillDatabaseWithDefaultLabData {
    NSArray *labData = @[@{@"DCL L416": @0},
                         @{@"DCL L440": @1},
                         @{@"DCL L520": @2},
                         @{@"EH 406B1": @3},
                         @{@"EH 406B8": @4},
                          @{@"EVRT 252": @5},
                          @{@"GELIB 057": @6},
                          @{@"GELIB 4th": @7},
                          @{@"MEL 1001": @8},
                          @{@"MEL 1009": @9},
                          @{@"SIEBL 0218": @10},
                          @{@"SIEBL 0220": @11},
                          @{@"SIEBL 0222": @12}];
   
    for (NSDictionary *labDict in labData) {
        EWSLab *lab = [EWSLab insertInManagedObjectContext:mainContext];
        NSString *labName = [labDict allKeys][0];
        NSNumber *labIndex = labDict[labName];
        [lab setLabName:labName];
        [lab setLabIndex:labIndex];
        NSError *error;
        [mainContext save:&error];
    }
}

- (void)initPersistentCoordinator {
//    NSLog(@"Print storage path   %@", [self pathToPersistentStorage]);
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]
                                         initWithManagedObjectModel:managedObjectModel];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES};

    NSURL *storeURL = [NSURL fileURLWithPath:[self pathToPersistentStorage]];
    
    NSError *error;
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:storeURL
                                 options:options error:&error])  {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
        NSException *exc = [NSException exceptionWithName:NSInternalInconsistencyException
                                                   reason:@"Could not create persistent storage"
                                                 userInfo:userInfo];
        @throw exc;
    }
    persistentStoreCoordinator = psc;
}

- (void)initManagedObjectModel {
    NSURL *modelURL = [NSURL fileURLWithPath:[self pathToModel]];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}


- (void)initMainContext {
    mainContext = [[NSManagedObjectContext alloc] init];
    [mainContext setPersistentStoreCoordinator:persistentStoreCoordinator];
}

- (NSString *)pathToModel {
    return [[NSBundle mainBundle] pathForResource:@"EWS" ofType:@"momd"];
}


- (NSString *)pathToPersistentStorage {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"EWS.sqlite"];
}


- (NSString *)documentsDirectory {
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
