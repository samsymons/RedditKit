//
//  RKClientCaptchaTests.m
//  Tests
//
//  Created by Sam Symons on 11/5/2013.
//
//

#import "RKTestCase.h"

@interface RKClientCaptchaTests : RKTestCase

@property (nonatomic, strong) RKClient *client;

@end

@implementation RKClientCaptchaTests

- (void)setUp
{
    self.client = [[RKClient alloc] init];
}

- (void)testCaptchaURLs
{
    NSURL *captchaURL = [[self client] URLForCaptchaWithIdentifier:@"12345"];
    XCTAssertEqualObjects([captchaURL absoluteString], @"http://reddit.com/captcha/12345.png", @"The URL for the CAPTCHA was invalid.");
}

@end
