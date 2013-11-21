// RDKClient+Subreddits.m
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

#import "RDKClient+Subreddits.h"
#import "RDKClient+Requests.h"
#import "RDKSubreddit.h"
#import "RDKPagination.h"
#import "RDKLink.h"

@implementation RDKClient (Subreddits)

#pragma mark - Getting Subreddits

- (NSURLSessionDataTask *)subredditWithName:(NSString *)subredditName completion:(RDKObjectCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/about.json", subredditName];
    
    return [self getPath:path parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion) return;
        
        if (responseObject)
        {
            NSError *mantleError = nil;
            RDKSubreddit *subreddit = [MTLJSONAdapter modelOfClass:[RDKSubreddit class] fromJSONDictionary:responseObject error:&mantleError];
            
            completion(subreddit, mantleError);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)popularSubredditsWithPagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self listingTaskWithPath:@"subreddits/popular.json" parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)newSubredditsWithPagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self listingTaskWithPath:@"subreddits/new.json" parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)searchForSubredditsByName:(NSString *)name pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    NSDictionary *parameters = @{@"q": name};
    
    return [self listingTaskWithPath:@"subreddits/search.json" parameters:parameters pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)subredditsByTopic:(NSString *)topic completion:(RDKArrayCompletionBlock)completion
{
    NSParameterAssert(topic);
    
    NSDictionary *parameters = @{@"query": topic};
    
    return [self getPath:@"api/subreddits_by_topic.json" parameters:parameters completion:^(NSHTTPURLResponse *response, NSArray *responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (responseObject)
        {
            NSArray *subreddits = [responseObject valueForKeyPath:@"name"];
            completion(subreddits, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)recommendedSubredditsForSubreddits:(NSArray *)subreddits completion:(RDKArrayCompletionBlock)completion
{
    NSParameterAssert(subreddits);
    
    NSString *names = [subreddits componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"srnames": names};
    
    return [self getPath:@"api/subreddit_recommendations.json" parameters:parameters completion:^(NSHTTPURLResponse *response, NSArray *responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (responseObject)
        {
            NSArray *subreddits = [responseObject valueForKeyPath:@"sr_name"];
            completion(subreddits, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

#pragma mark - Subscribing

- (NSURLSessionDataTask *)subscribeToSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self subscribeToSubredditWithFullName:[subreddit fullName] completion:completion];
}

- (NSURLSessionDataTask *)subscribeToSubredditWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{ @"action": @"sub", @"sr": fullName, @"uh": self.modhash };
    return [self basicPostTaskWithPath:@"api/subscribe" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)unsubscribeFromSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self unsubscribeFromSubredditWithFullName:[subreddit fullName] completion:completion];
}

- (NSURLSessionDataTask *)unsubscribeFromSubredditWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{ @"action": @"unsub", @"sr": fullName, @"uh": self.modhash };
    return [self basicPostTaskWithPath:@"api/subscribe" parameters:parameters completion:completion];
}

@end
