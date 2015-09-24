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
 Parses a redirect URI and verifies that it matches the redirectURI assigned to 
 this RKClient.
 */
- (BOOL)isRedirectURI:(NSURL *)redirectURI;

/**
 Parses a redirect URI from reddit and configures the current RKClient with
 the appropriate authorization.
 */
- (void)handleRedirectURI:(NSURL *)redirectURI completion:(RKObjectCompletionBlock)completion
;
/**
 Retrieves an OAuth access token using the current authorization code.
 */
- (NSURLSessionDataTask *)retrieveAccessTokenWithCompletion:(RKObjectCompletionBlock)completion;

/**
 Retrieves an OAuth access token using a custom authorization code.
 */
- (NSURLSessionDataTask *)retrieveAccessTokenWithAuthorizationCode:(NSString *)authorizationCode completion:(RKObjectCompletionBlock)completion;

/**
 Refreshes the OAuth access token using a custom authorization refresh code.
 */
- (NSURLSessionDataTask *)refreshAccessTokenWithCompletion:(RKObjectCompletionBlock)completion;

/**
 Refreshes the OAuth access token using a custom authorization refresh code.
 */
- (NSURLSessionDataTask *)refreshAccessTokenWithCompletion:(NSString *)refreshToken completion:(RKObjectCompletionBlock)completion;

- (BOOL)hasScope:(RKOAuthScope)scope;

- (NSString *)scopeStringFromScope:(RKOAuthScope)scope;

@end
