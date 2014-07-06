//
//  RKResponseSerializerSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-07-05.
//
//

#import "RKSpecHelper.h"
#import "RKResponseSerializer.h"
#import "RKClient+Errors.h"

id RKJSONResponse(RKResponseSerializer *serializer, NSString *fileName, NSInteger statusCode, NSError **error)
{
    NSData *responseData = [RKSpecHelper dataWithContentsOfLocalFileWithName:fileName];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:statusCode HTTPVersion:nil headerFields:nil];
    
    return [serializer responseObjectForResponse:response data:responseData error:error];
};

SpecBegin(RKResponseSerializer);

RKResponseSerializer *serializer = [[RKResponseSerializer alloc] init];

it(@"does not return an error when given a successful response", ^{
    NSArray *responses = @[@"comment-response", @"subreddit-listing"];
    
    for (NSString *response in responses)
    {
        NSError *responseError = nil;
        id object = RKJSONResponse(serializer, response, 200, &responseError);
        
        expect(object).toNot.beNil();
        expect(responseError).to.beNil();
    }
});

describe(@"failed responses", ^{
    it(@"returns an error when a 404 occurs", ^{
        NSError *responseError = nil;
        id object = RKJSONResponse(serializer, @"not-found", 404, &responseError);
        
        expect(object).to.beNil();
        expect(responseError.code).to.equal(RKClientErrorNotFound);
    });
    
    it(@"returns an error when commenting on something that is too old", ^{
        NSError *responseError = nil;
        id object = RKJSONResponse(serializer, @"too-old", 200, &responseError);
        
        expect(object).to.beNil();
        expect(responseError.code).to.equal(RKClientErrorArchived);
    });
    
    it(@"returns an error when rate limited", ^{
        NSError *responseError = nil;
        id object = RKJSONResponse(serializer, @"rate-limit", 200, &responseError);
        
        expect(object).to.beNil();
        expect(responseError.code).to.equal(RKClientErrorRateLimited);
    });
});

SpecEnd