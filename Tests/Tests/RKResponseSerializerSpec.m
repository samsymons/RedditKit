//
//  RKResponseSerializerSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-07-05.
//
//

#import "RKSpecHelper.h"
#import "RKResponseSerializer.h"

SpecBegin(RKResponseSerializer);

RKResponseSerializer *serializer = [[RKResponseSerializer alloc] init];

describe(@"successful responses", ^{
    it(@"does not return an error when given a successful comment response", ^{
        NSData *responseData = [RKSpecHelper dataWithContentsOfLocalFileWithName:@"comment-response"];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
        NSError *responseError = nil;
        
        id object = [serializer responseObjectForResponse:response data:responseData error:&responseError];
        
        expect(object).toNot.beNil();
        expect(responseError).to.beNil();
    });
});

describe(@"failed responses", ^{
    fit(@"returns an error when a 404 occurs", ^{
        NSData *responseData = [RKSpecHelper dataWithContentsOfLocalFileWithName:@"not-found"];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:404 HTTPVersion:nil headerFields:nil];
        NSError *responseError = nil;
        
        id object = [serializer responseObjectForResponse:response data:responseData error:&responseError];
        
        expect(object).to.beNil();
        expect(responseError).toNot.beNil();
    });
});

SpecEnd