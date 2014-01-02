// RKClient+Search.h
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
#import "RKCompletionBlocks.h"
#import "RKClient+Requests.h"

@class RKSubreddit, RKPagination;

@interface RKClient (Search)

/**
 Gets the result of a reddit search.
 
 @param query The search query.
 @param pagination An optional pagination object.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 @see http://www.reddit.com/wiki/search
 */
- (NSURLSessionDataTask *)search:(NSString *)query pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Gets the result of a reddit search.
 
 @param query The query to search for.
 @param subreddit The optional subreddit to search.
 @param restrictSubreddit Whether to restrict the search to the specified subreddit.
 @param pagination An optional pagination object.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 @see http://www.reddit.com/wiki/search
 */
- (NSURLSessionDataTask *)search:(NSString *)query subreddit:(RKSubreddit *)subreddit restrictSubreddit:(BOOL)restrictSubreddit pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Gets the result of a reddit search.
 
 @param query The query to search for.
 @param subredditName The optional name of the subreddit to search.
 @param restrictSubreddit Whether to restrict the search to the specified subreddit.
 @param pagination An optional pagination object.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 @see http://www.reddit.com/wiki/search
 */
- (NSURLSessionDataTask *)search:(NSString *)query subredditName:(NSString *)subredditName restrictSubreddit:(BOOL)restrictSubreddit pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

@end
