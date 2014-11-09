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
        expect(imageLink.URL).to.equal(@"http://imgur.com/a/RDBz8");
        expect(imageLink.upvoteRatio).to.equal(0.95);
    });
    
    it(@"instantiates its embedded media", ^{
        expect(imageLink.media).toNot.beNil();
        expect(imageLink.media.type).to.equal(@"imgur.com");
    });
    
    fit(@"accepts Unicode characters", ^{
        NSError *unicodeError = nil;
        NSDictionary *unicodeJSON = [RKSpecHelper JSONFromLocalFileWithName:@"unicode-link"];
        RKLink *unicodeLink = [MTLJSONAdapter modelOfClass:[RKLink class] fromJSONDictionary:unicodeJSON error:&unicodeError];
        
        expect([unicodeLink.URL absoluteString]).to.equal(@"http://www.reddit.com/r/mac/comments/2lbvvr/%EF%BD%88%EF%BD%85%EF%BD%8C%EF%BD%90_%EF%BD%97%EF%BD%85%EF%BD%89%EF%BD%92%EF%BD%84_%EF%BD%86%EF%BD%8F%EF%BD%8E%EF%BD%94_%EF%BD%90%EF%BD%92%EF%BD%8F%EF%BD%82%EF%BD%8C%EF%BD%85%EF%BD%8D_%EF%BD%8F%EF%BD%8E_%EF%BD%99%EF%BD%8F%EF%BD%93%EF%BD%85%EF%BD%8D%EF%BD%89%EF%BD%94%EF%BD%85/");
        expect(unicodeError).to.beNil();
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
