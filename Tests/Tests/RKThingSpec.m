//
//  RKThingSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-06-22.
//
//

NSDictionary *RKDataForThing(NSString *identifier, NSString *kind)
{
    NSDictionary *data = @{@"id": identifier};
	NSDictionary *JSON = @{@"data": data, @"kind": kind};
	
	return JSON;
}

SpecBegin(RKThing);

NSDictionary *JSON = RKDataForThing(@"12345", @"t1");
RKThing *thing = [MTLJSONAdapter modelOfClass:[RKThing class] fromJSONDictionary:JSON error:nil];

describe(@"fullName", ^{
    it(@"should return the correct full name", ^{
        NSString *fullName = [thing fullName];
        NSString *expectedFullName = [NSString stringWithFormat:@"%@_%@", thing.kind, thing.identifier];
        
        expect(fullName).to.equal(expectedFullName);
    });
});

describe(@"equality", ^{
    it(@"should perform equality checks correctly", ^{
        NSDictionary *matchingThingJSON = RKDataForThing(@"12345", @"t1");
        RKThing *matchingThing = [MTLJSONAdapter modelOfClass:[RKThing class] fromJSONDictionary:matchingThingJSON error:nil];
        
        NSDictionary *nonMatchingThingJSON = RKDataForThing(@"54321", @"t1");
        RKThing *nonMatchingThing = [MTLJSONAdapter modelOfClass:[RKThing class] fromJSONDictionary:nonMatchingThingJSON error:nil];
        
        expect(thing).to.equal(matchingThing);
        expect(thing).toNot.equal(nonMatchingThing);
        expect(thing).toNot.equal(@"some non-RKThing object");
    });
});

describe(@"NSCopying", ^{
    it(@"should return a copy of the object", ^{
        RKThing *thingCopy = [thing copy];
        
        expect(thingCopy.kind).to.equal(thing.kind);
        expect(thingCopy.identifier).to.equal(thing.identifier);
        expect(thingCopy).toNot.beIdenticalTo(thing);
    });
});

describe(@"NSCoding", ^{
    it(@"should be able to archive and unarchive an object", ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:thing];
        RKThing *unarchivedThing = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        expect(unarchivedThing).to.equal(thing);
    });
});

SpecEnd
