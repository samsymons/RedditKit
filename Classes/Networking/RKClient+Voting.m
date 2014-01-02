// RKClient+Voting.m
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

#import "RKClient+Voting.h"
#import "RKClient+Errors.h"
#import "RKClient+Requests.h"

#import "RKVotable.h"

NSString * NSStringFromVoteDirection(RKVoteDirection voteDirection)
{
    switch (voteDirection)
    {
        case RKVoteDirectionUpvote:
            return @"1";
            break;
        case RKVoteDirectionDownvote:
            return @"-1";
            break;
        case RKVoteDirectionNone:
            return @"0";
            break;
        default:
            return @"0";
            break;
    }
}

@implementation RKClient (Voting)

- (NSURLSessionDataTask *)upvote:(RKVotable *)object completion:(RKCompletionBlock)completion
{
    return [self voteOnThingWithFullName:object.fullName direction:RKVoteDirectionUpvote completion:completion];
}

- (NSURLSessionDataTask *)downvote:(RKVotable *)object completion:(RKCompletionBlock)completion
{
    return [self voteOnThingWithFullName:object.fullName direction:RKVoteDirectionDownvote completion:completion];
}

- (NSURLSessionDataTask *)revokeVote:(RKVotable *)object completion:(RKCompletionBlock)completion
{
    return [self voteOnThingWithFullName:object.fullName direction:RKVoteDirectionNone completion:completion];
}

- (NSURLSessionDataTask *)voteOnThingWithFullName:(NSString *)fullName direction:(RKVoteDirection)direction completion:(RKCompletionBlock)completion;
{
    NSParameterAssert(fullName);
    NSParameterAssert(direction);
    
    NSDictionary *parameters = @{@"id": fullName, @"dir": NSStringFromVoteDirection(direction)};
    
    return [self basicPostTaskWithPath:@"api/vote" parameters:parameters completion:completion];
}

@end
