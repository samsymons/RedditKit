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
    if ([request.URL.absoluteString hasPrefix:kOAuthRedirectURI])
    {
        NSString *parameterString = [request.URL.absoluteString componentsSeparatedByString:@"?"][1];
        NSArray *parameters = [parameterString componentsSeparatedByString:@"&"];
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        
        for (NSString *string in parameters)
        {
            NSArray *components = [string componentsSeparatedByString:@"="];
            [paramDict setValue:components[1] forKey:components[0]];
        }
        
        if (paramDict[@"code"])
        {
            __weak __typeof(self)weakSelf = self;
            
            [[RKOAuthClient sharedClient] signInWithAccessCode:paramDict[@"code"] redirectURI:kOAuthRedirectURI state:kOAuthState completion:^(NSError *error) {
                if (error)
                {
                    NSLog(@"Failed to authenticate with OAuth: %@", error);
                }
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
            
            return NO;
        }
    }
    
    return YES;
}

@end
