//
//  RKClient+OAuth.m
//  Pods
//
//  Created by Sam Symons on 2015-04-26.
//
//

#import "RKClient+OAuth.h"

#import "RKClient+Requests.h"

#import "RKAccessToken.h"

@implementation RKClient (OAuth)

#pragma mark - Authorization

- (NSURL *)authenticationURLWithScope:(RKOAuthScope)scope redirectURI:(NSString *)redirectURI
{
    return [self authenticationURLWithScope:scope redirectURI:redirectURI state:nil compact:YES];
}

- (NSURL *)authenticationURLWithScope:(RKOAuthScope)scope redirectURI:(NSString *)redirectURI state:(NSString *)state compact:(BOOL)compact
{
    NSParameterAssert(scope);
    NSParameterAssert(redirectURI);

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

    NSString *URL = [[NSString alloc] initWithFormat:@"https://ssl.reddit.com/api/v1/authorize?client_id=%@&response_type=code&state=RedditKit&redirect_uri=%@&duration=permanent&scope=%@", self.authorizationCredential.clientIdentifier, redirectURI, scopeString];
    
    return [NSURL URLWithString:URL];
}

- (BOOL)handleRedirectURI:(NSURL *)redirectURI
{
    NSArray *queryParams = [[redirectURI query] componentsSeparatedByString:@"&"];
    NSArray *codeParam = [queryParams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", @"code="]];
    
    if ([codeParam count] > 0) {
        NSLog(@"Code param: %@", codeParam);

        NSString *codeQuery = [codeParam objectAtIndex:0];
        NSString *code = [codeQuery stringByReplacingOccurrencesOfString:@"code=" withString:@""];
        self.authorizationCredential.authorizationCode = code;
        
        return YES;
    }
    
    return NO;
}

- (NSURLSessionDataTask *)retrieveAccessTokenWithAuthorizationCode:(NSString *)authorizationCode completion:(RKObjectCompletionBlock)completion
{
    NSDictionary *parameters = @{ @"grant_type": @"authorization_code", @"code": authorizationCode, @"redirect_uri": @"redditkit://oauth" };
    
    return [self postPath:@"api/v1/access_token" parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        RKAccessToken *token = [[RKAccessToken alloc] init];
        token.accessToken = responseObject[@"access_token"];

        self.authorizationCredential.accessToken = token;
        self.authorizationCredential = self.authorizationCredential;

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
