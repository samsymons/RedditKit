// RKVotable.m
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

#import "RKVotable.h"

@interface RKVotable ()

@property (nonatomic, assign) NSInteger score;

@end

@implementation RKVotable

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
        @"upvotes": @"data.ups",
        @"downvotes": @"data.downs",
        @"voteStatus": @"data.likes"
    };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:keyPaths];
}

- (NSInteger)score
{
    return (self.upvotes - self.downvotes);
}

- (BOOL)upvoted
{
    return (self.voteStatus == RKVoteStatusUpvoted);
}

- (BOOL)downvoted
{
    return (self.voteStatus == RKVoteStatusDownvoted);
}

- (BOOL)voted
{
    return (self.voteStatus != RKVoteStatusNone);
}

#pragma mark - MTLModel

+ (NSValueTransformer *)voteStatusJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(id vote) {
        if (!vote || vote == [NSNull null])
        {
            return @(RKVoteStatusNone);
        }
        else
        {   
            BOOL likes = [vote boolValue];
            return likes ? @(RKVoteStatusUpvoted) : @(RKVoteStatusDownvoted);
        }
    }];
}

@end
