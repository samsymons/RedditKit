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
    it(@"does not raise an error when given a successful comment response", ^{
        NSData *responseData = [RKSpecHelper dataWithContentsOfLocalFileWithName:@"comment-response"];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
        NSError *responseError = nil;
        
        [serializer responseObjectForResponse:response data:responseData error:&responseError];
        
        expect(responseError).to.beNil();
    });
});

describe(@"failed responses", ^{
    
});

SpecEnd