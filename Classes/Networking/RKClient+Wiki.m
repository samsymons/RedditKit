// RKClient+Wiki.m
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

#import "RKClient+Wiki.h"
#import "RKClient+Requests.h"
#import "RKUser.h"
#import "RKSubreddit.h"

@implementation RKClient (Wiki)

- (NSURLSessionDataTask *)addEditor:(RKUser *)editor toWikiPage:(NSString *)pageName inSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self addEditorWithUsername:editor.username toWikiPage:pageName inSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)addEditorWithUsername:(NSString *)username toWikiPage:(NSString *)pageName inSubredditWithName:(NSString *)subredditName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(username);
    NSParameterAssert(pageName);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"page": pageName, @"username": username};
    NSString *path = [NSString stringWithFormat:@"r/%@/api/wiki/alloweditor/add", subredditName];
    
    return [self basicPostTaskWithPath:path parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)removeEditor:(RKUser *)editor fromWikiPage:(NSString *)pageName inSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self removeEditorWithUsername:editor.username fromWikiPage:pageName inSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)removeEditorWithUsername:(NSString *)username fromWikiPage:(NSString *)pageName inSubredditWithName:(NSString *)subredditName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(username);
    NSParameterAssert(pageName);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"page": pageName, @"username": username};
    NSString *path = [NSString stringWithFormat:@"r/%@/api/wiki/alloweditor/del", subredditName];
    
    return [self basicPostTaskWithPath:path parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)editWikiPage:(NSString *)pageName subreddit:(RKSubreddit *)subreddit content:(NSString *)content editReason:(NSString *)reason previousRevisionIdentifier:(NSString *)revisionIdentifier completion:(RKCompletionBlock)completion
{
    return [self editWikiPage:pageName subredditName:subreddit.name content:content editReason:reason previousRevisionIdentifier:revisionIdentifier completion:completion];
}

- (NSURLSessionDataTask *)editWikiPage:(NSString *)pageName subredditName:(NSString *)subredditName content:(NSString *)content editReason:(NSString *)reason previousRevisionIdentifier:(NSString *)revisionIdentifier completion:(RKCompletionBlock)completion
{
    NSParameterAssert(pageName);
    NSParameterAssert(subredditName);
    NSParameterAssert(content);
    
    NSDictionary *parameters = @{@"page": pageName, @"content": content, @"reason": reason, @"previous": revisionIdentifier};
    NSString *path = [NSString stringWithFormat:@"r/%@/api/wiki/edit", subredditName];
    
    return [self basicPostTaskWithPath:path parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)hideWikiRevision:(NSString *)revisionIdentifier page:(NSString *)pageName subreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self hideWikiRevision:revisionIdentifier page:pageName subredditName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)hideWikiRevision:(NSString *)revisionIdentifier page:(NSString *)pageName subredditName:(NSString *)subredditName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(revisionIdentifier);
    NSParameterAssert(pageName);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"page": pageName, @"revision": revisionIdentifier};
    NSString *path = [NSString stringWithFormat:@"r/%@/api/wiki/hide", subredditName];
    
    return [self basicPostTaskWithPath:path parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)revertToRevision:(NSString *)revisionIdentifier page:(NSString *)pageName subreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self revertToRevision:revisionIdentifier page:pageName subredditName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)revertToRevision:(NSString *)revisionIdentifier page:(NSString *)pageName subredditName:(NSString *)subredditName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(revisionIdentifier);
    NSParameterAssert(pageName);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"page": pageName, @"revision": revisionIdentifier};
    NSString *path = [NSString stringWithFormat:@"r/%@/api/wiki/revert", subredditName];
    
    return [self basicPostTaskWithPath:path parameters:parameters completion:completion];
}

@end
