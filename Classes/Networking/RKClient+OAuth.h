//
//  RKClient+OAuth.h
//  Pods
//
//  Created by Sam Symons on 2015-04-26.
//
//

#import "RKClient.h"

typedef NS_OPTIONS(NSUInteger, RKOAuthScope) {
    RKOAuthScopeAccount             = 1 << 0,
    RKOAuthScopeCreddits            = 1 << 1,
    RKOAuthScopeEdit                = 1 << 2,
    RKOAuthScopeFlair               = 1 << 3,
    RKOAuthScopeHistory             = 1 << 4,
    RKOAuthScopeIdentity            = 1 << 5,
    RKOAuthScopeManageLiveThreads   = 1 << 6,
    RKOAuthScopeModerationConfig    = 1 << 7,
    RKOAuthScopeModerationFlair     = 1 << 8,
    RKOAuthScopeModerationLog       = 1 << 9,
    RKOAuthScopeModerationOthers    = 1 << 10,
    RKOAuthScopeModerationPosts     = 1 << 11,
    RKOAuthScopeModerationSelf      = 1 << 12,
    RKOAuthScopeModerationWiki      = 1 << 13,
    RKOAuthScopeSubreddits          = 1 << 14,
    RKOAuthScopePrivateMessages     = 1 << 15,
    RKOAuthScopeRead                = 1 << 16,
    RKOAuthScopeReport              = 1 << 17,
    RKOAuthScopeSave                = 1 << 18,
    RKOAuthScopeSubmit              = 1 << 19,
    RKOAuthScopeSubscribe           = 1 << 20,
    RKOAuthScopeVote                = 1 << 21,
    RKOAuthScopeEditWikis           = 1 << 22,
    RKOAuthScopeReadWikis           = 1 << 23
};

@interface RKClient (OAuth)

- (NSURL *)authenticationURLWithScope:(RKOAuthScope)scope;
- (NSURL *)authenticationURLWithScope:(RKOAuthScope)scope state:(NSString *)state compact:(BOOL)compact;

- (BOOL)handleRedirectURI:(NSURL *)redirectURI;

- (NSString *)scopeStringFromScope:(RKOAuthScope)scope;

@end
