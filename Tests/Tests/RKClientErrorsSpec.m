//
//  RKClientErrorsSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-06-30.
//
//

#import "RKSpecHelper.h"

SpecBegin(RKClient_Errors);

describe(@"successful responses", ^{
    it(@"does not raise an error when given a successful comment response", ^{
        NSString *responseString = [RKSpecHelper contentsOfLocalFileWithName:@"comment-response"];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
        NSError *responseError = [RKClient errorFromResponse:response responseString:responseString];
        
        expect(responseError).to.beNil();
    });
});

/*
describe(@"failed responses", ^{
    
});
 */

SpecEnd