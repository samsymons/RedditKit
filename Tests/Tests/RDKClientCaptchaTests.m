//
//  RDKClientCaptchaTests.m
//  Tests
//
//  Created by Sam Symons on 11/5/2013.
//
//

#import "RDKTestCase.h"

@interface RDKClientCaptchaTests : RDKTestCase

@property (nonatomic, strong) RDKClient *client;

@end

@implementation RDKClientCaptchaTests

- (void)setUp
{
    self.client = [[RDKClient alloc] init];
}

- (void)testCaptchaURLs
{
    NSURL *captchaURL = [[self client] URLForCaptchaWithIdentifier:@"12345"];
    XCTAssertEqualObjects([captchaURL absoluteString], @"http://reddit.com/captcha/12345.png", @"The URL for the CAPTCHA was invalid.");
}

@end
