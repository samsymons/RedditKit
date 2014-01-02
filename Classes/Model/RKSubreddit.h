// RKSubreddit.h
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

#import "RKThing.h"

typedef NS_ENUM(NSUInteger, RKSubmissionType) {
    RKSubmissionTypeAny = 1,
    RKSubmissionTypeLink,
    RKSubmissionTypeSelf
};

typedef NS_ENUM(NSUInteger, RKSubredditType) {
    RKSubredditTypePublic = 1,
    RKSubredditTypePrivate,
    RKSubredditTypeRestricted,
    RKSubredditTypeGoldRestricted,
    RKSubredditTypeArchived
};

typedef NS_ENUM(NSUInteger, RKSpamFilterStrength) {
    RKSpamFilterStrengthLow = 1,
    RKSpamFilterStrengthHigh,
    RKSpamFilterStrengthAll,
    RKSpamFilterStrengthNoStrength
};

@interface RKSubreddit : RKThing

/**
 The numbers of accounts active in the last 15 minutes.
 */
@property (nonatomic, assign, readonly) NSUInteger accountsActive;

/**
 The duration for which comment scores are hidden, in minutes.
 */
@property (nonatomic, assign, readonly) NSUInteger commentScoreHiddenDuration;

/**
 The name of the subreddit.
 Example: for the subreddit reddit.com/r/blog, its name would be 'blog'.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 The description of the subreddit.
 */
@property (nonatomic, copy, readonly) NSString *subredditDescription;

/**
 The description of the subreddit as HTML.
 */
@property (nonatomic, copy, readonly) NSString *subredditDescriptionHTML;

/**
 The public description of the subreddit.
 */
@property (nonatomic, copy, readonly) NSString *publicDescription;

/**
 The URL for the subreddit's header image, if it has one.
 */
@property (nonatomic, strong, readonly) NSURL *headerImageURL;

/**
 The size of the subreddit's header image, if it has one.
 */
@property (nonatomic, readonly) CGSize headerImageSize;

/**
 The title for the header image.
 */
@property (nonatomic, copy, readonly) NSString *headerTitle;

/**
 The title of the subreddit.
 Example: for the subreddit reddit.com/r/blog, its title would be 'The official reddit blog'.
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 The URL for the subreddit, excluding the host name.
 Example: for the subreddit reddit.com/r/blog, its URL would be 'r/blog'.
 */
@property (nonatomic, copy, readonly) NSString *URL;

/**
 Whether the subreddit is set as NSFW.
 */
@property (nonatomic, assign, readonly, getter=isOver18) BOOL over18;

/**
 Whether the current user is a contributor to the subreddit.
 */
@property (nonatomic, assign, readonly, getter = isContributor) BOOL contributor;

/**
 Whether the current user is a moderator of the subreddit.
 */
@property (nonatomic, assign, readonly, getter = isModerator) BOOL moderator;

/**
 Whether the current user is a subscriber to the subreddit.
 */
@property (nonatomic, assign, readonly, getter = isSubscriber) BOOL subscriber;

/**
 Whether the current user is banned from the subreddit.
 */
@property (nonatomic, assign, readonly, getter = isBanned) BOOL banned;

/**
 The total number of subscribers to the subreddit.
 */
@property (nonatomic, assign, readonly) NSUInteger totalSubscribers;

/**
 The type of submissions accepted by the subreddit.
 */
@property (nonatomic, assign, readonly) RKSubmissionType acceptedSubmissionsType;

/**
 The type of the subreddit.
 */
@property (nonatomic, assign, readonly) RKSubredditType subredditType;

/**
 The spam filter strength for submitted comments.
 */
@property (nonatomic, assign, readonly) RKSpamFilterStrength commentSpamFilterStrength;

/**
 The spam filter strength for submitted links.
 */
@property (nonatomic, assign, readonly) RKSpamFilterStrength linkSpamFilterStrength;

/**
 The spam filter strength for submitted self posts.
 */
@property (nonatomic, assign, readonly) RKSpamFilterStrength selfPostSpamFilterStrength;

/**
 The label for the submit link post button, if a custom one has been specified.
 */
@property (nonatomic, copy, readonly) NSString *submitLinkPostLabel;

/**
 The label for the submit text post button, if a custom one has been specified.
 */
@property (nonatomic, copy, readonly) NSString *submitTextPostLabel;

/**
 Text that displays as a user is submitting a post.
 */
@property (nonatomic, copy, readonly) NSString *submitText;

/**
 Text that displays as a user is submitting a post, in HTML.
 */
@property (nonatomic, copy, readonly) NSString *submitTextHTML;

/**
 Whether the subreddit's traffic page is publicly accessible.
 */
@property (nonatomic, assign, readonly) BOOL trafficPagePubliclyAccessible;

@end
