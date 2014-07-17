//
//  RKLinkSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-06-22.
//
//

#import "RKSpecHelper.h"

SpecBegin(RKLink);

NSDictionary *linkJSON = [RKSpecHelper JSONFromLocalFileWithName:@"link"];
NSMutableDictionary *imageLinkJSON = [linkJSON mutableCopy];
NSMutableDictionary *data = [[imageLinkJSON objectForKey:@"data"] mutableCopy];

data[@"url"] = @"http://example.com/test.png";
imageLinkJSON[@"data"] = [data copy];

RKLink *imageLink = [MTLJSONAdapter modelOfClass:[RKLink class] fromJSONDictionary:imageLinkJSON error:nil];
RKLink *nonImageLink = [MTLJSONAdapter modelOfClass:[RKLink class] fromJSONDictionary:linkJSON error:nil];

describe(@"initialization", ^{
    it(@"should create the object correctly", ^{
        expect(imageLink.domain).to.equal(@"imgur.com");
        expect(imageLink.upvoteRatio).to.equal(0.95);
    });
    
    fit(@"instantiates its embedded media", ^{
        expect(imageLink.media).toNot.beNil();
        expect(imageLink.media.type).to.equal(@"imgur.com");
    });
});

describe(@"isImageLink", ^{
    it(@"should return whether the link is to an image", ^{
        expect(imageLink.isImageLink).to.beTruthy();
        expect(nonImageLink.isImageLink).to.beFalsy();
    });
});

describe(@"shortURL", ^{
    it(@"should return a short URL", ^{
        expect([imageLink shortURL]).to.equal([NSURL URLWithString:@"http://redd.it/2a0wzj"]);
    });
});

SpecEnd
