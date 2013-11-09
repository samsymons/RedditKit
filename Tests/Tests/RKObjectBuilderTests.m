//
//  RKObjectBuilderTests.m
//  Tests
//
//  Created by Sam Symons on 10/07/13.
//
//

#import "RKTestCase.h"
#import "RKObjectBuilder.h"

@interface RKObjectBuilderTests : RKTestCase

@property (nonatomic, strong) NSDictionary *linkJSON;
@property (nonatomic, strong) NSDictionary *subredditJSON;

@end

@implementation RKObjectBuilderTests

- (void)setUp
{
    [super setUp];
    
	self.linkJSON = [self JSONFromLocalFileWithName:@"link"];
    self.subredditJSON = [self JSONFromLocalFileWithName:@"subreddit"];
}

- (void)testObjectBuilding
{
    id link = [RKObjectBuilder objectFromJSON:self.linkJSON];
    XCTAssert([link class] == [RKLink class], @"The object should be an RKLink.");
    
    id subreddit = [RKObjectBuilder objectFromJSON:self.subredditJSON];
    XCTAssert([subreddit class] == [RKSubreddit class], @"The object should be an RKSubreddit.");
}

@end
