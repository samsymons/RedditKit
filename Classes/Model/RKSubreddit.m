// RKSubreddit.m
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

#import "RKSubreddit.h"

@implementation RKSubreddit

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
        @"accountsActive": @"data.accounts_active",
        @"name": @"data.display_name",
        @"subredditDescription": @"data.description",
        @"publicDescription": @"data.public_description",
        @"subredditDescriptionHTML": @"data.description_html",
        @"title": @"data.title",
        @"headerImageURL": @"data.header_img",
        @"headerTitle": @"data.header_title",
        @"headerImageSize": @"data.header_size",
        @"over18": @"data.over18",
        @"banned": @"data.user_is_banned",
        @"contributor": @"data.user_is_contributor",
        @"moderator": @"data.user_is_moderator",
        @"subscriber": @"data.user_is_subscriber",
        @"URL": @"data.url",
        @"totalSubscribers": @"data.subscribers",
        @"acceptedSubmissionsType": @"data.submission_type",
        @"subredditType": @"data.subreddit_type",
        @"commentSpamFilterStrength": @"data.spam_comments",
        @"linkSpamFilterStrength": @"data.spam_links",
        @"selfPostSpamFilterStrength": @"data.spam_selfposts",
        @"submitLinkPostLabel": @"data.submit_link_label",
        @"submitTextPostLabel": @"data.submit_text_label",
        @"trafficPagePubliclyAccessible": @"data.public_traffic",
        @"submitText": @"data.submit_text",
        @"submitTextHTML": @"data.submit_text_html",
        @"totalSubscribers": @"data.subscribers"
    };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:keyPaths];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, full name: %@, name: %@>", NSStringFromClass([self class]), self, self.fullName, self.name];
}

#pragma mark - MTLModel

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    NSSet *keys = [NSSet setWithObjects:@"banned", @"contributor", @"moderator", @"subscriber", nil];
    if ([keys containsObject:key])
    {
        return [MTLValueTransformer transformerWithBlock:^id(id boolean) {
            return (!boolean || boolean == [NSNull null]) ? @(NO) : boolean;
        }];
    }
    
    return nil;
}

+ (NSValueTransformer *)accountsActiveJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id accountsActive) {
        if (!accountsActive || accountsActive == [NSNull null])
        {
            return @(0);
        }
        else
        {
            return accountsActive;
        }
    }];
}

+ (NSValueTransformer *)headerImageURLJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSString *headerImageURL) {
        if (!headerImageURL || [headerImageURL isEqual:[NSNull null]])
        {
            return nil;
        }
        else
        {
            return [NSURL URLWithString:headerImageURL];
        }
    }];
}

+ (NSValueTransformer *)headerImageSizeJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSArray *size) {
        CGFloat width = [[size objectAtIndex:0] floatValue];
        CGFloat height = [[size objectAtIndex:1] floatValue];
        
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        return [NSValue valueWithCGSize:CGSizeMake(width, height)];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
        return [NSValue valueWithSize:CGSizeMake(width, height)];
#endif
    }];
}

+ (NSValueTransformer *)acceptedSubmissionsTypeJSONTransformer
{
    NSDictionary *types = @{
        @"any": @(RKSubmissionTypeAny),
        @"link": @(RKSubmissionTypeLink),
        @"self": @(RKSubmissionTypeSelf)
    };
    
    return [MTLValueTransformer transformerWithBlock:^(NSString *type) {
        return types[type];
    }];
}

+ (NSValueTransformer *)subredditTypeJSONTransformer
{
    NSDictionary *types = @{
        @"public": @(RKSubredditTypePublic),
        @"private": @(RKSubredditTypePrivate),
        @"restricted": @(RKSubredditTypeRestricted),
        @"gold_restricted": @(RKSubredditTypeGoldRestricted),
        @"archived": @(RKSubredditTypeArchived)
    };
    
    return [MTLValueTransformer transformerWithBlock:^(NSString *type) {
        return types[type];
    }];
}

+ (NSValueTransformer *)commentSpamFilterStrengthJSONTransformer
{
    return [RKSubreddit spamFilterValueTransformer];
}

+ (NSValueTransformer *)linkSpamFilterStrengthJSONTransformer
{
    return [RKSubreddit spamFilterValueTransformer];
}

+ (NSValueTransformer *)selfPostSpamFilterStrengthJSONTransformer
{
    return [RKSubreddit spamFilterValueTransformer];
}

+ (NSValueTransformer *)spamFilterValueTransformer
{
    NSDictionary *strengths = @{
        @"low": @(RKSpamFilterStrengthLow),
        @"high": @(RKSpamFilterStrengthHigh),
        @"all": @(RKSpamFilterStrengthAll)
    };
    
    return [MTLValueTransformer transformerWithBlock:^id(id strength) {
        if (!strength)
        {
            return @(RKSpamFilterStrengthNoStrength);
        }
        else
        {
            return strengths[strength];
        }
    }];
}

@end
