// RKMultireddit.m
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

#import "RKMultireddit.h"

@interface RKMultireddit ()

@property (nonatomic, copy) NSString *ownerUsername;

@end

@implementation RKMultireddit

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
        @"name": @"data.name",
        @"path": @"data.path",
        @"editable": @"data.can_edit",
        @"subreddits": @"data.subreddits",
        @"visibility": @"data.visibility",
        @"created": @"data.created_utc"
    };
    
    return keyPaths;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, name: %@, path: %@>", NSStringFromClass([self class]), self, self.name, self.path];
}

- (NSString *)username
{
    if (self.ownerUsername)
    {
        return self.ownerUsername;
    }
    
    static NSRegularExpression *usernameRegularExpression = nil;
    if (!usernameRegularExpression)
    {
        NSString *regex = @"/user/(.*)/m/";
        usernameRegularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:kNilOptions error:NULL];
    }
    
    NSTextCheckingResult *firstMatch = [usernameRegularExpression firstMatchInString:self.path options:kNilOptions range:NSMakeRange(0, [[self path] length])];
    
    if (firstMatch)
    {
        self.ownerUsername = [[self path] substringWithRange:[firstMatch rangeAtIndex:1]];
        return self.ownerUsername;
    }
    
    return nil;
}

#pragma mark - MTLModel

+ (NSValueTransformer *)subredditsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSArray *subreddits) {
        return [subreddits valueForKeyPath:@"name"];
    }];
}

+ (NSValueTransformer *)visibilityJSONTransformer
{
    NSDictionary *visibilityTypes = @{
        @"public": @(RKMultiredditVisibilityPublic),
        @"private": @(RKMultiredditVisibilityPrivate)
    };
    
    return [MTLValueTransformer transformerWithBlock:^(NSString *visibility) {
        return visibilityTypes[visibility];
    }];
}

+ (NSValueTransformer *)createdJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSNumber *created) {
        NSTimeInterval createdTimeInterval = [created unsignedIntegerValue];
        return [NSDate dateWithTimeIntervalSince1970:createdTimeInterval];
    }];
}

@end
