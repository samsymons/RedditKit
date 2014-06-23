//
//  RKMultiredditSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-06-22.
//
//

#import "RKSpecHelper.h"

SpecBegin(RKMultireddit);

NSDictionary *multiredditJSON = [RKSpecHelper JSONFromLocalFileWithName:@"multireddit"];
RKMultireddit *multireddit = [MTLJSONAdapter modelOfClass:[RKMultireddit class] fromJSONDictionary:multiredditJSON error:nil];

describe(@"username", ^{
    it(@"should return username of the multireddit's creator", ^{
        NSString *username = [multireddit username];
        expect(username).to.equal(@"Lapper");
    });
});

SpecEnd
