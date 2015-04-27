//
//  RKClientOAuthSpec.m
//  Tests
//
//  Created by Sam Symons on 2015-04-26.
//
//

#import "RedditKit.h"

#import "RKClient+OAuth.h"

SpecBegin(RKClient_OAuth);

RKClient *client = [[RKClient alloc] init];

describe(@"scopeStringFromScope:", ^{
    it(@"returns a valid scope string", ^{
        RKOAuthScope scope = RKOAuthScopeAccount|RKOAuthScopeEditWikis;
        NSString *scopeString = [client scopeStringFromScope:scope];
        
        expect(scopeString).to.equal(@"account,wikiedit");
    });
});

SpecEnd
