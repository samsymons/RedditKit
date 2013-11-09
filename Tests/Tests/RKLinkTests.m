//
//  RKLinkTests.m
//  Tests
//
//  Created by Sam Symons on 9/06/13.
//
//

#import "RKTestCase.h"

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

- (void)testIsImageLink
{
    XCTAssertTrue([[self imageLink] isImageLink], @"The image link should return true.");
    XCTAssertFalse([[self nonImageLink] isImageLink], @"The non image link should not return true.");
}

@end
