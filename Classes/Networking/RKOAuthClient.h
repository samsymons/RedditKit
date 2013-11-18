// RKOAuthClient.h
//
// Copyright (c) 2013 Sam Symons (http://samsymons.com/)
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

#import "RKClient.h"

/**
 The different kinds of scope the OAuth client can request
 Explainations found here: http://www.reddit.com/dev/api
 */

typedef NS_ENUM(NSUInteger, RDKOAuthScope) {
    RDKOAuthScopeNone                   = 0,
    RDKOAuthScopeEdit                   = (1 << 0), // Edit or delete a user's comments and links.
    RDKOAuthScopeHistory                = (1 << 1), // Read a user's content, such as comments, links, or saved items.
    RDKOAuthScopeIdentity               = (1 << 2), // Access information about the current user.
    RDKOAuthScopeModeratorConfiguration  = (1 << 3), // Modify a subreddit's settings, including stylesheet and header image.
    RDKOAuthScopeModeratorFlair          = (1 << 4), // Modify a subredddit's flair.
    RDKOAuthScopeModeratorLog            = (1 << 5), // Read a subreddit's moderation log.
    RDKOAuthScopeModeratorPosts          = (1 << 6), // Modify links in a subreddit, such as removing them or marking them as NSFW.
    RDKOAuthScopeMySubreddits            = (1 << 7), // Read the subreddits a user subscribes to.
    RDKOAuthScopePrivateMessages         = (1 << 8), // Read a user's private messages.
    RDKOAuthScopeRead                    = (1 << 9), // Access a user's multireddits and contents of subreddits.
    RDKOAuthScopeSave                    = (1 << 10), // Save or unsave content.
    RDKOAuthScopeSubmit                  = (1 << 11), // Submit links or comments.
    RDKOAuthScopeSubscribe               = (1 << 12), // Subscribe to a subreddit, or interact with multireddits.
    RDKOAuthScopeVote                    = (1 << 13), // Vote on links or comments.
};

@interface RKOAuthClient : RKClient

/**
 The client's OAuth identifier.
 */
@property (nonatomic, copy) NSString *clientIdentifier;

/**
 The client's OAuth secret.
 */
@property (nonatomic, copy) NSString *clientSecret;

/**
 The client's OAuth access token.
 */
@property (nonatomic, strong) NSString *accessToken;

/**
 The client's OAuth refresh token.
 */
@property (nonatomic, strong) NSString *refreshToken;

/**
 Returns a RKClient ready for OAuth.
 
 @see https://github.com/reddit/reddit/wiki/OAuth2
 */
- (id)initWithClientIdentifier:(NSString *)clientIdentifier clientSecret:(NSString *)clientSecret;

/**
 Returns the scope string for given OAuth scopes.
 */
+ (NSString *)scopeStringForAuthScopes:(RDKOAuthScope)scopes;

/**
 Signs into reddit via OAuth.
 */
- (NSURL *)oauthURLWithRedirectURI:(NSString *)redirectURI state:(NSString *)state scope:(RDKOAuthScope)scope;

- (NSURLSessionDataTask *)signInWithAccessCode:(NSString *)accessCode redirectURI:(NSString *)redirectURI state:(NSString *)state completion:(RKCompletionBlock)completion;

- (NSURLSessionDataTask *)refreshAccessToken:(NSString*)refreshToken redirectURI:(NSString *)redirectURI state:(NSString *)state completion:(RKCompletionBlock)completion;

@end
