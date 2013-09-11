// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EWSLab.h instead.

#import <CoreData/CoreData.h>


extern const struct EWSLabAttributes {
	__unsafe_unretained NSString *inuseCount;
	__unsafe_unretained NSString *labIndex;
	__unsafe_unretained NSString *labName;
	__unsafe_unretained NSString *machineCount;
} EWSLabAttributes;

extern const struct EWSLabRelationships {
} EWSLabRelationships;

extern const struct EWSLabFetchedProperties {
} EWSLabFetchedProperties;







@interface EWSLabID : NSManagedObjectID {}
@end

@interface _EWSLab : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (EWSLabID*)objectID;





@property (nonatomic, strong) NSNumber* inuseCount;



@property int32_t inuseCountValue;
- (int32_t)inuseCountValue;
- (void)setInuseCountValue:(int32_t)value_;

//- (BOOL)validateInuseCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* labIndex;



@property int32_t labIndexValue;
- (int32_t)labIndexValue;
- (void)setLabIndexValue:(int32_t)value_;

//- (BOOL)validateLabIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* labName;



//- (BOOL)validateLabName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* machineCount;



@property int32_t machineCountValue;
- (int32_t)machineCountValue;
- (void)setMachineCountValue:(int32_t)value_;

//- (BOOL)validateMachineCount:(id*)value_ error:(NSError**)error_;






@end

@interface _EWSLab (CoreDataGeneratedAccessors)

@end

@interface _EWSLab (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveInuseCount;
- (void)setPrimitiveInuseCount:(NSNumber*)value;

- (int32_t)primitiveInuseCountValue;
- (void)setPrimitiveInuseCountValue:(int32_t)value_;




- (NSNumber*)primitiveLabIndex;
- (void)setPrimitiveLabIndex:(NSNumber*)value;

- (int32_t)primitiveLabIndexValue;
- (void)setPrimitiveLabIndexValue:(int32_t)value_;




- (NSString*)primitiveLabName;
- (void)setPrimitiveLabName:(NSString*)value;




- (NSNumber*)primitiveMachineCount;
- (void)setPrimitiveMachineCount:(NSNumber*)value;

- (int32_t)primitiveMachineCountValue;
- (void)setPrimitiveMachineCountValue:(int32_t)value_;




@end
