// AuthenticationManager.m
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

#import "AuthenticationManager.h"
#import "OAuthViewController.h"
#import "RKOAuthClient.h"

@interface AuthenticationManager ()

@property (nonatomic, copy) AuthenticationSuccessBlock authenticationSuccessBlock;

- (UIAlertView *)signInAlertView;

@end

@implementation AuthenticationManager

- (void)showSignInAlertViewWithCompletion:(AuthenticationSuccessBlock)completion
{
    self.authenticationSuccessBlock = completion;
    
    [[self authenticationMethodActionSheet] showInView:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
}

#pragma mark - Private

- (UIActionSheet *)authenticationMethodActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"How would you like to authenticate?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Username/Password", @"OAuth", nil];
    return actionSheet;
}

- (UIAlertView *)signInAlertView
{   
    UIAlertView *signInAlert = [[UIAlertView alloc] initWithTitle:@"Reddit Account"
                                                          message:@"Please enter your account credentials."
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Sign In", nil];
    signInAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    return signInAlert;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *username = [[alertView textFieldAtIndex:0] text];
        NSString *password = [[alertView textFieldAtIndex:1] text];
        
        if ([username length] == 0 || [password length] == 0)
        {
            return;
        }
        
        __weak __typeof(self)weakSelf = self;
        [[RKClient sharedClient] signInWithUsername:username password:password completion:^(NSError *error) {
            if (error)
            {
                UIAlertView *errorAlertView = [weakSelf signInAlertView];
                errorAlertView.message = error.localizedFailureReason;
                
                [errorAlertView show];
            }
            else
            {
                if (self.authenticationSuccessBlock)
                {
                    dispatch_async(dispatch_get_main_queue(), self.authenticationSuccessBlock);
                }
            }
        }];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[self signInAlertView] show];
    }
    else if (buttonIndex == 1)
    {
        NSAssert([kOAuthClientID length], @"Make sure you've entered a value for kOAuthClientID in Example-Prefix.pch.");
        NSAssert([kOAuthClientSecret length], @"Make sure you've entered a value for kOAuthClientSecret in Example-Prefix.pch.");
        
        OAuthViewController *oauthViewController = [[OAuthViewController alloc] init];
        UINavigationController *navigationController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        [navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:oauthViewController] animated:YES completion:^{
            [[RKOAuthClient sharedClient] setClientId:kOAuthClientID];
            [[RKOAuthClient sharedClient] setClientSecret:kOAuthClientSecret];
            NSURL *authUrl = [[RKOAuthClient sharedClient] oauthURLWithRedirectURI:kOAuthRedirectURI state:kOAuthState scope:@[kOAuthScopeIdentity, kOAuthScopeVote]];
            [oauthViewController.webView loadRequest:[NSURLRequest requestWithURL:authUrl]];
        }];
    }
}

@end
