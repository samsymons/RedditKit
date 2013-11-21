//
//  RDKCreatedTests.m
//  Tests
//
//  Created by Sam Symons on 11/5/2013.
//
//

#import "RDKTestCase.h"

@interface RDKCreatedTests : RDKTestCase

@property (nonatomic, strong) RDKCreated *createdObject;

@end

@implementation RDKCreatedTests

- (void)setUp
{
    NSDictionary *data = @{@"id": @"12345", @"created_utc": @(1141150769)};
	NSDictionary *JSON = @{@"data": data, @"kind": @"t1"};
    
    self.createdObject = [MTLJSONAdapter modelOfClass:[RDKCreated class] fromJSONDictionary:JSON error:nil];
}

- (void)testGettingTheCreationDate
{
    XCTAssertNotNil(self.createdObject.created, @"The returned NSDate should not be nil.");
}

@end
