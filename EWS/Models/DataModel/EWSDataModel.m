//
//  EWSDataModel.m
//  EWS
//
//  Created by Jay Chae  on 9/8/13.
//  Copyright (c) 2013 JCLab. All rights reserved.
//

#import "EWSDataModel.h"

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
    }
    return self;
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
