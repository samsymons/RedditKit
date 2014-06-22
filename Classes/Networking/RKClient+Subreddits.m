// RKClient+Subreddits.m
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

#import "RKClient+Subreddits.h"

#import "RKLink.h"
#import "RKPagination.h"
#import "RKObjectBuilder.h"
#import "RKSubreddit.h"

#import "RKClient+Errors.h"
#import "RKClient+Requests.h"

@implementation RKClient (Subreddits)

#pragma mark - Getting Subreddits

- (NSURLSessionDataTask *)subredditWithName:(NSString *)subredditName completion:(RKObjectCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/about.json", subredditName];
    
    return [self getPath:path parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion) return;
        
        if (responseObject)
        {
            if (![[responseObject objectForKey:@"kind"] isEqualToString:kRKObjectTypeSubreddit]) {
                completion(nil, [RKClient invalidSubredditError]);
                return;
            }
            
            NSError *mantleError = nil;
            RKSubreddit *subreddit = [MTLJSONAdapter modelOfClass:[RKSubreddit class] fromJSONDictionary:responseObject error:&mantleError];
            
            completion(subreddit, mantleError);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)popularSubredditsWithPagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self listingTaskWithPath:@"subreddits/popular.json" parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)newSubredditsWithPagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self listingTaskWithPath:@"subreddits/new.json" parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)searchForSubredditsByName:(NSString *)name pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    NSDictionary *parameters = @{@"q": name};
    
    return [self listingTaskWithPath:@"subreddits/search.json" parameters:parameters pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)subredditsByTopic:(NSString *)topic completion:(RKArrayCompletionBlock)completion
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

- (NSURLSessionDataTask *)recommendedSubredditsForSubreddits:(NSArray *)subreddits completion:(RKArrayCompletionBlock)completion
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

- (NSURLSessionDataTask *)subscribeToSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self subscribeToSubredditWithFullName:[subreddit fullName] completion:completion];
}

- (NSURLSessionDataTask *)subscribeToSubredditWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{ @"action": @"sub", @"sr": fullName, @"uh": self.modhash };
    return [self basicPostTaskWithPath:@"api/subscribe" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)unsubscribeFromSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self unsubscribeFromSubredditWithFullName:[subreddit fullName] completion:completion];
}

- (NSURLSessionDataTask *)unsubscribeFromSubredditWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{ @"action": @"unsub", @"sr": fullName, @"uh": self.modhash };
    return [self basicPostTaskWithPath:@"api/subscribe" parameters:parameters completion:completion];
}

@end
