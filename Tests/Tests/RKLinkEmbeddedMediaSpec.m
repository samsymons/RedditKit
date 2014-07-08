//
//  RKLinkEmbeddedMediaSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-07-07.
//
//

#import "RKSpecHelper.h"

SpecBegin(RKLinkEmbeddedMedia);

NSDictionary *embeddedMediaJSON = [RKSpecHelper JSONFromLocalFileWithName:@"embedded-media"];
RKLinkEmbeddedMedia *embeddedMedia = [MTLJSONAdapter modelOfClass:[RKLinkEmbeddedMedia class] fromJSONDictionary:embeddedMediaJSON error:nil];

describe(@"initialization", ^{
    it(@"should create the object correctly", ^{
        expect(embeddedMedia.type).to.equal(@"imgur.com");
        expect(embeddedMedia.width).to.equal(550);
        expect(embeddedMedia.height).to.equal(550);
    });
});

SpecEnd
