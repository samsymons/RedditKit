// RKClient+Links.m
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

#import "RKClient+Links.h"
#import "RKClient+Requests.h"
#import "RKLink.h"
#import "RKSubreddit.h"
#import "RKPagination.h"

NSString * NSStringFromSubredditCategory(RKSubredditCategory category)
{
    switch (category)
    {
        case RKSubredditCategoryHot:
            return @"hot";
            break;
        case RKSubredditCategoryNew:
            return @"new";
            break;
        case RKSubredditCategoryRising:
            return @"rising";
            break;
        case RKSubredditCategoryControversial:
            return @"controversial";
            break;
        case RKSubredditCategoryTop:
            return @"top";
            break;
        default:
            return @"hot";
            break;
	}
}

@implementation RKClient (Links)

#pragma mark - Getting Links

- (NSURLSessionDataTask *)frontPageLinksWithPagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self frontPageLinksWithCategory:RKSubredditCategoryHot pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)frontPageLinksWithCategory:(RKSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"%@.json", NSStringFromSubredditCategory(category)];
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)linksInAllSubredditsWithPagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self linksInAllSubredditsWithCategory:RKSubredditCategoryHot pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)linksInAllSubredditsWithCategory:(RKSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"r/all/%@.json", NSStringFromSubredditCategory(category)];
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)linksInModeratedSubredditsWithPagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self linksInModeratedSubredditsWithCategory:RKSubredditCategoryHot pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)linksInModeratedSubredditsWithCategory:(RKSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"r/mod/%@.json", NSStringFromSubredditCategory(category)];
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)linksInSubreddit:(RKSubreddit *)subreddit pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self linksInSubreddit:subreddit category:RKSubredditCategoryHot pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)linksInSubreddit:(RKSubreddit *)subreddit category:(RKSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self linksInSubredditWithName:subreddit.name category:category pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)linksInSubredditWithName:(NSString *)subredditName pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self linksInSubredditWithName:subredditName category:RKSubredditCategoryHot pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)linksInSubredditWithName:(NSString *)subredditName category:(RKSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/%@.json", subredditName, NSStringFromSubredditCategory(category)];
    
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)linkWithFullName:(NSString *)fullName completion:(RKObjectCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self listingTaskWithPath:@"api/info.json" parameters:parameters pagination:nil completion:^(NSArray *links, RKPagination *pagination, NSError *error) {
        if (!error)
        {
            completion([links firstObject], nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

#pragma mark - Submitting

- (NSURLSessionDataTask *)submitLinkPostWithTitle:(NSString *)title subreddit:(RKSubreddit *)subreddit URL:(NSURL *)URL captchaIdentifier:(NSString *)captchaIdentifier captchaValue:(NSString *)captchaValue completion:(RKObjectCompletionBlock)completion
{
    return [self submitLinkPostWithTitle:title subredditName:subreddit.title URL:URL captchaIdentifier:captchaIdentifier captchaValue:captchaValue completion:completion];
}

- (NSURLSessionDataTask *)submitLinkPostWithTitle:(NSString *)title subredditName:(NSString *)subredditName URL:(NSURL *)URL captchaIdentifier:(NSString *)captchaIdentifier captchaValue:(NSString *)captchaValue completion:(RKObjectCompletionBlock)completion
{
    NSParameterAssert(title);
    NSParameterAssert(subredditName);
    NSParameterAssert(URL);
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:7];
    
    [parameters setObject:title forKey:@"title"];
    [parameters setObject:subredditName forKey:@"sr"];
    [parameters setObject:[URL absoluteString] forKey:@"url"];
    
    if (captchaIdentifier) [parameters setObject:captchaIdentifier forKey:@"iden"];
    if (captchaValue) [parameters setObject:captchaValue forKey:@"captcha"];
    
    [parameters setObject:@"link" forKey:@"kind"];
    
    return [self basicPostAndResponseTaskWithPath:@"api/submit" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)submitSelfPostWithTitle:(NSString *)title subreddit:(RKSubreddit *)subreddit text:(NSString *)text captchaIdentifier:(NSString *)captchaIdentifier captchaValue:(NSString *)captchaValue completion:(RKObjectCompletionBlock)completion
{
    return [self submitSelfPostWithTitle:title subredditName:subreddit.title text:text captchaIdentifier:captchaIdentifier captchaValue:captchaValue completion:completion];
}

- (NSURLSessionDataTask *)submitSelfPostWithTitle:(NSString *)title subredditName:(NSString *)subredditName text:(NSString *)text captchaIdentifier:(NSString *)captchaIdentifier captchaValue:(NSString *)captchaValue completion:(RKObjectCompletionBlock)completion
{
    NSParameterAssert(title);
    NSParameterAssert(subredditName);
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:7];
    
    [parameters setObject:title forKey:@"title"];
    [parameters setObject:subredditName forKey:@"sr"];
    
    if (text) [parameters setObject:text forKey:@"text"];
    if (captchaIdentifier) [parameters setObject:captchaIdentifier forKey:@"iden"];
    if (captchaValue) [parameters setObject:captchaValue forKey:@"captcha"];
    
    [parameters setObject:@"self" forKey:@"kind"];
    
    return [self basicPostAndResponseTaskWithPath:@"api/submit" parameters:parameters completion:completion];
}

#pragma mark - Marking NSFW

- (NSURLSessionDataTask *)markNSFW:(RKLink *)link completion:(RKCompletionBlock)completion
{
    return [self markNSFWWithFullName:link.fullName completion:completion];
}

- (NSURLSessionDataTask *)markNSFWWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    return [self basicPostTaskWithPath:@"api/marknsfw" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)unmarkNSFW:(RKLink *)link completion:(RKCompletionBlock)completion
{
    return [self unmarkNSFWWithFullName:[link fullName] completion:completion];
}

- (NSURLSessionDataTask *)unmarkNSFWWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    return [self basicPostTaskWithPath:@"api/unmarknsfw" parameters:parameters completion:completion];
}

#pragma mark - Hiding

- (NSURLSessionDataTask *)hideLink:(RKLink *)link completion:(RKCompletionBlock)completion
{
    return [self hideLinkWithFullName:[link fullName] completion:completion];
}

- (NSURLSessionDataTask *)hideLinkWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    return [self basicPostTaskWithPath:@"api/hide" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)unhideLink:(RKLink *)link completion:(RKCompletionBlock)completion
{
    return [self unhideLinkWithFullName:[link fullName] completion:completion];
}

- (NSURLSessionDataTask *)unhideLinkWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    return [self basicPostTaskWithPath:@"api/unhide" parameters:parameters completion:completion];
}

@end
