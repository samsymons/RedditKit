// RKClient.m
//
// Copyright (c) 2014 Sam Symons (http://samsymons.com/)
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

#import "RKClient.h"

#import "RKAccessToken.h"
#import "RKUser.h"
#import "RKResponseSerializer.h"

#import "RKClient+Users.h"

NSString * const RKClientErrorDomain = @"RKClientErrorDomain";

@interface RKClient ()

@property (nonatomic, strong) RKUser *currentUser;

@end

@implementation RKClient

+ (instancetype)sharedClient
{
    static RKClient *sharedRKClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedRKClient = [[RKClient alloc] init];
    });
    
    return sharedRKClient;
}

- (id)init
{
    if (self = [super initWithBaseURL:[[self class] APIBaseURL]])
    {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [RKResponseSerializer serializer];
    }
    
    return self;
}

- (NSString *)description
{
    if ([self isAuthenticated])
    {
        return [NSString stringWithFormat:@"<%@: %p, username: %@>", NSStringFromClass([self class]), self, self.currentUser.username];
    }
    else
    {
        return [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self];
    }
}

#pragma mark - Class Methods

+ (NSURL *)APIBaseURL
{
    return [NSURL URLWithString:@"https://www.reddit.com/"];
}

+ (NSURL *)APIBaseOAuthURL
{
    return [NSURL URLWithString:@"https://oauth.reddit.com/"];
}

#pragma mark - Authentication

- (NSURLSessionDataTask *)signInWithUsername:(NSString *)username password:(NSString *)password completion:(RKCompletionBlock)completion;
{
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    NSDictionary *parameters = @{@"user": username, @"passwd": password, @"api_type": @"json"};
    
    NSURL *baseURL = [[self class] APIBaseURL];
    NSString *URLString = [[NSURL URLWithString:@"api/login" relativeToURL:baseURL] absoluteString];
    
    NSError *serializerError;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:&serializerError];
    
    if (serializerError) {
        completion(serializerError);
        return nil;
    }
    
    // Login requests fail with 409 if an existing `reddit_session` cookie is included in the request.
    [request setHTTPShouldHandleCookies:NO];
    [self signOut];
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *authenticationTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error)
        {
            if (completion)
            {
                completion(error);
            }
        }
        else
        {
            NSDictionary *data = responseObject[@"json"][@"data"];
            NSString *modhash = data[@"modhash"];
            NSString *sessionIdentifier = data[@"cookie"];
            
            weakSelf.modhash = modhash;
            weakSelf.sessionIdentifier = sessionIdentifier;
            
            [weakSelf currentUserWithCompletion:^(id object, NSError *error) {
                weakSelf.currentUser = object;
                
                if (completion)
                {
                    completion(nil);
                }
            }];
        }
    }];
    
    [authenticationTask resume];
    
    return authenticationTask;
}

- (void)authenticateWithClientIdentifier:(NSString *)clientIdentifier redirectURI:(NSURL *)redirectURI
{
    RKOAuthCredential *credential = [[RKOAuthCredential alloc] init];
    credential.clientIdentifier = clientIdentifier;
    credential.redirectURI = redirectURI;

    self.authorizationCredential = credential;
}

- (void)updateCurrentUserWithCompletion:(RKCompletionBlock)completion
{
    __weak __typeof(self)weakSelf = self;
    [self user:self.currentUser completion:^(RKUser *user, NSError *error) {
        if (user)
        {
            weakSelf.currentUser = user;
        }
        
        if (completion)
        {
            completion(error);
        }
    }];
}

- (BOOL)isAuthenticated
{
    return (self.modhash != nil && self.sessionIdentifier != nil);
}

- (BOOL)isAuthenticatedWithOAuth
{
    return (self.authorizationCredential.accessToken != nil);
}

- (void)signOut
{
    self.currentUser = nil;
    self.modhash = nil;
    self.sessionIdentifier = nil;
    self.authorizationCredential = nil;
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [storage cookies];
    
    for (NSHTTPCookie *cookie in cookies)
    {
        if ([[cookie name] isEqualToString:@"reddit_session"])
        {
            [storage deleteCookie:cookie];
            break;
        }
    }
}

#pragma mark - Properties

- (void)setModhash:(NSString *)modhash
{
    _modhash = [modhash copy];
    [[self requestSerializer] setValue:_modhash forHTTPHeaderField:@"X-Modhash"];
}

- (void)setSessionIdentifier:(NSString *)sessionIdentifier {
    
    _sessionIdentifier = [sessionIdentifier copy];
    
    NSString *cookieValue = _sessionIdentifier ? [NSString stringWithFormat:@"reddit_session=%@", [_sessionIdentifier stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] : nil;
    [[self requestSerializer] setValue:cookieValue forHTTPHeaderField:@"Cookie"];
}

- (void)setUserAgent:(NSString *)userAgent
{
    _userAgent = [userAgent copy];
    [[self requestSerializer] setValue:_userAgent forHTTPHeaderField:@"User-Agent"];
}

- (void)setAuthorizationCredential:(RKOAuthCredential *)authorizationCredential
{
    _authorizationCredential = authorizationCredential;

    [[self requestSerializer] setValue:nil forHTTPHeaderField:@"Cookie"];
    [[self requestSerializer] setAuthorizationHeaderFieldWithUsername:authorizationCredential.clientIdentifier password:@""];

    if (authorizationCredential.accessToken.accessToken) {
        NSLog(@"Setting authorization code: %@ and refresh token: %@", authorizationCredential.accessToken.accessToken, authorizationCredential.accessToken.refreshToken);

        NSString *value = [[NSString alloc] initWithFormat:@"bearer %@", authorizationCredential.accessToken.accessToken];
        [[self requestSerializer] setValue:value forHTTPHeaderField:@"Authorization"];
    }
}

@end