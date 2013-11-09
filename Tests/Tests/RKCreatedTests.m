//
//  RKCreatedTests.m
//  Tests
//
//  Created by Sam Symons on 11/5/2013.
//
//

#import "RKTestCase.h"

@interface RKCreatedTests : RKTestCase

@property (nonatomic, strong) RKCreated *createdObject;

@end

@implementation RKCreatedTests

- (void)setUp
{
    NSDictionary *data = @{@"id": @"12345", @"created_utc": @(1141150769)};
	NSDictionary *JSON = @{@"data": data, @"kind": @"t1"};
    
    self.createdObject = [MTLJSONAdapter modelOfClass:[RKCreated class] fromJSONDictionary:JSON error:nil];
}

- (void)testGettingTheCreationDate
{
    XCTAssertNotNil(self.createdObject.created, @"The returned NSDate should not be nil.");
}

@end
