//
//  RDKMultiredditTests.m
//  Tests
//
//  Created by Sam Symons on 2013-10-12.
//
//

#import "RDKTestCase.h"

@interface RDKMultiredditTests : RDKTestCase

@property (nonatomic, strong) RDKMultireddit *multireddit;

@end

@implementation RDKMultiredditTests

- (void)setUp
{
    NSDictionary *multiredditJSON = [self JSONFromLocalFileWithName:@"multireddit"];
    self.multireddit = [MTLJSONAdapter modelOfClass:[RDKMultireddit class] fromJSONDictionary:multiredditJSON error:nil];
}

- (void)testGettingTheMultiredditUsername
{
    NSString *username = [[self multireddit] username];
    XCTAssert([username isEqualToString:@"Lapper"], @"The multireddit's username is incorrect.");
}

@end
