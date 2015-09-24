// RKComment.h
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

typedef NS_ENUM(NSUInteger, RKDistinguishedStatus) {
	RKDistinguishedStatusYes,
	RKDistinguishedStatusNo,
	RKDistinguishedStatusAdmin,
	RKDistinguishedStatusSpecial
};

@interface RKComment : RKVotable

/**
 The username of the moderator who approved this comment.
 */
@property (nonatomic, copy, readonly) NSString *approvedBy;

/**
 The username of the comment's author.
 */
@property (nonatomic, copy, readonly) NSString *author;

/**
 The username of the user who posted the comment's parent link.
 
 @note This property will only be set for comments retrieved outside of their parent submission. Read more here: http://redd.it/1rgf6j
 */
@property (nonatomic, copy, readonly) NSString *linkAuthor;

/**
 The username of the moderator who banned this comment.
 */
@property (nonatomic, copy, readonly) NSString *bannedBy;

/**
 The body text of the comment, as Markdown.
 */
@property (nonatomic, copy, readonly) NSString *body;

/**
 The body text of the comment, as HTML.
 */
@property (nonatomic, copy, readonly) NSString *bodyHTML;

/**
 The date this comment was edited, or nil if it has never been edited.
 */
@property (nonatomic, strong, readonly) NSDate *edited;

/**
 The number of times the comment has been gilded.
 */
@property (nonatomic, assign, readonly) NSUInteger gilded;

/**
 Whether the comment has been archived.
 */
@property (nonatomic, assign, readonly, getter=isArchived) BOOL archived;

/**
 Whether the comment has been saved by the current user.
 */
@property (nonatomic, assign, readonly, getter=isSaved) BOOL saved;

/**
 The identifier of the link to which this comment was posted.
 */
@property (nonatomic, copy, readonly) NSString *linkID;

/**
 The title of the link to which this comment was posted.
 */
@property (nonatomic, copy, readonly) NSString *linkTitle;

/**
 The number of times this comment has been reported.
 */
@property (nonatomic, assign) NSUInteger totalReports;

/**
 The identifier of the comment's parent, if it has one. (It will only have one if the comment is a reply.)
 */
@property (nonatomic, copy, readonly) NSString *parentID;

/**
 The score of the comment.
 */
@property (nonatomic, assign, readonly) NSInteger score;

/**
 Whether the score of this comment is currently hidden.
 Some subreddits hide the scores of new comments for a short period of time, to prevent voting from being skewed via the bandwagon effect.
 */
@property (nonatomic, assign, readonly) BOOL scoreHidden;

/**
 The controversiality of the comment.
 This is currently an integer which is either 1 or 0, but may be expanded in the future.
 */
@property (nonatomic, assign, readonly) NSUInteger controversiality;

/**
 The name of the subreddit to which this comment was posted.
 */
@property (nonatomic, copy, readonly) NSString *subreddit;

/**
 The identifier of the subreddit to which this comment was posted.
 */
@property (nonatomic, copy, readonly) NSString *subredditID;

/**
 The comment's distinguished status.
 */
@property (nonatomic, assign, readonly) RKDistinguishedStatus distinguishedStatus;

/**
 Any replies to the comment. This array contains other RKComment objects.
 */
@property (nonatomic, strong, readonly) NSArray *replies;

/**
 Whether this comment has been removed by either its author or a moderator/admin.
 
 @return YES if both the author and body properties are set to "[deleted]".
 */
- (BOOL)isDeleted;

/**
 Note: This data is only sent back from reddit's API as a response to submitting a new comment.
 
 The body text of the comment, as Markdown.
 */
@property (nonatomic, copy, readonly) NSString *submissionContentText;

/**
 Note: This data is only sent back from reddit's API as a response to submitting a new comment.
 
 The body text of the comment, as HTML.
 */
@property (nonatomic, copy, readonly) NSString *submissionContentHTML;

/**
 Note: This data is only sent back from reddit's API as a response to submitting a new comment.
 
 The identifier of the link to which this comment was posted.
 */
@property (nonatomic, copy, readonly) NSString *submissionLink;

/**
 Note: This data is only sent back from reddit's API as a response to submitting a new comment.
 
 The identifier of the comment's parent. It can be the link if it's a top-level comment. Otherwise
 the parent can be a comment, if it's a reply.
 */
@property (nonatomic, copy, readonly) NSString *submissionParent;

/**
 The CSS class value for the author of the link.
 */
@property (nonatomic, copy, readonly) NSString *authorFlairClass;

/**
 The flair text value for the author of the link.
 */
@property (nonatomic, copy, readonly) NSString *authorFlairText;

@end
