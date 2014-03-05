// RKClient+Miscellaneous.h
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

@class RKLink, RKComment;

@interface RKClient (Miscellaneous)

#pragma mark - Editing

/**
 Edits a self post created by the current user.
 
 @param link The link to edit.
 @param text The text to be set as the self post's body. This will replace the old text.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)editSelfPost:(RKLink *)link newText:(NSString *)text completion:(RKCompletionBlock)completion;

/**
 Edits a comment created by the current user.
 
 @param comment The comment to edit.
 @param text The text to be set as the comment's body. This will replace the old text.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)editComment:(RKComment *)comment newText:(NSString *)text completion:(RKCompletionBlock)completion;

/**
 Edits a self post or a comment created by the current user.
 
 @param fullName The full name of the self post or comment.
 @param text The text to be set as the body. This will replace the old text.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)editSelfPostOrCommentWithFullName:(NSString *)fullName newText:(NSString *)text completion:(RKCompletionBlock)completion;

#pragma mark - Saving

/**
 Saves a link.
 
 @param link The link to save.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)saveLink:(RKLink *)link completion:(RKCompletionBlock)completion;

/**
 Saves a comment.
 
 @param comment The comment to save.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)saveComment:(RKComment *)comment completion:(RKCompletionBlock)completion;

/**
 Saves a link or comment.
 
 @param fullName The full name of the link or comment to save.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)saveLinkOrCommentWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion;

/**
 Unsaves a link.
 
 @param link The link to unsave.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unsaveLink:(RKLink *)link completion:(RKCompletionBlock)completion;

/**
 Unsaves a comment.
 
 @param comment The comment to unsave.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unsaveComment:(RKComment *)comment completion:(RKCompletionBlock)completion;

/**
 Unsaves a link or comment.
 
 @param fullName The full name of the link or comment to unsave.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unsaveLinkOrCommentWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion;

#pragma mark - Reporting

/**
 Reports a link.
 
 @param link The link to report.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)reportLink:(RKLink *)link completion:(RKCompletionBlock)completion;

/**
 Reports a comment.
 
 @param comment The comment to report.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)reportComment:(RKComment *)comment completion:(RKCompletionBlock)completion;

/**
 Reports a link or comment.
 
 @param fullName The full name of the link or comment to report.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)reportLinkOrCommentWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion;

#pragma mark - Deleting

/**
 Deletes a link.
 
 @param link The link to delete.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)deleteLink:(RKLink *)link completion:(RKCompletionBlock)completion;

/**
 Deletes a comment.
 
 @param comment The comment to delete.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)deleteComment:(RKComment *)comment completion:(RKCompletionBlock)completion;

/**
 Deletes a link or comment.
 
 @param fullName The full name of the link or comment to delete.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)deleteLinkOrCommentWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion;

@end
