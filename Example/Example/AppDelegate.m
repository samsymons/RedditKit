// AppDelegate.m
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

#import "AppDelegate.h"
#import "FrontPageViewController.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.tintColor = [UIColor whiteColor];
    
	FrontPageViewController *frontPageViewController = [[FrontPageViewController alloc] init];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontPageViewController];
    
    [self configureAppearance];
    
    self.window.rootViewController = navigationController;
    [[self window] makeKeyAndVisible];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [[RKClient sharedClient] setUserAgent:@"RedditKit 1.0.0 Example Project"];
    });
	
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"redditkit"]) {
        [[RKClient sharedClient] handleRedirectURI:url];

        [[RKClient sharedClient] retrieveAccessTokenWithCompletion:^(id object, NSError *error) {
            // TODO: Complete the OAuth flow here.
        }];
        
        return YES;
    }
    
    return NO;
}

- (void)configureAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIColor *tintColor = [UIColor colorWithRed:0.61 green:0.09 blue:0.09 alpha:1.0];
    NSDictionary *titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
    
    [[UINavigationBar appearance] setBarTintColor:tintColor];
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributes];
    [[UIToolbar appearance] setBarTintColor:tintColor];
}

@end
