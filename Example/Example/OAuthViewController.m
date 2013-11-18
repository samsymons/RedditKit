//
//  OAuthViewController.m
//  Example
//
//  Created by Joseph Pintozzi on 11/17/13.
//  Copyright (c) 2013 Sam Symons. All rights reserved.
//

#import "OAuthViewController.h"
#import "RKOAuthClient.h"

@implementation OAuthViewController

- (NSArray *)toolbarItems
{
    return nil;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString hasPrefix:kOAuthRedirectURI]) {
        NSString *paramString = [request.URL.absoluteString componentsSeparatedByString:@"?"][1];
        NSArray *params = [paramString componentsSeparatedByString:@"&"];
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        for (NSString *string in params) {
            NSArray *components = [string componentsSeparatedByString:@"="];
            [paramDict setValue:components[1] forKey:components[0]];
        }
        if (paramDict[@"code"]) {
            [[RKOAuthClient sharedClient] signInWithAccessCode:paramDict[@"code"] redirectURI:kOAuthRedirectURI state:kOAuthState completion:^(NSError *error) {
                UINavigationController *navigationController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
                [navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            return NO;
        }
    }
    return YES;
}

@end
