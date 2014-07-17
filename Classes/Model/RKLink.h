// RKLink.h
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

@class RKLinkEmbeddedMedia;

@interface RKLink : RKVotable

/**
 The title of the link.
 
 @note RKLink automatically unescapes HTML entities.
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 The name of the domain of the link.
 If the post is a self post, this will be in the format of "self.subreddit"; otherwise it will be the host name.
 For a self post in reddit.com/r/blog, its domain would be 'self.blog'.
 For a link post from Twitter, its domain would be "twitter.com".
 */
@property (nonatomic, copy, readonly) NSString *domain;

/**
 The URL of the link.
 */
@property (nonatomic, copy, readonly) NSURL *URL;

/**
 The link to the post on reddit.
 */
@property (nonatomic, copy, readonly) NSURL *permalink;

/**
 The username of the user who submitted the link.
 */
@property (nonatomic, copy, readonly) NSString *author;

/**
 The ratio of upvotes to downvotes.
 This is the percentage of how many users like this link.
 
 @note The upvoteRatio is only available to links which have had their information
 expanded via `linkByExpandingInformationForLink:completion:`.
 
 The upvote ratio is not explicitly rounded to any specific precision. When displaying
 the ratio to the screen, you will want to specify this yourself.
 */
@property (nonatomic, assign, readonly) CGFloat upvoteRatio;

/**
 The time of editing, or nil if it has not been edited.
 */
@property (nonatomic, strong, readonly) NSDate *edited;

/**
 The number of times the link has been gilded.
 */
@property (nonatomic, assign, readonly) NSUInteger gilded;

/**
 Whether the link has been distinguished by a moderator or admin.
 This will either be set to 'yes', 'no', 'admin', 'special' or nil.
 More information here: http://www.reddit.com/r/redditdev/comments/19ak1b/api_change_distinguished_is_now_available_in_the/
 */
@property (nonatomic, copy, readonly) NSString *distinguished;

/**
 The username of the user who approved this link.
 */
@property (nonatomic, copy, readonly) NSString *approvedBy;

/**
 The username of the user who banned this link.
 */
@property (nonatomic, copy, readonly) NSString *bannedBy;

/**
 Whether the link has been hidden by the current user.
 */
@property (nonatomic, assign, readonly) BOOL hidden;

/**
 Whether the link has been marked NSFW.
 */
@property (nonatomic, assign, readonly, getter = isNSFW) BOOL NSFW;

/**
 Whether the link has been saved by the current user.
 */
@property (nonatomic, assign, readonly, getter=isSaved) BOOL saved;

/**
 Whether the link is a self post.
 */
@property (nonatomic, assign, readonly, getter=isSelfPost) BOOL selfPost;

/**
 Whether the link has been marked as sticky.
 */
@property (nonatomic, assign, readonly) BOOL stickied;

/**
 Whether the link has been visited by the current user.
 
 @note This property will only be true if the current user has reddit gold.
 */
@property (nonatomic, assign, readonly) BOOL visited;

/**
 The self text of the link. This will be nil if the link is not a self post.
 */
@property (nonatomic, copy, readonly) NSString *selfText;

/**
 The self text of the link as HTML. This will be nil if the link is not a self post.
 */
@property (nonatomic, copy, readonly) NSString *selfTextHTML;

/**
 The name of the subreddit to which the link was posted.
 */
@property (nonatomic, copy, readonly) NSString *subreddit;

/**
 The full name of the subreddit to which the link was posted.
 */
@property (nonatomic, copy, readonly) NSString *subredditFullName;

/**
 The media embedded in this link, if any.
 */
@property (nonatomic, strong, readonly) RKLinkEmbeddedMedia *media;

/**
 The URL of the thumbnail for the link.
 This property will be nil if the post is a self post.
 */
@property (nonatomic, copy, readonly) NSURL *thumbnailURL;

/**
 The number of comments on the link.
 */
@property (nonatomic, assign, readonly) NSUInteger totalComments;

/**
 The number of times the link has been reported.
 */
@property (nonatomic, assign, readonly) NSUInteger totalReports;

/**
 The CSS class value for the author of the link.
 */
@property (nonatomic, copy, readonly) NSString *authorFlairClass;

/**
 The flair text value for the author of the link.
 */
@property (nonatomic, copy, readonly) NSString *authorFlairText;

/**
 The CSS class value for the link.
 */
@property (nonatomic, copy, readonly) NSString *linkFlairClass;

/**
 The flair text value for the link.
 */
@property (nonatomic, copy, readonly) NSString *linkFlairText;

/**
 Whether or not the link has an image URL.
 */
- (BOOL)isImageLink;

/**
 Returns the URL in a shortened format. This uses reddit's URL shortener.
 
 @example http://redd.it/92dd8
 */
- (NSURL *)shortURL;

@end
