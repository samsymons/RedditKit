//
//  RKClientSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-06-22.
//
//

SpecBegin(RKClient);

RKClient *client = [[RKClient alloc] init];
client.modhash = @"12345";
client.sessionIdentifier = @"12345";

describe(@"isSignedIn", ^{
    it(@"should return whether the user is signed in", ^{
        expect(client.isSignedIn).to.beTruthy();
    });
});

describe(@"signOut", ^{
    it(@"should sign the user out", ^{
        [client signOut];
        expect(client.isSignedIn).to.beFalsy();
    });
});

SpecEnd
