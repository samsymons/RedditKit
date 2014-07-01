//
//  RKCreatedSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-06-22.
//
//

SpecBegin(RKCreated);

NSDictionary *data = @{@"id": @"12345", @"created_utc": @(1141150769)};
NSDictionary *JSON = @{@"data": data, @"kind": @"t1"};

RKCreated *createdObject = [MTLJSONAdapter modelOfClass:[RKCreated class] fromJSONDictionary:JSON error:nil];

describe(@"created", ^{
    it(@"should return the date of creation", ^{
        expect(createdObject.created).toNot.beNil();
    });
});

SpecEnd
