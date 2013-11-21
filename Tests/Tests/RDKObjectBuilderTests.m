//
//  RDKObjectBuilderTests.m
//  Tests
//
//  Created by Sam Symons on 10/07/13.
//
//

#import "RDKTestCase.h"
#import "RDKObjectBuilder.h"

@interface RDKObjectBuilderTests : RDKTestCase

@property (nonatomic, strong) NSDictionary *linkJSON;
@property (nonatomic, strong) NSDictionary *subredditJSON;

@end

@implementation RDKObjectBuilderTests

- (void)setUp
{
    [super setUp];
    
	self.linkJSON = [self JSONFromLocalFileWithName:@"link"];
    self.subredditJSON = [self JSONFromLocalFileWithName:@"subreddit"];
}

- (void)testObjectBuilding
{
    id link = [RDKObjectBuilder objectFromJSON:self.linkJSON];
    XCTAssert([link class] == [RDKLink class], @"The object should be an RDKLink.");
    
    id subreddit = [RDKObjectBuilder objectFromJSON:self.subredditJSON];
    XCTAssert([subreddit class] == [RDKSubreddit class], @"The object should be an RDKSubreddit.");
}

@end
