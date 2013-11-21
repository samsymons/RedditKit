// RKOAuthClient.m
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

#import "RKOAuthClient.h"
#import "RKUser.h"
#import "RKResponseSerializer.h"
#import "RKObjectBuilder.h"

#import "RKClient+Users.h"

@interface RKOAuthClient ()

@property (nonatomic, strong) RKUser *currentUser;
@property (nonatomic, strong) NSTimer *tokenRefreshTimer;

@end

@implementation RKOAuthClient

- (id)initWithClientIdentifier:(NSString *)clientIdentifier clientSecret:(NSString *)clientSecret
{
    if (self = [super initWithBaseURL:[[self class] APIBaseURL]])
    {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [RKResponseSerializer serializer];
        
        _clientIdentifier = clientIdentifier;
        _clientSecret = clientSecret;
    }
    
    return self;
}

/*
+ (NSURL *)APIBaseURL
{
    return [[self class] APIBaseHTTPSURL];
}
 */

+ (NSURL *)APIBaseHTTPSURL
{
    return [NSURL URLWithString:@"https://oauth.reddit.com/"];
}

+ (NSURL *)APIBaseAuthenticationURL
{
    return [NSURL URLWithString:@"https://ssl.reddit.com/"];
}

+ (NSString *)userInformationURLPath
{
    return @"api/v1/me";
}

+ (NSString *)scopeStringForOAuthScopes:(RDKOAuthScope)scopes
{
    if (scopes == RDKOAuthScopeNone) return nil;
    
    NSMutableArray *scopeValues = [[NSMutableArray alloc] initWithCapacity:13];
    
    if ((scopes & RDKOAuthScopeEdit) == RDKOAuthScopeEdit) [scopeValues addObject:@"edit"];
    if ((scopes & RDKOAuthScopeHistory) == RDKOAuthScopeHistory) [scopeValues addObject:@"history"];
    if ((scopes & RDKOAuthScopeIdentity) == RDKOAuthScopeIdentity) [scopeValues addObject:@"identity"];
    if ((scopes & RDKOAuthScopeModeratorConfiguration) == RDKOAuthScopeModeratorConfiguration) [scopeValues addObject:@"modconfig"];
    if ((scopes & RDKOAuthScopeModeratorFlair) == RDKOAuthScopeModeratorFlair) [scopeValues addObject:@"modflair"];
    if ((scopes & RDKOAuthScopeModeratorLog) == RDKOAuthScopeModeratorLog) [scopeValues addObject:@"modlog"];
    if ((scopes & RDKOAuthScopeModeratorPosts) == RDKOAuthScopeModeratorPosts) [scopeValues addObject:@"modposts"];
    if ((scopes & RDKOAuthScopeMySubreddits) == RDKOAuthScopeMySubreddits) [scopeValues addObject:@"mysubreddits"];
    if ((scopes & RDKOAuthScopePrivateMessages) == RDKOAuthScopePrivateMessages) [scopeValues addObject:@"privatemessages"];
    if ((scopes & RDKOAuthScopeRead) == RDKOAuthScopeRead) [scopeValues addObject:@"read"];
    if ((scopes & RDKOAuthScopeSave) == RDKOAuthScopeSave) [scopeValues addObject:@"save"];
    if ((scopes & RDKOAuthScopeSubmit) == RDKOAuthScopeSubmit) [scopeValues addObject:@"submit"];
    if ((scopes & RDKOAuthScopeSubscribe) == RDKOAuthScopeSubscribe) [scopeValues addObject:@"subscribe"];
    if ((scopes & RDKOAuthScopeVote) == RDKOAuthScopeVote) [scopeValues addObject:@"vote"];
    
    return [scopeValues componentsJoinedByString:@","];
}

- (void)setOAuthorizationHeader
{
    NSAssert(self.clientIdentifier != nil, @"You must first set a clientIdentifier.");
    NSAssert(self.clientSecret != nil, @"You must first set a clientSecret.");
    
    [[self requestSerializer] setAuthorizationHeaderFieldWithUsername:self.clientIdentifier password:self.clientSecret];
}

- (NSURL *)oauthURLWithRedirectURI:(NSString *)redirectURI state:(NSString *)state scope:(RDKOAuthScope)scope
{
    NSParameterAssert(redirectURI);
    NSParameterAssert(scope);
    
    NSAssert(_clientIdentifier != nil, @"You must first set a clientIdentifier");
    
    NSURL *signInURL = [[self class] APIBaseAuthenticationURL];
    NSString *escapedRedirectURI = [redirectURI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *scopeString = [RKOAuthClient scopeStringForOAuthScopes:scope];
    
    NSMutableString *URLString = [NSMutableString stringWithFormat:@"%@api/v1/authorize?response_type=code&duration=permanent&redirect_uri=%@&client_id=%@&scope=%@", signInURL, escapedRedirectURI, _clientIdentifier, scopeString];
    
    if (state)
    {
        [URLString appendFormat:@"&state=%@", state];
    }

    return [NSURL URLWithString:URLString];
}

- (NSURLSessionDataTask *)signInWithAccessCode:(NSString *)accessCode redirectURI:(NSString *)redirectURI state:(NSString *)state completion:(RKCompletionBlock)completion
{
    NSParameterAssert(accessCode);
    NSParameterAssert(redirectURI);
    NSParameterAssert(state);
    
    NSDictionary *parameters = @{@"code": accessCode, @"state": state, @"redirect_uri": redirectURI, @"grant_type": @"authorization_code"};
    return [self accessTokensWithParams:parameters completion:completion];
}

- (NSURLSessionDataTask *)refreshAccessTokenWithTimer:(NSTimer *)timer
{
    NSDictionary *parameters = timer.userInfo;
    return [self refreshAccessToken:_refreshToken redirectURI:parameters[@"redirect_uri"] state:parameters[@"state"] completion:nil];
}

- (NSURLSessionDataTask *)refreshAccessToken:(NSString *)refreshToken redirectURI:(NSString *)redirectURI state:(NSString *)state completion:(RKCompletionBlock)completion
{
    NSParameterAssert(refreshToken);
    NSParameterAssert(redirectURI);
    NSParameterAssert(state);
    
    NSDictionary *parameters = @{@"refresh_token": refreshToken, @"state": state, @"redirect_uri": redirectURI, @"grant_type": @"refresh_token"};
    return [self accessTokensWithParams:parameters completion:completion];
}

- (NSURLSessionDataTask *)userInfoWithCompletion:(RKObjectCompletionBlock)completion
{
    NSURL *baseURL = [[self class] APIBaseAuthenticationURL];
    NSString *URLString = [[NSURL URLWithString:[[self class] userInformationURLPath] relativeToURL:baseURL] absoluteString];
    
    NSMutableURLRequest *request = [[self requestSerializer] requestWithMethod:@"GET" URLString:URLString parameters:@{}];
    
    NSURLSessionDataTask *authenticationTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (completion) {
            completion(responseObject, error);
        }
    }];
    
    [authenticationTask resume];
    
    return authenticationTask;
}

- (NSURLSessionDataTask *)accessTokensWithParams:(NSDictionary*)parameters completion:(RKCompletionBlock)completion
{
    [self setOAuthorizationHeader];
    NSURL *baseURL = [[self class] APIBaseAuthenticationURL];
    NSString *URLString = [[NSURL URLWithString:@"api/v1/access_token" relativeToURL:baseURL] absoluteString];
    
    NSMutableURLRequest *request = [[self requestSerializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters];
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *authenticationTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error)
        {
            _accessToken = responseObject[@"access_token"];
            _refreshToken = responseObject[@"refresh_token"];
            //if our token expires, we should refresh it
            if (responseObject[@"expires_in"]) {
                //if we have an existing timer, invalidate it so it doesn't fire twice
                if (_tokenRefreshTimer) {
                    [_tokenRefreshTimer invalidate];
                }
                int seconds = [responseObject[@"expires_in"] intValue] - 10; //be a little aggressive and refresh 10 seconds before our token expires
                _tokenRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(refreshAccessTokenWithTimer:) userInfo:parameters repeats:NO];
            }
            [self setBearerAccessToken:_accessToken];
            
            if (!self.currentUser)
            {
                [weakSelf loadUserAccountWithCompletion:^(NSError *error) {
                    if (completion)
                    {
                        completion(error);
                    }
                }];
            }
            else if (completion)
            {
                completion(nil);
            }
        }
        else if (completion)
        {
            completion(error);
        }
    }];
    
    [authenticationTask resume];
    
    return authenticationTask;
}

- (void)loadUserAccountWithCompletion:(RKCompletionBlock)completion
{
    __weak __typeof(self)weakSelf = self;
    [self userInfoWithCompletion:^(id object, NSError *error) {
        RKUser *account = [RKObjectBuilder objectFromJSON:@{@"kind": kRKObjectTypeAccount, @"data":object}];
        if (account && !error)
        {
            weakSelf.currentUser = account;
            
            if (completion)
            {
                completion(nil);
            }
        }
        else if (completion)
        {
            completion(error);
        }
    }];
}

- (BOOL)isSignedIn
{
	return self.modhash != nil || _accessToken != nil;
}


- (void)setBearerAccessToken:(NSString *)accessToken
{
    [[self requestSerializer] setValue:[@"bearer " stringByAppendingString:accessToken] forHTTPHeaderField:@"Authorization"];
}

@end
