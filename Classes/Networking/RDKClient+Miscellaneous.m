// RDKClient+Miscellaneous.m
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

#import "RDKClient+Miscellaneous.h"
#import "RDKClient+Requests.h"
#import "RDKComment.h"
#import "RDKLink.h"

@implementation RDKClient (Miscellaneous)

#pragma mark - Editing

- (NSURLSessionDataTask *)editSelfPost:(RDKLink *)link newText:(NSString *)text completion:(RDKCompletionBlock)completion
{
    return [self editSelfPostOrCommentWithFullName:[link fullName] newText:text completion:completion];
}

- (NSURLSessionDataTask *)editComment:(RDKComment *)comment newText:(NSString *)text completion:(RDKCompletionBlock)completion
{
    return [self editSelfPostOrCommentWithFullName:[comment fullName] newText:text completion:completion];
}

- (NSURLSessionDataTask *)editSelfPostOrCommentWithFullName:(NSString *)fullName newText:(NSString *)text completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    NSParameterAssert(text);
    
    NSDictionary *parameters = @{ @"text": text, @"thing_id": fullName, @"uh": self.modhash };
    return [self basicPostTaskWithPath:@"api/editusertext" parameters:parameters completion:completion];
}

#pragma mark - Saving

- (NSURLSessionDataTask *)saveLink:(RDKLink *)link completion:(RDKCompletionBlock)completion
{
    return [self saveLinkOrCommentWithFullName:[link fullName] completion:completion];
}

- (NSURLSessionDataTask *)saveComment:(RDKComment *)comment completion:(RDKCompletionBlock)completion
{
    return [self saveLinkOrCommentWithFullName:[comment fullName] completion:completion];
}

- (NSURLSessionDataTask *)saveLinkOrCommentWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    return [self basicPostTaskWithPath:@"api/save" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)unsaveLink:(RDKLink *)link completion:(RDKCompletionBlock)completion
{
    return [self saveLinkOrCommentWithFullName:[link fullName] completion:completion];
}

- (NSURLSessionDataTask *)unsaveComment:(RDKComment *)comment completion:(RDKCompletionBlock)completion
{
    return [self unsaveLinkOrCommentWithFullName:[comment fullName] completion:completion];
}

- (NSURLSessionDataTask *)unsaveLinkOrCommentWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    return [self basicPostTaskWithPath:@"api/unsave" parameters:parameters completion:completion];
}

#pragma mark - Reporting

- (NSURLSessionDataTask *)reportLink:(RDKLink *)link completion:(RDKCompletionBlock)completion
{
    return [self reportLinkOrCommentWithFullName:[link fullName] completion:completion];
}

- (NSURLSessionDataTask *)reportComment:(RDKComment *)comment completion:(RDKCompletionBlock)completion
{
    return [self reportLinkOrCommentWithFullName:[comment fullName] completion:completion];
}

- (NSURLSessionDataTask *)reportLinkOrCommentWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    return [self basicPostTaskWithPath:@"api/report" parameters:parameters completion:completion];
}

#pragma mark - Deleting

- (NSURLSessionDataTask *)deleteLink:(RDKLink *)link completion:(RDKCompletionBlock)completion
{
    return [self deleteLinkOrCommentWithFullName:[link fullName] completion:completion];
}

- (NSURLSessionDataTask *)deleteComment:(RDKComment *)comment completion:(RDKCompletionBlock)completion
{
    return [self deleteLinkOrCommentWithFullName:[comment fullName] completion:completion];
}

- (NSURLSessionDataTask *)deleteLinkOrCommentWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName, @"uh": self.modhash};
    return [self basicPostTaskWithPath:@"api/del" parameters:parameters completion:completion];
}

@end
