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
#import "RKLink.h"
#import "RKComment.h"

NSString * RKStringFromCommentSort(RKCommentSort sort)
{
    switch (sort)
    {
        case RKCommentSortTop:
            return @"top";
            break;
        case RKCommentSortHot:
            return @"hot";
            break;
        case RKCommentSortNew:
            return @"new";
            break;
        case RKCommentSortControversial:
            return @"controversial";
            break;
        case RKCommentSortOld:
            return @"old";
            break;
        case RKCommentSortBest:
            return @"confidence";
            break;
        default:
            return @"top";
            break;
	}
}

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

- (NSURLSessionDataTask *)commentsForLink:(RKLink *)link completion:(RKListingCompletionBlock)completion
{
    return [self commentsForLinkWithIdentifier:link.identifier sort:RKCommentSortTop completion:completion];
}

- (NSURLSessionDataTask *)commentsForLinkWithIdentifier:(NSString *)linkIdentifier completion:(RKListingCompletionBlock)completion
{
    return [self commentsForLinkWithIdentifier:linkIdentifier sort:RKCommentSortTop completion:completion];
}

- (NSURLSessionDataTask *)commentsForLinkWithIdentifier:(NSString *)linkIdentifier sort:(RKCommentSort)sort completion:(RKListingCompletionBlock)completion
{
    NSParameterAssert(linkIdentifier);
    
    NSDictionary *parameters = @{ @"sort": RKStringFromCommentSort(sort) };
    NSString *path = [NSString stringWithFormat:@"comments/%@.json", linkIdentifier];
    
    return [self listingTaskWithPath:path parameters:parameters pagination:nil completion:completion];
}

@end
