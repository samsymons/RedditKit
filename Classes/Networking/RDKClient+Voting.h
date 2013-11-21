// RDKClient+Voting.h
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

#import "RDKClient.h"

typedef NS_ENUM(NSInteger, RDKVoteDirection) {
	RDKVoteDirectionUpvote = 1,
	RDKVoteDirectionDownvote = 2,
	RDKVoteDirectionNone = 3
};

@class RDKVotable;

@interface RDKClient (Voting)

/**
 Upvotes a link or comment.
 
 @param object The object to upvote.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)upvote:(RDKVotable *)object completion:(RDKCompletionBlock)completion;

/**
 Downvotes a link or comment.
 
 @param object The object to downvote.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)downvote:(RDKVotable *)object completion:(RDKCompletionBlock)completion;

/**
 Revokes any upvote or downvote on a link or comment.
 
 @param object The object for which the vote should be revoked.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)revokeVote:(RDKVotable *)object completion:(RDKCompletionBlock)completion;

/**
 Votes on a thing with a given full name.
 
 @param fullName The full name of the thing to vote on.
 @param direction The direction of which to vote.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)voteOnThingWithFullName:(NSString *)fullName direction:(RDKVoteDirection)direction completion:(RDKCompletionBlock)completion;

@end
