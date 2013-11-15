//
//  RKOAuthClient.h
//  Pods
//
//  Created by Joseph Pintozzi on 11/14/13.
//
//

#import "RKClient.h"

/**
 The different kinds of scope the OAuth client can request
 Explainations found here: http://www.reddit.com/dev/api
 */

static NSString * const kOAuthScopeEdit = @"edit";
static NSString * const kOAuthScopeHistory = @"history";
static NSString * const kOAuthScopeIdentity = @"identity";
static NSString * const kOAuthScopeModConfig = @"modconfig";
static NSString * const kOAuthScopeModFlair = @"modflair";
static NSString * const kOAuthScopeModLog = @"modlog";
static NSString * const kOAuthScopeModPosts = @"modposts";
static NSString * const kOAuthScopeMySubreddits = @"mysubreddits";
static NSString * const kOAuthScopePrivateMessages = @"privatemessages";
static NSString * const kOAuthScopeRead = @"read";
static NSString * const kOAuthScopeSave = @"save";
static NSString * const kOAuthScopeSubmit = @"submit";
static NSString * const kOAuthScopeSubscribe = @"subscribe";
static NSString * const kOAuthScopeVote = @"vote";

@interface RKOAuthClient : RKClient

/**
 The current clientId and clientSecret for this app.
 Only required if authenticating via OAuth
 */
@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;

/**
 Returns a RKClient ready for OAuth
 Get a client ID and secret here: https://ssl.reddit.com/prefs/apps
 */
- (id)initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret;

/**
 Signs into reddit via OAuth
 */
- (NSURL *)oauthURLWithRedirectURI:(NSString *)redirectURI state:(NSString *)state scope:(NSArray*)scope;
- (NSURLSessionDataTask *)signInWithAccessCode:(NSString *)accessCode redirectURI:(NSString *)redirectURI state:(NSString *)state completion:(RKCompletionBlock)completion;
- (NSURLSessionDataTask *)refreshAccessToken:(NSString*)refreshToken redirectURI:(NSString *)redirectURI state:(NSString *)state completion:(RKCompletionBlock)completion;

@end
