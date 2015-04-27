//
//  RKClient+OAuth.m
//  Pods
//
//  Created by Sam Symons on 2015-04-26.
//
//

#import "RKClient+OAuth.h"

@implementation RKClient (OAuth)

#pragma mark - Authorization

- (NSURL *)authenticationURLWithScope:(RKOAuthScope)scope
{
    return [self authenticationURLWithScope:scope state:nil compact:YES];
}

- (NSURL *)authenticationURLWithScope:(RKOAuthScope)scope state:(NSString *)state compact:(BOOL)compact
{
    NSString *scopeString = [self scopeStringFromScope:scope];
    NSString *URL = [[NSString alloc] initWithFormat:@"https://ssl.reddit.com/api/v1/authorize.compact?client_id=%@&response_type=code&state=RedditKit&redirect_uri=redditkit://oauth&duration=permanent&scope=%@", self.clientIdentifier, scopeString];
    
    return [NSURL URLWithString:URL];
}

- (BOOL)handleRedirectURI:(NSURL *)redirectURI
{
    NSArray *queryParams = [[redirectURI query] componentsSeparatedByString:@"&"];
    NSArray *codeParam = [queryParams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", @"code="]];
    
    if ([codeParam count] > 0) {
        NSString *codeQuery = [codeParam objectAtIndex:0];
        NSString *code = [codeQuery stringByReplacingOccurrencesOfString:@"code=" withString:@""];
        
        [[RKClient sharedClient] setAuthorizationCode:code];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)hasScope:(RKOAuthScope)scope
{
    return (self.authorizationScope & scope);
}

- (NSString *)scopeStringFromScope:(RKOAuthScope)scope
{
    NSParameterAssert(scope);
    
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
        [scopes addObject:@"subreddits"];
    }
    if (scope & RKOAuthScopeSubreddits) {
        [scopes addObject:@"privatesubreddits"];
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
