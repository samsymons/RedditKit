// RKClient.h
//
// Copyright (c) 2014 Sam Symons (http://samsymons.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFHTTPSessionManager.h"

#import "RKCompletionBlocks.h"
#import "RKPagination.h"
#import "RKOAuthCredential.h"

typedef NS_OPTIONS(NSUInteger, RKOAuthScope) {
    RKOAuthScopeAccount             = 1 << 1,
    RKOAuthScopeCreddits            = 1 << 2,
    RKOAuthScopeEdit                = 1 << 3,
    RKOAuthScopeFlair               = 1 << 4,
    RKOAuthScopeHistory             = 1 << 5,
    RKOAuthScopeIdentity            = 1 << 6,
    RKOAuthScopeManageLiveThreads   = 1 << 7,
    RKOAuthScopeModerationConfig    = 1 << 8,
    RKOAuthScopeModerationFlair     = 1 << 9,
    RKOAuthScopeModerationLog       = 1 << 10,
    RKOAuthScopeModerationOthers    = 1 << 11,
    RKOAuthScopeModerationPosts     = 1 << 12,
    RKOAuthScopeModerationSelf      = 1 << 13,
    RKOAuthScopeModerationWiki      = 1 << 14,
    RKOAuthScopeSubreddits          = 1 << 15,
    RKOAuthScopePrivateMessages     = 1 << 16,
    RKOAuthScopeRead                = 1 << 17,
    RKOAuthScopeReport              = 1 << 18,
    RKOAuthScopeSave                = 1 << 19,
    RKOAuthScopeSubmit              = 1 << 20,
    RKOAuthScopeSubscribe           = 1 << 21,
    RKOAuthScopeVote                = 1 << 22,
    RKOAuthScopeEditWikis           = 1 << 23,
    RKOAuthScopeReadWikis           = 1 << 24
};

extern NSString * const RKClientErrorDomain;

@class RKUser;

@interface RKClient : AFHTTPSessionManager

#pragma mark - Properties

/**
 The currently signed in user.
 */
@property (nonatomic, strong, readonly) RKUser *currentUser;

/**
 The modhash value for the current user.
 */
@property (nonatomic, strong) NSString *modhash;

/**
 The session cookie value for the current user.
 */
@property (nonatomic, strong) NSString *sessionIdentifier;

/**
 How many requests are allowed before the rate limit is reset.
 
 @note This is only accurate at the time of the last request.
 */
@property (nonatomic, assign) NSUInteger rateLimitedRequestsRemaining;

/**
 How many requests have been made in this current rate limited period.
 
 @note This is only accurate at the time of the last request.
 */
@property (nonatomic, assign) NSUInteger rateLimitedRequestsUsed;

/**
 The time, in seconds, until the rate limit resets.
 
 @note This is only accurate at the time of the last request.
 */
@property (nonatomic, assign) NSTimeInterval timeUntilRateLimitReset;

/**
 The user agent for requests sent to reddit.
 */
@property (nonatomic, strong) NSString *userAgent;

#pragma mark - OAuth Properties

@property (nonatomic, strong) RKOAuthCredential *authorizationCredential;

@property (nonatomic, assign) RKOAuthScope authorizationScope;

#pragma mark - Methods

+ (instancetype)sharedClient;

/**
 The URL to base HTTP requests on. Override this in an RKClient subclass to change the base URL.
 */
+ (NSURL *)APIBaseURL;

/**
 The URL to base OAuth requests on. Override this in an RKClient subclass to change the base OAuth URL.
 */
+ (NSURL *)APIBaseOAuthURL;

/**
 Signs into reddit.
 
 @param username The user's username.
 @param password The user's password.
 @param completion The block to be executed upon completion of the request.
 
 @note This method signs out the current client before attempting to sign in.
 */
- (NSURLSessionDataTask *)signInWithUsername:(NSString *)username password:(NSString *)password completion:(RKCompletionBlock)completion;

/**
 Specifies your OAuth client identifier and redirect URI when authenticating with OAuth.
 
 @param clientIdentifier Your applications client identifier.
 @param password Your applications redirect URI.
 */
- (void)authenticateWithClientIdentifier:(NSString *)clientIdentifier redirectURI:(NSURL *)redirectURI;

/**
 Updates the current user. This is useful for getting updated karma totals, or checking whether they have unread private messages.
 
 @param completion The block to be executed upon completion of the request.
 */
- (void)updateCurrentUserWithCompletion:(RKCompletionBlock)completion;

/**
 Whether or not there is a user currently authenticated via their username and password.
 
 @note This returns YES if there is an existing modhash value, but cannot guarantee its validity.
 */
- (BOOL)isAuthenticated;

/**
 Whether or not there is a user currently signed in via OAuth.
 
 @note This returns YES if there is an existing authorization code value, but cannot guarantee its validity.
 */
- (BOOL)isAuthenticatedWithOAuth;

/**
 Signs the current user out.
 */
- (void)signOut;

@end
