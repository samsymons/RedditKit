//
//  RKMoreCommentsSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-09-02.
//
//

#import "RKSpecHelper.h"

SpecBegin(RKMoreComments);

NSDictionary *JSON = [RKSpecHelper JSONFromLocalFileWithName:@"more"];

RKMoreComments *moreCommentsObject = [MTLJSONAdapter modelOfClass:[RKMoreComments class] fromJSONDictionary:JSON error:nil];

describe(@"initialization", ^{
    it(@"should create the object correctly", ^{
        expect(moreCommentsObject.count).to.equal(2);
        expect(moreCommentsObject.parentID).to.equal(@"t1_ck724t6");
        expect(moreCommentsObject.children).to.equal(@[@"ck74tch", @"ck78qib"]);
    });
});

SpecEnd
