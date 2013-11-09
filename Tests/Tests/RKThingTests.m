//
//  RKThingTests.m
//  Tests
//
//  Created by Sam Symons on 8/06/13.
//
//

#import "RKTestCase.h"

@interface RKThingTests : RKTestCase

@property (nonatomic, strong) RKThing *thing;

@end

@implementation RKThingTests

- (void)setUp
{
    NSDictionary *JSON = [self JSONDictionaryWithIdentifier:@"12345" kind:@"t1"];
    self.thing = [MTLJSONAdapter modelOfClass:[RKThing class] fromJSONDictionary:JSON error:nil];
}

- (void)testFullName
{
	NSString *fullName = [[self thing] fullName];
	NSString *expectedFullName = [NSString stringWithFormat:@"%@_%@", self.thing.kind, self.thing.identifier];
    
	XCTAssertEqualObjects(fullName, expectedFullName, @"fullName was returned incorrectly.");
}

- (void)testEquality
{
    NSDictionary *matchingThingJSON = [self JSONDictionaryWithIdentifier:@"12345" kind:@"t1"];
    RKThing *matchingThing = [MTLJSONAdapter modelOfClass:[RKThing class] fromJSONDictionary:matchingThingJSON error:nil];
    
    NSDictionary *nonMatchingThingJSON = [self JSONDictionaryWithIdentifier:@"54321" kind:@"t1"];
    RKThing *nonMatchingThing = [MTLJSONAdapter modelOfClass:[RKThing class] fromJSONDictionary:nonMatchingThingJSON error:nil];
    
    XCTAssertTrue([[self thing] isEqual:matchingThing], @"RKThing should be equal to another RKThing with the same full name.");
    XCTAssertFalse([[self thing] isEqual:nonMatchingThing], @"RKThing should not equal to another RKThing with a different full name.");
    XCTAssertFalse([[self thing] isEqual:@"String"], @"RKThing should not be equal to an object which isn't an RKThing.");
}

- (void)testCopying
{
	RKThing *thingCopy = [[self thing] copy];
	
	XCTAssertEqualObjects(self.thing.kind, thingCopy.kind, @"RKThing copy failed.");
	XCTAssertEqualObjects(self.thing.identifier, thingCopy.identifier, @"RKThing copy failed.");
}

- (void)testCoding
{	
	NSData *postData = [NSKeyedArchiver archivedDataWithRootObject:self.thing];
	RKThing *unarchivedData = [NSKeyedUnarchiver unarchiveObjectWithData:postData];
	
	XCTAssertEqualObjects(self.thing.kind, unarchivedData.kind, @"RKThing archiving failed");
	XCTAssertEqualObjects(self.thing.identifier, unarchivedData.identifier, @"RKThing archiving failed");
}

#pragma mark - Private

- (NSDictionary *)JSONDictionaryWithIdentifier:(NSString *)identifier kind:(NSString *)kind
{
    NSDictionary *data = @{@"id": identifier};
	NSDictionary *JSON = @{@"data": data, @"kind": kind};
	
	return JSON;
}

@end
