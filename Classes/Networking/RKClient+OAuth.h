//
//  RKClient+OAuth.h
//  Pods
//
//  Created by Sam Symons on 2015-04-26.
//
//

#import "RKClient.h"

@interface RKClient (OAuth)

- (NSURL *)authenticationURLWithScope:(RKOAuthScope)scope;
- (NSURL *)authenticationURLWithScope:(RKOAuthScope)scope state:(NSString *)state compact:(BOOL)compact;

- (BOOL)handleRedirectURI:(NSURL *)redirectURI;

- (BOOL)hasScope:(RKOAuthScope)scope;
- (NSString *)scopeStringFromScope:(RKOAuthScope)scope;

@end
