//
//  RKVotableTests.m
//  Tests
//
//  Created by Sam Symons on 11/5/2013.
//
//

#import "RKTestCase.h"

@interface RKVotableTests : RKTestCase

@property (nonatomic, strong) RKVotable *upvotedObject;
@property (nonatomic, strong) RKVotable *downvotedObject;
@property (nonatomic, strong) RKVotable *nonVotedObject;

@end

@implementation RKVotableTests

- (void)setUp
{
	NSDictionary *upvotedJSON = [self votableDataWithLikes:@(YES)];
    self.upvotedObject = [MTLJSONAdapter modelOfClass:[RKVotable class] fromJSONDictionary:upvotedJSON error:nil];
    
    NSDictionary *downvotedJSON = [self votableDataWithLikes:@(NO)];
    self.downvotedObject = [MTLJSONAdapter modelOfClass:[RKVotable class] fromJSONDictionary:downvotedJSON error:nil];
    
    NSDictionary *nonVotedJSON = [self votableDataWithLikes:[NSNull null]];
    self.nonVotedObject = [MTLJSONAdapter modelOfClass:[RKVotable class] fromJSONDictionary:nonVotedJSON error:nil];
}

- (void)testUpvotedObjects
{
    XCTAssertTrue(self.upvotedObject.upvoted, @"The object should have been upvoted, but it wasn't.");
    XCTAssertFalse(self.upvotedObject.downvoted, @"The object should not have been downvoted, but it was.");
}

- (void)testDownvotedObject
{
    XCTAssertTrue(self.downvotedObject.downvoted, @"The object should have been downvoted, but it wasn't.");
    XCTAssertFalse(self.downvotedObject.upvoted, @"The object should not have been upvoted, but it was.");
}

- (void)testVotedObjects
{
    XCTAssertFalse(self.nonVotedObject.voted, @"The object should not have been voted on, but it was.");
}

#pragma mark -

- (NSDictionary *)votableDataWithLikes:(id)likes
{
    NSParameterAssert(likes);
    
    NSDictionary *data = @{@"id": @"12345", @"likes": likes};
	NSDictionary *JSON = @{@"data": data, @"kind": @"t1"};
    
    return JSON;
}

@end
