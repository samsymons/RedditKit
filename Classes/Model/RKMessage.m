// RKMessage.m
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

#import "RKMessage.h"
#import "RKObjectBuilder.h"
#import "RKClient.h"
#import "RKUser.h"

@implementation RKMessage

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary
{
    if ([[JSONDictionary valueForKeyPath:@"data.was_comment"] boolValue])
    {
        return [RKCommentReplyMessage class];
    }
    else
    {
        return [RKMessage class];
    }
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
        @"unread": @"data.new",
        @"author": @"data.author",
        @"messageBody": @"data.body",
        @"recipient": @"data.dest",
        @"subject": @"data.subject",
        @"type": @"data.author",
        @"commentReply": @"data.was_comment",
        @"firstMessage": @"data.first_message",
        @"firstMessageFullName": @"data.first_message_name",
        @"replies": @"data.replies"
    };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:keyPaths];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, full name: %@, author: %@, recipient: %@>", NSStringFromClass([self class]), self, self.fullName, self.author, self.recipient];
}

#pragma mark - MTLModel

+ (NSValueTransformer *)typeJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSString *author) {
        NSString *currentUsername = [[[RKClient sharedClient] currentUser] username];
        
        if ([author isEqualToString:currentUsername])
        {
            return @(RKMessageTypeSent);
        }
        else
        {
            return @(RKMessageTypeReceived);
        }
    }];
}

+ (NSValueTransformer *)likesJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id boolean) {
        return (!boolean || boolean == [NSNull null]) ? @(NO) : boolean;
    }];
}

+ (NSValueTransformer *)repliesJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id replies) {
        if ([replies isKindOfClass:[NSString class]] || replies == [NSNull null])
        {
            return @[];
        }
        
        NSArray *repliesData = [replies valueForKeyPath:@"data.children"];
        NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:repliesData.count];
        
        for (NSDictionary *commentJSON in repliesData)
        {
            NSString *kind = commentJSON[@"kind"];
            if (![kind isEqualToString:kRKObjectTypeMessage])
            {
                continue;
            }
            
            NSError *error = nil;
            id model = [MTLJSONAdapter modelOfClass:[RKMessage class] fromJSONDictionary:commentJSON error:&error];
            
            if (!error)
            {
                [comments addObject:model];
            }
            else
            {
                NSLog(@"Failed to build message reply: %@", error);
            }
        }
        
        return [comments copy];
    }];
}

@end

#pragma mark -

@implementation RKCommentReplyMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
        @"linkTitle": @"data.link_title",
        @"likes": @"data.likes",
        @"context": @"data.context",
        @"subreddit": @"data.subreddit"
    };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:keyPaths];
}

@end
