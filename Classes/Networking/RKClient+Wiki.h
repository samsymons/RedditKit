// RKClient+Wiki.h
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

@class RKSubreddit, RKUser;

@interface RKClient (Wiki)

/**
 Add an editor to a specific page in a wiki.
 
 @param editor The user to add as an editor.
 @param pageName The name of the page to which the editor should be added.
 @param subreddit The subreddit containing the wiki.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)addEditor:(RKUser *)editor toWikiPage:(NSString *)pageName inSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion;

/**
 Add an editor to a specific page in a wiki.
 
 @param username The username of the user to add as an editor.
 @param pageName The name of the page to which the editor should be added.
 @param subredditName The name of the subreddit containing the wiki.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)addEditorWithUsername:(NSString *)username toWikiPage:(NSString *)pageName inSubredditWithName:(NSString *)subredditName completion:(RKCompletionBlock)completion;

/**
 Remove an editor from a specific page in a wiki.
 
 @param editor The user to remove from being an editor.
 @param pageName The name of the page to which the editor should be removed.
 @param subreddit The subreddit containing the wiki.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeEditor:(RKUser *)editor fromWikiPage:(NSString *)pageName inSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion;

/**
 Remove an editor from a specific page in a wiki.
 
 @param username The username of the user to remove from being an editor.
 @param pageName The name of the page to which the editor should be removed.
 @param subredditName The name of the subreddit containing the wiki.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeEditorWithUsername:(NSString *)username fromWikiPage:(NSString *)pageName inSubredditWithName:(NSString *)subredditName completion:(RKCompletionBlock)completion;

/**
 Edit a page in a wiki.
 
 @param pageName The name of the page to edit.
 @param subreddit The subreddit containing the wiki.
 @param content The new content of the page, formatted as Markdown.
 @param reason An optional reason for editing the page.
 @param revisionIdentifier An option revision identifier for which to base this edit on.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)editWikiPage:(NSString *)pageName subreddit:(RKSubreddit *)subreddit content:(NSString *)content editReason:(NSString *)reason previousRevisionIdentifier:(NSString *)revisionIdentifier completion:(RKCompletionBlock)completion;

/**
 Edit a page in a wiki.
 
 @param pageName The name of the page to edit.
 @param subredditName The name of the subreddit containing the wiki.
 @param content The new content of the page, formatted as Markdown.
 @param reason An optional reason for editing the page.
 @param revisionIdentifier An option revision identifier for which to base this edit on.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)editWikiPage:(NSString *)pageName subredditName:(NSString *)subredditName content:(NSString *)content editReason:(NSString *)reason previousRevisionIdentifier:(NSString *)revisionIdentifier completion:(RKCompletionBlock)completion;

/**
 Hides a revision of a wiki page.
 
 @param revisionIdentifier The identifier of the revision.
 @param pageName The name of the page containing the revision.
 @param subreddit The subreddit containing the wiki.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)hideWikiRevision:(NSString *)revisionIdentifier page:(NSString *)pageName subreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion;

/**
 Hides a revision of a wiki page.
 
 @param revisionIdentifier The identifier of the revision.
 @param pageName The name of the page containing the revision.
 @param subredditName The name of the subreddit containing the wiki.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)hideWikiRevision:(NSString *)revisionIdentifier page:(NSString *)pageName subredditName:(NSString *)subredditName completion:(RKCompletionBlock)completion;

/**
 Reverts a page in a wiki back to a specific revision.
 
 @param revisionIdentifier The identifier of the revision.
 @param pageName The name of the page containing the revision.
 @param subreddit The subreddit containing the wiki.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)revertToRevision:(NSString *)revisionIdentifier page:(NSString *)pageName subreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion;

/**
 Reverts a page in a wiki back to a specific revision.
 
 @param revisionIdentifier The identifier of the revision.
 @param pageName The name of the page containing the revision.
 @param subredditName The name of the subreddit containing the wiki.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)revertToRevision:(NSString *)revisionIdentifier page:(NSString *)pageName subredditName:(NSString *)subredditName completion:(RKCompletionBlock)completion;

@end
