//
//  RKPaginationSpec.m
//  Tests
//
//  Created by Sam Symons on 2014-06-22.
//
//

#import "RKSpecHelper.h"

SpecBegin(RKPagination);

describe(@"paginationFromListingResponse:", ^{
    it(@"should return an RKPagination object given a valid response", ^{
        NSDictionary *listingJSON = [RKSpecHelper JSONFromLocalFileWithName:@"listing"];
        NSString *after = [listingJSON valueForKeyPath:@"data.after"];
        
        RKPagination *pagination = [RKPagination paginationFromListingResponse:listingJSON];
        
        expect(pagination.before).to.beNil();
        expect(pagination.after).to.equal(after);
    });
});

describe(@"paginationWithLimit:", ^{
    it(@"should return a pagination object with a specific limit", ^{
        RKPagination *pagination = [RKPagination paginationWithLimit:75];
        expect(pagination.limit).to.equal(75);
    });
    
    it(@"should not allow the limit to go above 100", ^{
        RKPagination *pagination = [RKPagination paginationWithLimit:200];
        expect(pagination.limit).to.equal(100);
    });
});

describe(@"dictionaryValue", ^{
    it(@"should return the dictionary value", ^{
        RKPagination *pagination = [RKPagination paginationWithLimit:50];
        pagination.before = @"12345";
        pagination.timeMethod = RKTimeSortingMethodThisHour;
        
        // Test the first dictionary value:
        
        NSDictionary *dictionaryValue = [pagination dictionaryValue];
        NSDictionary *expectedValue = @{@"limit": @"50", @"before": @"12345", @"t": @"hour"};
        
        expect([dictionaryValue isEqualToDictionary:expectedValue]).to.beTruthy();
        
        // Test the second dictionary value:
        
        pagination.after = @"54321";
        pagination.limit = 5;
        
        dictionaryValue = [pagination dictionaryValue];
        expectedValue = @{@"limit": @"5", @"before": @"12345", @"after": @"54321", @"t": @"hour"};
        
        expect([dictionaryValue isEqualToDictionary:expectedValue]).to.beTruthy();
    });
});

SpecEnd