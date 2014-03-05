// RKUser.m
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

#import "RKUser.h"

@implementation RKUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
        @"username": @"data.name",
        @"commentKarma": @"data.comment_karma",
        @"linkKarma": @"data.link_karma",
        @"hasMail": @"data.has_mail",
        @"hasModeratorMail": @"data.has_mod_mail",
        @"hasVerifiedEmailAddress": @"data.has_verified_email",
        @"gold": @"data.is_gold",
        @"friend": @"data.is_friend",
        @"mod": @"data.is_mod",
        @"over18": @"data.over_18"
    };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:keyPaths];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, username: %@, comment karma: %ld, link karma: %ld>", NSStringFromClass([self class]), self, self.username, (long)self.commentKarma, (long)self.linkKarma];
}

#pragma mark - MTLModel

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    NSSet *keys = [NSSet setWithObjects:@"hasMail", @"hasModeratorMail", @"hasVerifiedEmailAddress", nil];
    if ([keys containsObject:key])
    {
        return [MTLValueTransformer transformerWithBlock:^id(id boolean) {
            return (!boolean || boolean == [NSNull null]) ? @(NO) : boolean;
        }];
    }
    
    return nil;
}

@end
