//
//  RKClient+OAuth.h
//  Pods
//
//  Created by Sam Symons on 2015-04-26.
//
//

#import "RKClient.h"

@interface RKClient (OAuth)

/**
 Provides an authentication URL to present within a web view.
 This allows the user to authenticate and grant access to your application.
 */
- (NSURL *)authenticationURLWithScope:(RKOAuthScope)scope;

- (NSURL *)authenticationURLWithScope:(RKOAuthScope)scope state:(NSString *)state compact:(BOOL)compact;

/**
 Parses a redirect URI from reddit and configures the current RKClient with
 the appropriate authorization.
 */
- (BOOL)handleRedirectURI:(NSURL *)redirectURI;

/**
 Retrieves an OAuth access token using the current authorization code.
 */
- (NSURLSessionDataTask *)retrieveAccessTokenWithCompletion:(RKObjectCompletionBlock)completion;

/**
 Retrieves an OAuth access token using a custom authorization code.
 */
- (NSURLSessionDataTask *)retrieveAccessTokenWithAuthorizationCode:(NSString *)authorizationCode completion:(RKObjectCompletionBlock)completion;

- (BOOL)hasScope:(RKOAuthScope)scope;

- (NSString *)scopeStringFromScope:(RKOAuthScope)scope;

@end
