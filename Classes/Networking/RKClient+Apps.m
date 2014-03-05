// RKClient+Apps.m
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

#import "RKClient+Apps.h"
#import "RKClient+Requests.h"
#import "RKUser.h"

@implementation RKClient (Apps)

- (NSURLSessionDataTask *)createAppWithName:(NSString *)name description:(NSString *)description aboutURL:(NSString *)aboutURL redirectURL:(NSString *)redirectURL completion:(RKCompletionBlock)completion
{
    return [self createOrUpdateAppWithIdentifier:nil name:name description:description aboutURL:aboutURL redirectURL:redirectURL completion:completion];
}

- (NSURLSessionDataTask *)updateAppWithIdentifier:(NSString *)identifier name:(NSString *)name description:(NSString *)description aboutURL:(NSString *)aboutURL redirectURL:(NSString *)redirectURL completion:(RKCompletionBlock)completion
{
    NSParameterAssert(identifier);
    
    return [self createOrUpdateAppWithIdentifier:identifier name:name description:description aboutURL:aboutURL redirectURL:redirectURL completion:completion];
}

- (NSURLSessionDataTask *)deleteAppWithIdentifier:(NSString *)identifier completion:(RKCompletionBlock)completion
{
    NSParameterAssert(identifier);
    
    NSDictionary *parameters = @{@"client_id": identifier};
    return [self basicPostTaskWithPath:@"api/deleteapp" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)revokeAppWithIdentifier:(NSString *)identifier completion:(RKCompletionBlock)completion
{
    NSParameterAssert(identifier);
    
    NSDictionary *parameters = @{@"client_id": identifier};
    return [self basicPostTaskWithPath:@"api/revokeapp" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)addDeveloper:(RKUser *)developer toAppWithIdentifier:(NSString *)identifier completion:(RKCompletionBlock)completion
{
    return [self addDeveloperWithUsername:developer.username toAppWithIdentifier:identifier completion:completion];
}

- (NSURLSessionDataTask *)addDeveloperWithUsername:(NSString *)username toAppWithIdentifier:(NSString *)identifier completion:(RKCompletionBlock)completion
{
    NSParameterAssert(username);
    NSParameterAssert(identifier);
    
    NSDictionary *parameters = @{@"name": username, @"client_id": identifier};
    return [self basicPostTaskWithPath:@"api/adddeveloper" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)removeDeveloper:(RKUser *)developer fromAppWithIdentifier:(NSString *)identifier completion:(RKCompletionBlock)completion
{
    return [self removeDeveloperWithUsername:developer.username fromAppWithIdentifier:identifier completion:completion];
}

- (NSURLSessionDataTask *)removeDeveloperWithUsername:(NSString *)username fromAppWithIdentifier:(NSString *)identifier completion:(RKCompletionBlock)completion
{
    NSParameterAssert(username);
    NSParameterAssert(identifier);
    
    NSDictionary *parameters = @{@"name": username, @"client_id": identifier};
    return [self basicPostTaskWithPath:@"api/removedeveloper" parameters:parameters completion:completion];
}

#pragma mark - Private

- (NSURLSessionDataTask *)createOrUpdateAppWithIdentifier:(NSString *)identifier name:(NSString *)name description:(NSString *)description aboutURL:(NSString *)aboutURL redirectURL:(NSString *)redirectURL completion:(RKCompletionBlock)completion
{
    NSParameterAssert(name);
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:4];
    [parameters setObject:name forKey:@"name"];
    
    if (identifier) [parameters setObject:description forKey:@"client_id"];
    if (description) [parameters setObject:description forKey:@"description"];
    if (aboutURL) [parameters setObject:aboutURL forKey:@"about_uri"];
    if (redirectURL) [parameters setObject:redirectURL forKey:@"redirect_url"];
    
    return [self basicPostTaskWithPath:@"api/updateapp" parameters:parameters completion:completion];
}

@end
