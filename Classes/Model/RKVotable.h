// RKVotable.h
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

#import "RKCreated.h"

typedef NS_ENUM(NSUInteger, RKVoteStatus) {
	RKVoteStatusUpvoted,
	RKVoteStatusDownvoted,
	RKVoteStatusNone
};

@interface RKVotable : RKCreated

/**
 The total number of upvotes.
 */
@property (nonatomic, assign, readonly) NSUInteger upvotes;

/**
 The total number of downvotes.
 */
@property (nonatomic, assign, readonly) NSUInteger downvotes;

/**
 The object's score.
 */
@property (nonatomic, assign, readonly) NSInteger score;

/**
 The current user's vote status for this object.
 */
@property (nonatomic, assign, readonly) RKVoteStatus voteStatus;

/**
 Whether the current user has upvoted this object.
 */
- (BOOL)upvoted;

/**
 Whether the current user has downvoted this object.
 */
- (BOOL)downvoted;

/**
 Whether the current user has voted on this object.
 */
- (BOOL)voted;

@end
