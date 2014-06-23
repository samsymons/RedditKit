//
//  RKObjectBuilderSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-06-22.
//
//

#import "RKSpecHelper.h"
#import "RKObjectBuilder.h"

SpecBegin(RKObjectBuilder);

NSDictionary *linkJSON = [RKSpecHelper JSONFromLocalFileWithName:@"link"];
NSDictionary *subredditJSON = [RKSpecHelper JSONFromLocalFileWithName:@"subreddit"];

describe(@"objectFromJSON:", ^{
    it(@"should return a link when supplied with link JSON", ^{
        id link = [RKObjectBuilder objectFromJSON:linkJSON];
        expect([link class]).to.equal([RKLink class]);
    });
    
    it(@"should return a subreddit when supplied with subreddit JSON", ^{
        id subreddit = [RKObjectBuilder objectFromJSON:subredditJSON];
        expect([subreddit class]).to.equal([RKSubreddit class]);
    });
});

SpecEnd
