//
//  RDKPaginationTests.m
//  Tests
//
//  Created by Sam Symons on 11/5/2013.
//
//

#import "RDKTestCase.h"

@interface RDKPaginationTests : RDKTestCase

@end

@implementation RDKPaginationTests

- (void)testGettingAPaginationObjectFromAListingResponse
{
    NSDictionary *listingJSON = [self JSONFromLocalFileWithName:@"listing"];
    NSString *after = [listingJSON valueForKeyPath:@"data.after"];
    
    RDKPagination *pagination = [RDKPagination paginationFromListingResponse:listingJSON];
    
    XCTAssertNil(pagination.before, @"The pagination object's before value should be nil.");
    XCTAssertEqualObjects(after, pagination.after, @"The pagination object should have the correct after value.");
}

- (void)testCreatingAPaginationObjectWithALimit
{
    RDKPagination *pagination = [RDKPagination paginationWithLimit:75];
    XCTAssertTrue(pagination.limit == 75, @"The pagination object should have a limit of 75.");
}

- (void)testSettingTheLimitToOverOneHundred
{
    RDKPagination *pagination = [RDKPagination paginationWithLimit:200];
    XCTAssertTrue(pagination.limit == 100, @"The pagination object should have a limit of 100.");
}

- (void)testReturningTheDictionaryValue
{
    RDKPagination *pagination = [RDKPagination paginationWithLimit:50];
    pagination.before = @"12345";
    pagination.timeMethod = RDKTimeSortingMethodThisHour;
    
    // Test the first dictionary value:
    
    NSDictionary *dictionaryValue = [pagination dictionaryValue];
    NSDictionary *expectedValue = @{@"limit": @"50", @"before": @"12345", @"t": @"hour"};
    
    XCTAssertTrue([dictionaryValue isEqualToDictionary:expectedValue], @"The dictionary objects should be equal.");
    
    // Test the second dictionary value:
    
    pagination.after = @"54321";
    pagination.limit = 5;
    
    dictionaryValue = [pagination dictionaryValue];
    expectedValue = @{@"limit": @"5", @"before": @"12345", @"after": @"54321", @"t": @"hour"};
    
    XCTAssertTrue([dictionaryValue isEqualToDictionary:expectedValue], @"The dictionary objects should be equal.");
}

@end
