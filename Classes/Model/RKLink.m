// RKLink.m
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

#import "RKLink.h"
#import "NSString+HTML.h"
#import "RKLinkEmbeddedMedia.h"

@implementation RKLink

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
        @"title": @"data.title",
        @"URL": @"data.url",
        @"permalink": @"data.permalink",
        @"domain": @"data.domain",
        @"author": @"data.author",
        @"media": @"data.media",
        @"totalComments": @"data.num_comments",
        @"totalReports": @"data.num_reports",
        @"subreddit": @"data.subreddit",
        @"subredditFullName": @"data.subreddit_id",
        @"approvedBy": @"data.approved_by",
        @"bannedBy": @"data.banned_by",
        @"distinguished": @"data.distinguished",
        @"selfPost": @"data.is_self",
        @"selfText": @"data.selftext",
        @"selfTextHTML": @"data.selftext_html",
        @"visited": @"data.visited",
        @"stickied": @"data.stickied",
        @"saved": @"data.saved",
        @"hidden": @"data.hidden",
        @"NSFW": @"data.over_18",
        @"edited": @"data.edited",
        @"upvoteRatio": @"data.upvote_ratio",
        @"gilded": @"data.gilded",
        @"thumbnailURL": @"data.thumbnail",
        @"authorFlairClass": @"data.author_flair_css_class",
        @"authorFlairText": @"data.author_flair_text",
        @"linkFlairClass": @"data.link_flair_css_class",
        @"linkFlairText": @"data.link_flair_text",
    };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:keyPaths];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, full name: %@, score: %ld, URL: %@, author: %@>", NSStringFromClass([self class]), self, self.fullName, (long)self.score, [[self URL] absoluteString], self.author];
}

- (BOOL)isImageLink
{
    NSSet *supportedFileTypeSuffixes = [NSSet setWithObjects:@"tiff", @"tif", @"jpg", @"jpeg", @"gif", @"png", nil];
    NSString *extension = [[self URL] pathExtension];
    
    return [supportedFileTypeSuffixes containsObject:extension];
}

- (NSURL *)shortURL
{
    NSURL *baseURL = [NSURL URLWithString:@"http://redd.it/"];
    return [baseURL URLByAppendingPathComponent:self.identifier];
}

#pragma mark - MTLModel

+ (NSValueTransformer *)totalReportsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id totalReports) {
        if (!totalReports || totalReports == [NSNull null])
        {
            return @(0);
        }
        else
        {
            return totalReports;
        }
    }];
}

+ (NSValueTransformer *)titleJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSString *title) {
        NSString *unescapedTitle = [title stringByUnescapingHTMLEntities];
		return unescapedTitle;
    }];
}

+ (NSValueTransformer *)URLJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSString *URL) {
        NSString *unescapedURL = [[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByUnescapingHTMLEntities];
        return [NSURL URLWithString:unescapedURL];
    }];
}

+ (NSValueTransformer *)permalinkJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSString *permalink) {
        NSString *unescapedPermalink = [[permalink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByUnescapingHTMLEntities];
        NSString *fullPermalink = [NSString stringWithFormat:@"http://reddit.com%@", unescapedPermalink];
        
        return [NSURL URLWithString:fullPermalink];
    }];
}

+ (NSValueTransformer *)thumbnailURLJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSString *thumbnailURL) {
        if ([thumbnailURL isEqualToString:@"self"])
        {
            return nil;
        }
        else
        {
            return [NSURL URLWithString:thumbnailURL];
        }
    }];
}

+ (NSValueTransformer *)editedJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *created) {
        if (![created boolValue])
        {
            return nil;
        }
        else
        {
            NSTimeInterval createdTimeInterval = [created unsignedIntegerValue];
            return [NSDate dateWithTimeIntervalSince1970:createdTimeInterval];
        }
    }];
}

+ (NSValueTransformer *)mediaJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *media) {
        NSError *error = nil;
        RKLinkEmbeddedMedia *mediaObject = [MTLJSONAdapter modelOfClass:[RKLinkEmbeddedMedia class] fromJSONDictionary:media error:&error];
        
        if (error) {
            return nil;
        }
        else {
            return mediaObject;
        }
    }];
}

@end
