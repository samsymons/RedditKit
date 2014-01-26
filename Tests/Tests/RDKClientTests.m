//
//  RDKClientTests.m
//  Tests
//
//  Created by Sam Symons on 11/5/2013.
//
//

#import "RDKTestCase.h"

@interface RDKClientTests : RDKTestCase

@property (nonatomic, strong) RDKClient *client;

@end

@implementation RDKClientTests

- (void)setUp
{
    self.client = [[RDKClient alloc] init];
    self.client.modhash = @"12345";
    self.client.cookie = @"12345";
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
