// RDKClient+Subreddits.h
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

#import "RDKClient.h"
#import "RDKCompletionBlocks.h"
#import "RDKPagination.h"

@class AFJSONRequestOperation;
@class RDKSubreddit;

@interface RDKClient (Subreddits)

#pragma mark - Getting Subreddits

/**
 Gets a subreddit with a given name.
 
 @param subredditName The name of the subreddit to get.
 @param completion An optional block to be executed on the completion of a request. Its object parameter is an RDKSubreddit object.
 */
- (NSURLSessionDataTask *)subredditWithName:(NSString *)subredditName completion:(RDKObjectCompletionBlock)completion;

/**
 Gets a list of the most popular subreddits.
 
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed on the completion of a request. Its collection parameter contains RDKSubreddit objects.
 */
- (NSURLSessionDataTask *)popularSubredditsWithPagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets a list of the newest subreddits.
 
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed on the completion of a request. Its collection parameter contains RDKSubreddit objects.
 */
- (NSURLSessionDataTask *)newSubredditsWithPagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Searches for subreddits with a given name.
 
 @param name The name to search for.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed on the completion of a request. Its collection parameter contains RDKSubreddit objects.
 */
- (NSURLSessionDataTask *)searchForSubredditsByName:(NSString *)name pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets a list of subreddits with a certain topic.
 
 @param topic The topic to search for.
 @param completion An optional block to be executed on the completion of a request. Its collection parameter contains NSString objects representing subreddit names.
 */
- (NSURLSessionDataTask *)subredditsByTopic:(NSString *)topic completion:(RDKArrayCompletionBlock)completion;

/**
 Gets a list of recommended subreddits from an array of subreddit names.
 
 @param subreddits An array of NSStrings, each representing the name of a subreddit.
 @param completion An optional block to be executed on the completion of a request. Its collection parameter contains NSString objects representing subreddit names.
 */
- (NSURLSessionDataTask *)recommendedSubredditsForSubreddits:(NSArray *)subreddits completion:(RDKArrayCompletionBlock)completion;

#pragma mark - Subscribing

/**
 Subscribes the current user to a subreddit.
 
 @param subreddit The subreddit to subscribe to.
 @param completion An optional block to be executed on the completion of a request.
 */
- (NSURLSessionDataTask *)subscribeToSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Subscribes the current user to a subreddit.
 
 @param fullName The full name of the subreddit to subscribe to.
 @param completion An optional block to be executed on the completion of a request.
 */
- (NSURLSessionDataTask *)subscribeToSubredditWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

/**
 Unsubscribes the current user from a subreddit.
 
 @param subreddit The subreddit from which to unsubscribe.
 @param completion An optional block to be executed on the completion of a request.
 */
- (NSURLSessionDataTask *)unsubscribeFromSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Unsubscribes the current user from a subreddit.
 
 @param fullName The full name of the subreddit from which to unsubscribe.
 @param completion An optional block to be executed on the completion of a request.
 */
- (NSURLSessionDataTask *)unsubscribeFromSubredditWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

@end
