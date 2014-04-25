// RKClient+Multireddits.h
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
#import "RKMultireddit.h"

@class RKSubreddit, RKUser;

@interface RKClient (Multireddits)

#pragma mark - Getting Multireddit Information

/**
 Fetches the current user's multireddits.
 
 @param completion An optional block to be executed on the completion of a request.
 */
- (NSURLSessionDataTask *)multiredditsWithCompletion:(RKArrayCompletionBlock)completion;

/**
 Gets a multireddit with a given name.
 
 @param multiredditName The name of the multireddit to fetch.
 @param user The user who owns the multireddit.
 @param completion An optional block to be executed on the completion of a request.
 */
- (NSURLSessionDataTask *)multiredditWithName:(NSString *)multiredditName user:(RKUser *)user completion:(RKObjectCompletionBlock)completion;

/**
 Gets a multireddit with a given name.
 
 @param multiredditName The name of the multireddit to fetch.
 @param username The username of the user who owns the multireddit.
 @param completion An optional block to be executed on the completion of a request.
 */
- (NSURLSessionDataTask *)multiredditWithName:(NSString *)multiredditName userWithUsername:(NSString *)username completion:(RKObjectCompletionBlock)completion;

/**
 Gets a multireddit with a given path
 
 @param multiredditPath The path of the multireddit to fetch. (format: /user/username/m/multireddit_name)
 @param completion An optional block to be executed on the completion of a request.
 */
- (NSURLSessionDataTask *)multiredditWithPath:(NSString *)multiredditPath completion:(RKObjectCompletionBlock)completion;

/**
 Gets the description of a multireddit.
 
 @param multireddit The multireddit.
 @param completion An optional block to be executed on the completion of a request.
 @note Requires authentication.
 */
- (NSURLSessionDataTask *)descriptionForMultireddit:(RKMultireddit *)multireddit completion:(RKObjectCompletionBlock)completion;

/**
 Gets the description of a multireddit.
 
 @param multiredditName The name of the multireddit.
 @param username The username of the user who owns the multireddit.
 @param completion An optional block to be executed on the completion of a request.
 @note Requires authentication.
 */
- (NSURLSessionDataTask *)descriptionForMultiredditWithName:(NSString *)multiredditName userWithUsername:(NSString *)username completion:(RKObjectCompletionBlock)completion;

/**
 Sets the description for a multireddit owned by the current user.
 
 @param description The new description for the multireddit, formatted in Markdown.
 @param multireddit The multireddit.
 @param completion An optional block to be executed on the completion of a request.
 */
- (NSURLSessionDataTask *)setDescription:(NSString *)description forMultireddit:(RKMultireddit *)multireddit completion:(RKObjectCompletionBlock)completion;

/**
 Sets the description for a multireddit owned by the current user.
 
 @param description The new description for the multireddit, formatted in Markdown.
 @param multiredditName The name of the multireddit.
 @param completion An optional block to be executed on the completion of a request.
 */
- (NSURLSessionDataTask *)setDescription:(NSString *)description forMultiredditWithName:(NSString *)multiredditName completion:(RKObjectCompletionBlock)completion;

#pragma mark - Creating, Modifying & Deleting Multireddits

/**
 Creates a multireddit.
 
 @param name The name of the multireddit. Note: reddit automatically lowercases a multireddit's name.
 @param subreddits An array of NSStrings, each representing a subreddit's name.
 @param visibility The subreddit's visibility to others.
 @param completion An optional block to be executed on the completion of a request.
 */
- (NSURLSessionDataTask *)createMultiredditWithName:(NSString *)name subreddits:(NSArray *)subreddits visibility:(RKMultiredditVisibility)visibility completion:(RKObjectCompletionBlock)completion;

/**
 Updates a multireddit owned by the current user.
 
 @param name The name of the multireddit to update.
 @param subreddits An array of NSStrings, each representing a subreddit's name, overriding the old subreddit list.
 @param visibility The subreddit's visibility to others.
 @param completion An optional block to be executed on the completion of a request.
 */
- (NSURLSessionDataTask *)updateMultiredditWithName:(NSString *)name subreddits:(NSArray *)subreddits visibility:(RKMultiredditVisibility)visibility completion:(RKObjectCompletionBlock)completion;

/**
 Renames an existing multireddit owned by the current user.
 
 @param multireddit The multireddit to rename.
 @param newMultiredditName The new name for the multireddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)renameMultireddit:(RKMultireddit *)multireddit to:(NSString *)newMultiredditName completion:(RKCompletionBlock)completion;

/**
 Renames an existing multireddit owned by the current user.
 
 @param multiredditName The name of the multireddit to rename.
 @param newMultiredditName The new name for the multireddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)renameMultiredditWithName:(NSString *)multiredditName to:(NSString *)newMultiredditName completion:(RKCompletionBlock)completion;

/**
 Copies a multireddit from another reddit user.
 
 @param multireddit The multireddit to copy.
 @param user The user who owns the multireddit.
 @param name The name for the copied multireddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)copyMultireddit:(RKMultireddit *)multireddit fromUser:(RKUser *)user newName:(NSString *)name completion:(RKCompletionBlock)completion;

/**
 Copies a multireddit from another reddit user.
 
 @param multiredditName The name of the multireddit to copy.
 @param username The username of the user who owns the multireddit.
 @param name The name for the copied multireddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)copyMultiredditWithName:(NSString *)multiredditName fromUserWithUsername:(NSString *)username newName:(NSString *)name completion:(RKCompletionBlock)completion;

/**
 Deletes a multireddit owned by the current user.
 
 @param multireddit The multireddit to delete.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)deleteMultireddit:(RKMultireddit *)multireddit completion:(RKCompletionBlock)completion;

/**
 Deletes a multireddit owned by the current user.
 
 @param multiredditName The name of the multireddit to delete.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)deleteMultiredditWithName:(NSString *)multiredditName completion:(RKCompletionBlock)completion;

#pragma mark - Managing Multireddit Subreddits

/**
 Adds a subreddit to an existing multireddit owned by the current user.
 
 @param subreddit The subreddit to add to the multireddit.
 @param multireddit The multireddit to which to add the subreddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)addSubreddit:(RKSubreddit *)subreddit toMultireddit:(RKMultireddit *)multireddit completion:(RKCompletionBlock)completion;

/**
 Adds a subreddit to an existing multireddit owned by the current user.
 
 @param subredditName The name of the subreddit to add to the multireddit.
 @param multiredditName The name of the multireddit to which to add the subreddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)addSubredditWithName:(NSString *)subredditName toMultiredditWithName:(NSString *)multiredditName completion:(RKCompletionBlock)completion;

/**
 Removes a subreddit from an existing multireddit owned by the current user.
 
 @param subreddit The subreddit to remove from the multireddit.
 @param multireddit The multireddit from which to remove the subreddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeSubreddit:(RKSubreddit *)subreddit fromMultireddit:(RKMultireddit *)multireddit completion:(RKCompletionBlock)completion;

/**
 Removes a subreddit from an existing multireddit owned by the current user.
 
 @param subredditName The name of the subreddit to remove from the multireddit.
 @param multiredditName The name of the multireddit from which to remove the subreddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeSubredditWithName:(NSString *)subredditName fromMultiredditWithName:(NSString *)multiredditName completion:(RKCompletionBlock)completion;

@end
