// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EWSLab.m instead.

#import "_EWSLab.h"

const struct EWSLabAttributes EWSLabAttributes = {
	.inuseCount = @"inuseCount",
	.labIndex = @"labIndex",
	.labName = @"labName",
	.machineCount = @"machineCount",
	.registeredForNotification = @"registeredForNotification",
};

const struct EWSLabRelationships EWSLabRelationships = {
};

const struct EWSLabFetchedProperties EWSLabFetchedProperties = {
};

@implementation EWSLabID
@end

@implementation _EWSLab

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"EWSLab" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"EWSLab";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"EWSLab" inManagedObjectContext:moc_];
}

- (EWSLabID*)objectID {
	return (EWSLabID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"inuseCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"inuseCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"labIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"labIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"machineCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"machineCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"registeredForNotificationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"registeredForNotification"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic inuseCount;



- (int32_t)inuseCountValue {
	NSNumber *result = [self inuseCount];
	return [result intValue];
}

- (void)setInuseCountValue:(int32_t)value_ {
	[self setInuseCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveInuseCountValue {
	NSNumber *result = [self primitiveInuseCount];
	return [result intValue];
}

- (void)setPrimitiveInuseCountValue:(int32_t)value_ {
	[self setPrimitiveInuseCount:[NSNumber numberWithInt:value_]];
}





@dynamic labIndex;



- (int32_t)labIndexValue {
	NSNumber *result = [self labIndex];
	return [result intValue];
}

- (void)setLabIndexValue:(int32_t)value_ {
	[self setLabIndex:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLabIndexValue {
	NSNumber *result = [self primitiveLabIndex];
	return [result intValue];
}

- (void)setPrimitiveLabIndexValue:(int32_t)value_ {
	[self setPrimitiveLabIndex:[NSNumber numberWithInt:value_]];
}





@dynamic labName;






@dynamic machineCount;



- (int32_t)machineCountValue {
	NSNumber *result = [self machineCount];
	return [result intValue];
}

- (void)setMachineCountValue:(int32_t)value_ {
	[self setMachineCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMachineCountValue {
	NSNumber *result = [self primitiveMachineCount];
	return [result intValue];
}

- (void)setPrimitiveMachineCountValue:(int32_t)value_ {
	[self setPrimitiveMachineCount:[NSNumber numberWithInt:value_]];
}





@dynamic registeredForNotification;



- (BOOL)registeredForNotificationValue {
	NSNumber *result = [self registeredForNotification];
	return [result boolValue];
}

- (void)setRegisteredForNotificationValue:(BOOL)value_ {
	[self setRegisteredForNotification:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveRegisteredForNotificationValue {
	NSNumber *result = [self primitiveRegisteredForNotification];
	return [result boolValue];
}

- (void)setPrimitiveRegisteredForNotificationValue:(BOOL)value_ {
	[self setPrimitiveRegisteredForNotification:[NSNumber numberWithBool:value_]];
}










@end
