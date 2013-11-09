//
//  RKMultiredditTests.m
//  Tests
//
//  Created by Sam Symons on 2013-10-12.
//
//

#import "RKTestCase.h"

@interface RKMultiredditTests : RKTestCase

@property (nonatomic, strong) RKMultireddit *multireddit;

@end

@implementation RKMultiredditTests

- (void)setUp
{
    NSDictionary *multiredditJSON = [self JSONFromLocalFileWithName:@"multireddit"];
    self.multireddit = [MTLJSONAdapter modelOfClass:[RKMultireddit class] fromJSONDictionary:multiredditJSON error:nil];
}

- (void)testGettingTheMultiredditUsername
{
    NSString *username = [[self multireddit] username];
    XCTAssert([username isEqualToString:@"Lapper"], @"The multireddit's username is incorrect.");
}

@end
