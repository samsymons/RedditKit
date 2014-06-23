//
//  RKClientCaptchaSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-06-22.
//
//

SpecBegin(RKClient_Captcha);

RKClient *client = [[RKClient alloc] init];

describe(@"URLForCaptchaWithIdentifier:", ^{
    it(@"should return a CAPTCHA with a given identifier", ^{
        NSURL *captchaURL = [client URLForCaptchaWithIdentifier:@"12345"];
        expect(captchaURL).to.equal([NSURL URLWithString:@"http://reddit.com/captcha/12345.png"]);
    });
});

SpecEnd
