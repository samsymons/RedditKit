// RKClient+Requests.m
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

#import "RKClient+Requests.h"
#import "RKClient+Errors.h"
#import "RKPagination.h"
#import "RKObjectBuilder.h"

@implementation RKClient (Requests)

- (NSURLSessionDataTask *)basicPostTaskWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RKCompletionBlock)completion
{
    NSParameterAssert(path);
    
    if (![self isSignedIn])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion([RKClient authenticationRequiredError]);
            }
        });
        
        return nil;
    }
    
    return [self postPath:path parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion(error);
            }
        });
    }];
}

- (NSURLSessionDataTask *)listingTaskWithPath:(NSString *)path parameters:(NSDictionary *)parameters pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    NSParameterAssert(path);
    
    return [self fullListingWithPath:path parameters:parameters pagination:pagination completion:^(id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (responseObject)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *response = responseObject;
                if ([responseObject isKindOfClass:[NSArray class]])
                {
                    response = [responseObject lastObject];
                }
                
                NSArray *links = [self objectsFromListingResponse:response];
                RKPagination *pagination = [RKPagination paginationFromListingResponse:response];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(links, pagination, nil);
                });
            });
        }
        else
        {
            completion(nil, nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)fullListingWithPath:(NSString *)path parameters:(NSDictionary *)parameters pagination:(RKPagination *)pagination completion:(RKObjectCompletionBlock)completion
{
    NSParameterAssert(path);
    
    NSMutableDictionary *taskParameters = [NSMutableDictionary dictionary];
    [taskParameters addEntriesFromDictionary:parameters];
    [taskParameters addEntriesFromDictionary:[pagination dictionaryValue]];
    
    return [self getPath:path parameters:taskParameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (responseObject)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(responseObject, nil);
            });
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)friendTaskWithContainer:(NSString *)container subredditName:(NSString *)subredditName name:(NSString *)name type:(NSString *)type completion:(RKCompletionBlock)completion
{
    NSParameterAssert(container);
    NSParameterAssert(name);
    NSParameterAssert(type);
    
    NSDictionary *parameters = @{@"container": container, @"name": name, @"type": type};
    
    if (subredditName)
    {
        NSMutableDictionary *mutableParameters = [parameters mutableCopy];
        mutableParameters[@"r"] = subredditName;
        parameters = [mutableParameters copy];
    }
    
    return [self basicPostTaskWithPath:@"api/friend" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)unfriendTaskWithContainer:(NSString *)container subredditName:(NSString *)subredditName name:(NSString *)name type:(NSString *)type completion:(RKCompletionBlock)completion
{
    NSParameterAssert(container);
    NSParameterAssert(name);
    NSParameterAssert(type);
    
    NSDictionary *parameters = @{@"container": container, @"name": name, @"type": type};
    
    if (subredditName)
    {
        NSMutableDictionary *mutableParameters = [parameters mutableCopy];
        mutableParameters[@"r"] = subredditName;
        parameters = [mutableParameters copy];
    }
    
    return [self basicPostTaskWithPath:@"api/unfriend" parameters:parameters completion:completion];
}

#pragma mark - Response Helpers

- (NSArray *)objectsFromListingResponse:(NSDictionary *)listingResponse
{
    NSParameterAssert(listingResponse);
    
    NSString *kind = listingResponse[@"kind"];
    if (![kind isEqualToString:@"Listing"])
    {
        return nil;
    }
    
    NSArray *objectsAsJSON = listingResponse[@"data"][@"children"];
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:[objectsAsJSON count]];
    
    for (NSDictionary *objectJSON in objectsAsJSON)
    {
        id object = [RKObjectBuilder objectFromJSON:objectJSON];
        
        if (object)
        {
            [objects addObject:object];
        }
    }
    
    return [objects copy];
}

#pragma mark - Request Helpers

- (NSURLSessionDataTask *)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RKRequestCompletionBlock)completion
{
    return [self taskWithMethod:@"GET" path:path parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)postPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RKRequestCompletionBlock)completion
{
    return [self taskWithMethod:@"POST" path:path parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)putPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RKRequestCompletionBlock)completion
{
    return [self taskWithMethod:@"PUT" path:path parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)deletePath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RKRequestCompletionBlock)completion
{
    return [self taskWithMethod:@"DELETE" path:path parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)taskWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters completion:(RKRequestCompletionBlock)completion
{
    NSParameterAssert(method);
    NSParameterAssert(path);
    
    NSMutableDictionary *alteredParameters = [parameters mutableCopy];
    [alteredParameters setObject:@"json" forKey:@"api_type"];
    
    NSString *URLString = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
    NSError *serializerError;
    NSURLRequest *request = [[self requestSerializer] requestWithMethod:method URLString:URLString parameters:[alteredParameters copy] error:&serializerError];
    
    if (serializerError) {
        completion(nil, nil, serializerError);
        return nil;
    }
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSDictionary *headers = [((NSHTTPURLResponse *)response) allHeaderFields];
        
        self.rateLimitedRequestsUsed = [[headers objectForKey:@"x-ratelimit-remaining"] intValue];
        self.rateLimitedRequestsRemaining = [[headers objectForKey:@"x-ratelimit-used"] intValue];
        self.timeUntilRateLimitReset = [[headers objectForKey:@"x-ratelimit-reset"] intValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion((NSHTTPURLResponse *)response, responseObject, error);
            }
        });
    }];
    
    [task resume];
    
    return task;
}

@end
