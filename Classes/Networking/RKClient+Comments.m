// RKClient+Comments.m
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

#import "RKClient+Comments.h"
#import "RKClient+Requests.h"
#import "RKFullName.h"
#import "RKLink.h"
#import "RKComment.h"
#import "RKMoreComments.h"

#define DEFAULT_COMMENT_LIMIT 200

@implementation RKClient (Comments)

#pragma mark - Submitting Comments

- (NSURLSessionDataTask *)submitComment:(NSString *)commentText onLink:(RKLink *)link completion:(RKCompletionBlock)completion
{
    return [self submitComment:commentText onThingWithFullName:[link fullName] completion:completion];
}

- (NSURLSessionDataTask *)submitComment:(NSString *)commentText asReplyToComment:(RKComment *)comment completion:(RKCompletionBlock)completion
{
    return [self submitComment:commentText onThingWithFullName:[comment fullName] completion:completion];
}

- (NSURLSessionDataTask *)submitComment:(NSString *)commentText onThingWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(commentText);
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"text": commentText, @"thing_id": fullName};
    
    return [self basicPostTaskWithPath:@"api/comment" parameters:parameters completion:completion];
}

#pragma mark - Getting Comments

- (NSURLSessionDataTask *)commentsForLink:(RKLink *)link completion:(RKArrayCompletionBlock)completion
{
    return [self commentsForLinkWithIdentifier:link.identifier sort:RKCommentSortingMethodTop limit:DEFAULT_COMMENT_LIMIT completion:completion];
}

- (NSURLSessionDataTask *)commentsForLinkWithIdentifier:(NSString *)linkIdentifier completion:(RKArrayCompletionBlock)completion
{
    return [self commentsForLinkWithIdentifier:linkIdentifier sort:RKCommentSortingMethodTop limit:DEFAULT_COMMENT_LIMIT completion:completion];
}

- (NSURLSessionDataTask *)context:(NSUInteger)context forComment:(RKComment *)comment completion:(RKArrayCompletionBlock)completion;
{
    RKFullName *fullName = [[RKFullName alloc] initWithFullName:comment.linkID];
    return [self context:context forCommentWithIdentifier:comment.identifier linkIdentifier:[fullName identifier] completion:completion];
}

- (NSURLSessionDataTask *)context:(NSUInteger)context forCommentWithIdentifier:(NSString *)commentIdentifier linkIdentifier:(NSString *)linkIdentifier completion:(RKArrayCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"http://www.reddit.com/comments/%@/_/%@.json", linkIdentifier, commentIdentifier];
    NSDictionary *parameters = @{ @"context": @(context) };
    
    return [self commentsListingTaskWithPath:path parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)commentsForLinkWithIdentifier:(NSString *)linkIdentifier sort:(RKCommentSortingMethod)sort limit:(NSInteger)limit completion:(RKArrayCompletionBlock)completion
{
    NSParameterAssert(linkIdentifier);
    
    NSDictionary *parameters = @{
                                 @"sort": RKStringFromCommentSortingMethod(sort),
                                 @"limit": @(limit),
                                 };
    NSString *path = [NSString stringWithFormat:@"comments/%@.json", linkIdentifier];
    
    return [self listingTaskWithPath:path parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)moreComments:(RKMoreComments *)moreComments forLink:(RKLink *)link sort:(RKCommentSortingMethod)sort completion:(RKArrayCompletionBlock)completion
{
    NSParameterAssert(moreComments);
    NSParameterAssert(link);
    NSParameterAssert(sort);
    
    // Example parameter data:
    //
    // link_id=t3_1t3epj
    // children=ce3zlpt,ce40nud,ce42fe8,ce42h8q,ce438cc
    // depth=
    // id=t1_ce3zlpt
    // pv_hex=
    // r=gifs
    
    NSDictionary *parameters = @{@"link_id": link.fullName,
                                 @"children": [moreComments.children componentsJoinedByString:@","],
                                 @"depth": @"",
                                 @"id": moreComments.fullName,
                                 @"pv_hex": @"",
                                 @"r": link.subreddit
                                 };
    
    return [self postMoreCommentsListingTaskWithPath:@"api/morechildren.json" parameters:parameters completion:completion];
}

@end
