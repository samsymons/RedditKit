//
//  RKVotableSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-06-22.
//
//

NSDictionary *RKVotableData(id likes)
{
    NSDictionary *data = @{@"id": @"12345", @"likes": likes};
	NSDictionary *JSON = @{@"data": data, @"kind": @"t1"};
    
    return JSON;
}

SpecBegin(RKVotable);

NSDictionary *upvotedJSON = RKVotableData(@YES);
RKVotable *upvotedObject = [MTLJSONAdapter modelOfClass:[RKVotable class] fromJSONDictionary:upvotedJSON error:nil];

NSDictionary *downvotedJSON = RKVotableData(@NO);
RKVotable *downvotedObject = [MTLJSONAdapter modelOfClass:[RKVotable class] fromJSONDictionary:downvotedJSON error:nil];

NSDictionary *nonVotedJSON = RKVotableData([NSNull null]);
RKVotable *nonVotedObject = [MTLJSONAdapter modelOfClass:[RKVotable class] fromJSONDictionary:nonVotedJSON error:nil];

describe(@"upvoted objects", ^{
    it(@"should return the correct vote direction", ^{
        expect(upvotedObject.upvoted).to.beTruthy();
        expect(downvotedObject.upvoted).to.beFalsy();
    });
});

describe(@"downvoted objects", ^{
    it(@"should return the correct vote direction", ^{
        expect(upvotedObject.downvoted).to.beFalsy();
        expect(downvotedObject.downvoted).to.beTruthy();
    });
});

describe(@"objects with no vote", ^{
    it(@"should return the correct vote direction", ^{
        expect(nonVotedObject.voted).to.beFalsy();
        expect(nonVotedObject.upvoted).to.beFalsy();
        expect(nonVotedObject.downvoted).to.beFalsy();
    });
});

SpecEnd
