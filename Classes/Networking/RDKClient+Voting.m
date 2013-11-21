// RDKClient+Voting.m
//
// Copyright (c) 2013 Sam Symons (http://samsymons.com/)
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

#import "RDKClient+Voting.h"
#import "RDKClient+Errors.h"
#import "RDKClient+Requests.h"

#import "RDKVotable.h"

NSString * NSStringFromVoteDirection(RDKVoteDirection voteDirection)
{
    switch (voteDirection)
    {
        case RDKVoteDirectionUpvote:
            return @"1";
            break;
        case RDKVoteDirectionDownvote:
            return @"-1";
            break;
        case RDKVoteDirectionNone:
            return @"0";
            break;
        default:
            return @"0";
            break;
    }
}

@implementation RDKClient (Voting)

- (NSURLSessionDataTask *)upvote:(RDKVotable *)object completion:(RDKCompletionBlock)completion
{
    return [self voteOnThingWithFullName:object.fullName direction:RDKVoteDirectionUpvote completion:completion];
}

- (NSURLSessionDataTask *)downvote:(RDKVotable *)object completion:(RDKCompletionBlock)completion
{
    return [self voteOnThingWithFullName:object.fullName direction:RDKVoteDirectionDownvote completion:completion];
}

- (NSURLSessionDataTask *)revokeVote:(RDKVotable *)object completion:(RDKCompletionBlock)completion
{
    return [self voteOnThingWithFullName:object.fullName direction:RDKVoteDirectionNone completion:completion];
}

- (NSURLSessionDataTask *)voteOnThingWithFullName:(NSString *)fullName direction:(RDKVoteDirection)direction completion:(RDKCompletionBlock)completion;
{
    NSParameterAssert(fullName);
    NSParameterAssert(direction);
    
    NSDictionary *parameters = @{@"id": fullName, @"dir": NSStringFromVoteDirection(direction)};
    
    return [self basicPostTaskWithPath:@"api/vote" parameters:parameters completion:completion];
}

@end
