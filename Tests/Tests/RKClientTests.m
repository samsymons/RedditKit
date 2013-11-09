//
//  RKClientTests.m
//  Tests
//
//  Created by Sam Symons on 11/5/2013.
//
//

#import "RKTestCase.h"

@interface RKClientTests : RKTestCase

@property (nonatomic, strong) RKClient *client;

@end

@implementation RKClientTests

- (void)setUp
{
    self.client = [[RKClient alloc] init];
    self.client.modhash = @"12345";
}

- (void)testSignedInClients
{
    XCTAssertTrue(self.client.isSignedIn, @"A client should return true when it is signed in.");
}

- (void)testSigningOut
{
    [[self client] signOut];
    
    XCTAssertFalse(self.client.isSignedIn, @"A client should not be signed in after signing out.");
}

@end
