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

describe(@"successful responses", ^{
    it(@"does not return an error when given a successful subreddit listing response", ^{
        NSError *responseError = nil;
        id object = RKJSONResponse(serializer, @"subreddit-listing", 200, &responseError);
        
        expect(object).toNot.beNil();
        expect(responseError).to.beNil();
    });
    
    it(@"does not return an error when given a successful comment response", ^{
        NSError *responseError = nil;
        id object = RKJSONResponse(serializer, @"comment-response", 200, &responseError);
        
        expect(object).toNot.beNil();
        expect(responseError).to.beNil();
    });
});

describe(@"failed responses", ^{
    it(@"returns an error when a 404 occurs", ^{
        NSError *responseError = nil;
        id object = RKJSONResponse(serializer, @"not-found", 404, &responseError);
        
        expect(object).to.beNil();
        expect(responseError.code).to.equal(RKClientErrorNotFound);
    });
});

SpecEnd