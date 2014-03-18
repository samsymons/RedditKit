// RKComment.m
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

#import "RKComment.h"
#import "RKObjectBuilder.h"
#import "RKClient.h"

@implementation RKComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
        @"approvedBy": @"data.approved_by",
        @"bannedBy": @"data.banned_by",
        @"author": @"data.author",
        @"linkAuthor": @"data.link_author",
        @"body": @"data.body",
        @"bodyHTML": @"data.body_html",
        @"scoreHidden": @"data.score_hidden",
        @"replies": @"data.replies",
        @"edited": @"data.edited",
        @"linkID": @"data.link_id"
    };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:keyPaths];
}

- (NSString *)description
{
    if (self.scoreHidden)
    {
        return [NSString stringWithFormat:@"<%@: %p, full name: %@, author: %@, score hidden>", NSStringFromClass([self class]), self, self.fullName, self.author];
    }
    else
    {
        return [NSString stringWithFormat:@"<%@: %p, full name: %@, author: %@, score: %li>", NSStringFromClass([self class]), self, self.fullName, self.author, (long)self.score];
    }
}

- (BOOL)isDeleted
{
    return [[self author] isEqualToString:@"[deleted]"] && [[self body] isEqualToString:@"[deleted]"];
}

#pragma mark - MTLModel

+ (NSValueTransformer *)repliesJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id replies) {
        if ([replies isKindOfClass:[NSString class]])
        {
            return @[];
        }
        
        NSArray *repliesData = [replies valueForKeyPath:@"data.children"];
        NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:repliesData.count];
        
        for (NSDictionary *commentJSON in repliesData)
        {
            NSString *kind = commentJSON[@"kind"];
            if (![kind isEqualToString:kRKObjectTypeComment])
            {
                continue;
            }
            
            NSError *error = nil;
            id model = [MTLJSONAdapter modelOfClass:[RKComment class] fromJSONDictionary:commentJSON error:&error];
            
            if (!error)
            {
                [comments addObject:model];
            }
            else
            {
                NSLog(@"Failed to build comment reply: %@", error);
            }
        }
        
        return [comments copy];
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

@end
