// RKClient.m
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

#import "RKClient.h"
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
    if (self.isSignedIn)
    {
        return [NSString stringWithFormat:@"<%@: %p, username: %@>", NSStringFromClass([self class]), self, self.currentUser.username];
    }
    else
    {
        return [NSString stringWithFormat:@"<%@: %p, not signed in>", NSStringFromClass([self class]), self];
    }
}

#pragma mark - Class Methods

+ (NSURL *)APIBaseURL
{
    return [NSURL URLWithString:@"http://www.reddit.com/"];
}

+ (NSURL *)APIBaseHTTPSURL
{
    return [NSURL URLWithString:@"https://ssl.reddit.com/"];
}

+ (NSString *)meURLPath
{
    return @"api/me.json";
}

#pragma mark - Authentication

- (NSURLSessionDataTask *)signInWithUsername:(NSString *)username password:(NSString *)password completion:(RKCompletionBlock)completion;
{
    NSParameterAssert(username);
    NSParameterAssert(password);
    
	NSDictionary *parameters = @{@"user": username, @"passwd": password, @"api_type": @"json"};
    
    NSURL *baseURL = [[self class] APIBaseURL];
    NSString *URLString = [[NSURL URLWithString:@"api/login" relativeToURL:baseURL] absoluteString];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters];
    
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
            
            [weakSelf setModhash:modhash];
            
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

- (BOOL)isSignedIn
{
	return self.modhash != nil;
}

- (void)signOut
{
	self.currentUser = nil;
	self.modhash = nil;
    
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

- (void)setModhash:(NSString *)modhash
{
    _modhash = [modhash copy];
    [[self requestSerializer] setValue:_modhash forHTTPHeaderField:@"X-Modhash"];
}

- (void)setUserAgent:(NSString *)userAgent
{
    _userAgent = [userAgent copy];
    [[self requestSerializer] setValue:_userAgent forHTTPHeaderField:@"User-Agent"];
}

@end