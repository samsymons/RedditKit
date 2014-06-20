//
//  RKLinkTests.m
//  Tests
//
//  Created by Sam Symons on 9/06/13.
//
//

#import "RKTestCase.h"
#import <RedditKit/Model/RKLink.h>

@interface RKLinkTests : RKTestCase

@property (nonatomic, strong) RKLink *nonImageLink;
@property (nonatomic, strong) RKLink *imageLink;

@end

@implementation RKLinkTests

- (void)setUp
{
    NSMutableDictionary *imageLinkJSON = [[self JSONFromLocalFileWithName:@"link"] mutableCopy];
    NSMutableDictionary *data = [[imageLinkJSON objectForKey:@"data"] mutableCopy];
    
    data[@"url"] = @"http://example.com/test.png";
    imageLinkJSON[@"data"] = [data copy];
    
    self.imageLink = [MTLJSONAdapter modelOfClass:[RKLink class] fromJSONDictionary:imageLinkJSON error:nil];
    
    NSDictionary *nonImageLinkJSON = [self JSONFromLocalFileWithName:@"link"];
    self.nonImageLink = [MTLJSONAdapter modelOfClass:[RKLink class] fromJSONDictionary:nonImageLinkJSON error:nil];
}

- (void)testInitialization
{
    XCTAssertEqualObjects([[self imageLink] domain], @"example.com", @"The link should have a domain.");
    XCTAssertEqualWithAccuracy([[self imageLink] upvoteRatio], 0.9, 0.01, @"The link should have an upvote ratio, if provided.");
}

- (void)testIsImageLink
{
    XCTAssertTrue([[self imageLink] isImageLink], @"The image link should return true.");
    XCTAssertFalse([[self nonImageLink] isImageLink], @"The non image link should not return true.");
}

- (void)testShortURL
{
    XCTAssertEqualObjects([[self imageLink] shortURL], [NSURL URLWithString:@"http://redd.it/123456"], @"The link should return a short URL.");
}

@end
