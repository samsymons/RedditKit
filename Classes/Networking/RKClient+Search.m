// RKClient+Search.m
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

#import "RKClient+Search.h"
#import "RKPagination.h"
#import "RKSubreddit.h"
#import "RKLink.h"

@implementation RKClient (Search)

- (NSURLSessionDataTask *)search:(NSString *)query pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self search:query subreddit:nil restrictSubreddit:NO pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)search:(NSString *)query subreddit:(RKSubreddit *)subreddit restrictSubreddit:(BOOL)restrictSubreddit pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{	
    return [self search:query subredditName:subreddit.name restrictSubreddit:restrictSubreddit pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)search:(NSString *)query subredditName:(NSString *)subredditName restrictSubreddit:(BOOL)restrictSubreddit pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    NSParameterAssert(query);
    
    NSString *path = subredditName ? [NSString stringWithFormat:@"r/%@/search.json", subredditName] : @"search.json";
    NSString *restrictString = [self stringFromBoolean:restrictSubreddit];
    NSDictionary *parameters = @{@"q": query, @"restrict_sr": restrictString };
    
    return [self listingTaskWithPath:path parameters:parameters pagination:pagination completion:completion];
}

@end
