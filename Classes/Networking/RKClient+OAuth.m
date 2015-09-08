//
//  RKClient+OAuth.m
//  Pods
//
//  Created by Sam Symons on 2015-04-26.
//
//

#import "RKClient+OAuth.h"

#import "RKClient+Requests.h"
#import "RKClient+Errors.h"

#import "RKAccessToken.h"

@implementation RKClient (OAuth)

#pragma mark - Authorization

- (NSURL *)authenticationURLWithScope:(RKOAuthScope)scope
{
    return [self authenticationURLWithScope:scope state:nil compact:YES];
}

- (NSURL *)authenticationURLWithScope:(RKOAuthScope)scope state:(NSString *)state compact:(BOOL)compact
{
    NSParameterAssert(scope);
    NSParameterAssert(self.authorizationCredential.clientIdentifier);
    NSParameterAssert(self.authorizationCredential.redirectURI);

    NSString *scopeString = [self scopeStringFromScope:scope];

    if (scopeString == nil) {
        NSLog(@"No scope was provided");
        return nil;
    }

    self.authorizationScope = scope;

    // Build up the authorization URL to present in the browser.
    //
    // Parameters:
    //
    // client_id = The app's client identifier
    // response_type = For mobile apps, this is always set to `code`
    // state = A random string, used to ensure that callback URLs are not faked
    // redirect_uri = The redirect URI chosen when setting up the OAuth application on Reddit
    // duration = For mobile apps, this is always set to `permanent`
    // scope = The authorization scope string passed into this method

    NSString *authorizeString = @"authorize";
    if (compact) {
        authorizeString = @"authorize.compact";
    }

    NSString *URL = [[NSString alloc] initWithFormat:@"https://ssl.reddit.com/api/v1/%@?client_id=%@&response_type=code&state=RedditKit&redirect_uri=%@&duration=permanent&scope=%@", authorizeString, self.authorizationCredential.clientIdentifier, self.authorizationCredential.redirectURI, scopeString];
    
    return [NSURL URLWithString:URL];
}

- (BOOL)isRedirectURI:(NSURL *)redirectURI
{
    if ([self.authorizationCredential.redirectURI.scheme isEqualToString:redirectURI.scheme] && [self.authorizationCredential.redirectURI.host isEqualToString:redirectURI.host]) {
        return YES;
    }
    
    return NO;
}

- (void)handleRedirectURI:(NSURL *)redirectURI completion:(RKObjectCompletionBlock)completion
{
    NSArray *queryParams = [[redirectURI query] componentsSeparatedByString:@"&"];
    NSArray *codeParam = [queryParams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", @"code="]];
    
    if ([codeParam count] > 0) {
        NSString *codeQuery = [codeParam objectAtIndex:0];
        NSString *code = [codeQuery stringByReplacingOccurrencesOfString:@"code=" withString:@""];
        self.authorizationCredential.authorizationCode = code;
        
        if (completion) {
            completion(nil, nil);
        }
    }
    else {
        if (completion) {
            completion(nil, [[self class] invalidOAuthRequestError]);
        }
    }
}

- (NSURLSessionDataTask *)retrieveAccessTokenWithCompletion:(RKObjectCompletionBlock)completion
{
    return [self retrieveAccessTokenWithAuthorizationCode:self.authorizationCredential.authorizationCode completion:completion];
}

- (NSURLSessionDataTask *)retrieveAccessTokenWithAuthorizationCode:(NSString *)authorizationCode completion:(RKObjectCompletionBlock)completion
{
    NSParameterAssert(authorizationCode);
    
    NSDictionary *parameters = @{ @"grant_type": @"authorization_code", @"code": authorizationCode, @"redirect_uri": self.authorizationCredential.redirectURI };
    
    return [self postPath:@"api/v1/access_token" parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (responseObject[@"error"]) {
            error = [RKClient invalidOAuthGrantError];
        }
        else {
            RKAccessToken *token = [[RKAccessToken alloc] init];
            token.accessToken = responseObject[@"access_token"];
            token.refreshToken = responseObject[@"refresh_token"];
            
            RKOAuthCredential *credential = self.authorizationCredential;
            credential.accessToken = token;
            
            self.authorizationCredential = credential;
        }
        

        if (completion) {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)refreshAccessTokenWithCompletion:(RKObjectCompletionBlock)completion
{
    return [self refreshAccessTokenWithCompletion:self.authorizationCredential.accessToken.refreshToken completion:completion];
}

- (NSURLSessionDataTask *)refreshAccessTokenWithCompletion:(NSString *)refreshToken completion:(RKObjectCompletionBlock)completion
{
    NSParameterAssert(refreshToken);
    
    RKOAuthCredential *credential = self.authorizationCredential;
    credential.accessToken = nil;
    
    self.authorizationCredential = credential;
    
    NSDictionary *parameters = @{ @"grant_type": @"refresh_token", @"refresh_token": refreshToken };
    
    return [self postPath:@"api/v1/access_token" parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (responseObject[@"error"]) {
            error = [RKClient invalidOAuthGrantError];
        }
        else {
            RKAccessToken *token = [[RKAccessToken alloc] init];
            token.accessToken = responseObject[@"access_token"];
            token.refreshToken = refreshToken;
            
            RKOAuthCredential *credential = self.authorizationCredential;
            credential.accessToken = token;
            
            self.authorizationCredential = credential;
        }
        
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (BOOL)hasScope:(RKOAuthScope)scope
{
    return (self.authorizationScope & scope);
}

- (NSString *)scopeStringFromScope:(RKOAuthScope)scope
{
    NSParameterAssert(scope);

    if (scope == 0) {
        return nil;
    }
    
    NSMutableArray *scopes = [[NSMutableArray alloc] init];
    
    if (scope & RKOAuthScopeAccount) {
        [scopes addObject:@"account"];
    }
    if (scope & RKOAuthScopeCreddits) {
        [scopes addObject:@"creddits"];
    }
    if (scope & RKOAuthScopeEdit) {
        [scopes addObject:@"edit"];
    }
    if (scope & RKOAuthScopeFlair) {
        [scopes addObject:@"flair"];
    }
    if (scope & RKOAuthScopeHistory) {
        [scopes addObject:@"history"];
    }
    if (scope & RKOAuthScopeIdentity) {
        [scopes addObject:@"identity"];
    }
    if (scope & RKOAuthScopeManageLiveThreads) {
        [scopes addObject:@"livemanage"];
    }
    if (scope & RKOAuthScopeModerationConfig) {
        [scopes addObject:@"modconfig"];
    }
    if (scope & RKOAuthScopeModerationFlair) {
        [scopes addObject:@"modflair"];
    }
    if (scope & RKOAuthScopeModerationLog) {
        [scopes addObject:@"modlog"];
    }
    if (scope & RKOAuthScopeModerationOthers) {
        [scopes addObject:@"modothers"];
    }
    if (scope & RKOAuthScopeModerationPosts) {
        [scopes addObject:@"modposts"];
    }
    if (scope & RKOAuthScopeModerationSelf) {
        [scopes addObject:@"modself"];
    }
    if (scope & RKOAuthScopeModerationWiki) {
        [scopes addObject:@"modwiki"];
    }
    if (scope & RKOAuthScopeSubreddits) {
        [scopes addObject:@"mysubreddits"];
    }
    if (scope & RKOAuthScopePrivateMessages) {
        [scopes addObject:@"privatemessages"];
    }
    if (scope & RKOAuthScopeRead) {
        [scopes addObject:@"read"];
    }
    if (scope & RKOAuthScopeReport) {
        [scopes addObject:@"report"];
    }
    if (scope & RKOAuthScopeSave) {
        [scopes addObject:@"save"];
    }
    if (scope & RKOAuthScopeSubmit) {
        [scopes addObject:@"submit"];
    }
    if (scope & RKOAuthScopeSubscribe) {
        [scopes addObject:@"subscribe"];
    }
    if (scope & RKOAuthScopeVote) {
        [scopes addObject:@"vote"];
    }
    if (scope & RKOAuthScopeEditWikis) {
        [scopes addObject:@"wikiedit"];
    }
    if (scope & RKOAuthScopeReadWikis) {
        [scopes addObject:@"wikiread"];
    }
    
    return [scopes componentsJoinedByString:@","];
}

@end
