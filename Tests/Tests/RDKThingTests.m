//
//  RDKThingTests.m
//  Tests
//
//  Created by Sam Symons on 8/06/13.
//
//

#import "RDKTestCase.h"

@interface RDKThingTests : RDKTestCase

@property (nonatomic, strong) RDKThing *thing;

@end

@implementation RDKThingTests

- (void)setUp
{
    NSDictionary *JSON = [self JSONDictionaryWithIdentifier:@"12345" kind:@"t1"];
    self.thing = [MTLJSONAdapter modelOfClass:[RDKThing class] fromJSONDictionary:JSON error:nil];
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
    RDKThing *matchingThing = [MTLJSONAdapter modelOfClass:[RDKThing class] fromJSONDictionary:matchingThingJSON error:nil];
    
    NSDictionary *nonMatchingThingJSON = [self JSONDictionaryWithIdentifier:@"54321" kind:@"t1"];
    RDKThing *nonMatchingThing = [MTLJSONAdapter modelOfClass:[RDKThing class] fromJSONDictionary:nonMatchingThingJSON error:nil];
    
    XCTAssertTrue([[self thing] isEqual:matchingThing], @"RDKThing should be equal to another RDKThing with the same full name.");
    XCTAssertFalse([[self thing] isEqual:nonMatchingThing], @"RDKThing should not equal to another RDKThing with a different full name.");
    XCTAssertFalse([[self thing] isEqual:@"String"], @"RDKThing should not be equal to an object which isn't an RDKThing.");
}

- (void)testCopying
{
	RDKThing *thingCopy = [[self thing] copy];
	
	XCTAssertEqualObjects(self.thing.kind, thingCopy.kind, @"RDKThing copy failed.");
	XCTAssertEqualObjects(self.thing.identifier, thingCopy.identifier, @"RDKThing copy failed.");
}

- (void)testCoding
{	
	NSData *postData = [NSKeyedArchiver archivedDataWithRootObject:self.thing];
	RDKThing *unarchivedData = [NSKeyedUnarchiver unarchiveObjectWithData:postData];
	
	XCTAssertEqualObjects(self.thing.kind, unarchivedData.kind, @"RDKThing archiving failed");
	XCTAssertEqualObjects(self.thing.identifier, unarchivedData.identifier, @"RDKThing archiving failed");
}

#pragma mark - Private

- (NSDictionary *)JSONDictionaryWithIdentifier:(NSString *)identifier kind:(NSString *)kind
{
    NSDictionary *data = @{@"id": identifier};
	NSDictionary *JSON = @{@"data": data, @"kind": kind};
	
	return JSON;
}

@end
