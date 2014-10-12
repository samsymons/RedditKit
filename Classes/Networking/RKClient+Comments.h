// RKClient+Comments.h
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

typedef NS_ENUM(NSUInteger, RKCommentSort) {
        RKCommentSortTop = 1,
        RKCommentSortHot,
        RKCommentSortNew,
        RKCommentSortControversial,
        RKCommentSortOld,
        RKCommentSortBest
};

extern NSString * RKStringFromCommentSort(RKCommentSort sort);

@class RKLink, RKComment, RKMoreComments, RKMessage;

@interface RKClient (Comments)

#pragma mark - Submitting Comments

/**
 Submit a comment on a link.
 
 @param commentText The body of the comment, as Markdown.
 @param link The link on which to comment.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)submitComment:(NSString *)commentText onLink:(RKLink *)link completion:(RKCompletionBlock)completion;

/**
 Submit a comment as a reply to another comment.
 
 @param commentText The body of the comment, as Markdown.
 @param comment The comment.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)submitComment:(NSString *)commentText asReplyToComment:(RKComment *)comment completion:(RKCompletionBlock)completion;

/**
 Submit a comment on a link or ocmment.
 
 @param commentText The body of the comment, as Markdown.
 @param fullName The full name of the link or comment.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)submitComment:(NSString *)commentText onThingWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion;

#pragma mark - Getting Comments

/**
 Gets any comments on a link. Defaults to RKCommentSortTop sort order.
 
 @param link The link.
 @param completion An optional block to be executed upon request completion. It takes two arguments: an array of RKComments and any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)commentsForLink:(RKLink *)link completion:(RKArrayCompletionBlock)completion;

/**
 Gets any comments on a link. Defaults to RKCommentSortTop sort order.
 
 @param linkIdentifier The identifier of the link.
 @param completion An optional block to be executed upon request completion. It takes two arguments: an array of RKComments and any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)commentsForLinkWithIdentifier:(NSString *)linkIdentifier completion:(RKArrayCompletionBlock)completion;

/**
 Gets any comments on a link with specified sort and limit.
 
 @param linkIdentifier The identifier of the link.
 @param sort The sort option from which to fetch comments.
 @param limit Maximum number of comments to be retrieved in a single request.
 @param completion An optional block to be executed upon request completion. It takes two arguments: an array of RKComments and any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)commentsForLinkWithIdentifier:(NSString *)linkIdentifier sort:(RKCommentSort)sort limit:(NSInteger)limit completion:(RKArrayCompletionBlock)completion;


/**
 Gets "more" comments on a link with specified sort and limit.
 
 @param moreComments RKMoreComments object containing an array of children comments referenced by identifer (e.g. ce40nud).
 @param link The link.
 @param sort The sort option from which to fetch comments.
 @param completion An optional block to be executed upon request completion. It takes two arguments: an array of RKComments and any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)moreComments:(RKMoreComments *)moreComments forLink:(RKLink *)link sort:(RKCommentSort)sort completion:(RKArrayCompletionBlock)completion;

@end
