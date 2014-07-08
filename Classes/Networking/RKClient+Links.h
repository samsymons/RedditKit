// RKClient+Links.h
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

#import "RKClient.h"
#import "RKCompletionBlocks.h"

typedef NS_ENUM(NSUInteger, RKSubredditCategory) {
	RKSubredditCategoryHot = 1,
	RKSubredditCategoryNew,
	RKSubredditCategoryRising,
	RKSubredditCategoryControversial,
	RKSubredditCategoryTop
};

extern NSString * RKStringFromSubredditCategory(RKSubredditCategory category);

@class RKLink, RKSubreddit, RKMultireddit;

@interface RKClient (Links)

#pragma mark - Getting Links

/**
 Fetches the links from the front page of the current user.
 If no user is currently signed in, the default front page links will be fetched.
 
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)frontPageLinksWithPagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches the links from the front page of the current user.
 If no user is currently signed in, the default front page links will be fetched.
 
 @param category The category from which to fetch links. Defaults to RKSubredditCategoryHot.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)frontPageLinksWithCategory:(RKSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches links aggregated from all the subreddits on reddit.
 
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linksInAllSubredditsWithPagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches links aggregated from all the subreddits on reddit.
 
 @param category The category from which to fetch links. Defaults to RKSubredditCategoryHot.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linksInAllSubredditsWithCategory:(RKSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches links from subreddits moderated by the current user.
 
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linksInModeratedSubredditsWithPagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches links from subreddits moderated by the current user.
 
 @param category The category from which to fetch links. Defaults to RKSubredditCategoryHot.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linksInModeratedSubredditsWithCategory:(RKSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches links from subreddits moderated by the current user.
 
 @param subreddit The subreddit from which to fetch links.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linksInSubreddit:(RKSubreddit *)subreddit pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches links from subreddits moderated by the current user.
 
 @param subreddit The subreddit from which to fetch links.
 @param category The category from which to fetch links. Defaults to RKSubredditCategoryHot.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linksInSubreddit:(RKSubreddit *)subreddit category:(RKSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches links from subreddits moderated by the current user.
 
 @param subredditName The name of the subreddit from which to fetch links.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linksInSubredditWithName:(NSString *)subredditName pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches links from subreddits moderated by the current user.
 
 @param subredditName The name of the subreddit from which to fetch links.
 @param category The category from which to fetch links. Defaults to RKSubredditCategoryHot.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linksInSubredditWithName:(NSString *)subredditName category:(RKSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches links from a multireddit
 
 @param multireddit The multireddit from which to fetch links.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linksInMultireddit:(RKMultireddit *)multireddit pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches links from a multireddit
 
 @param multireddit The multireddit from which to fetch links.
 @param category The category from which to fetch links. Defaults to RKSubredditCategoryHot.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linksInMultireddit:(RKMultireddit *)multireddit category:(RKSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches links from a multireddit
 
 @param multiredditPath The path of the multireddit from which to fetch links.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linksInMultiredditWithPath:(NSString *)multiredditPath pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches links from a multireddit
 
 @param multiredditPath The path of the multireddit from which to fetch links.
 @param category The category from which to fetch links. Defaults to RKSubredditCategoryHot.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: an array of RKLinks, an RKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linksInMultiredditWithPath:(NSString *)multiredditPath category:(RKSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 Fetches a link object.
 
 @param fullName The link's full name.
 @param completion An optional block to be executed upon request completion. It takes two arguments: the RKLink object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linkWithFullName:(NSString *)fullName completion:(RKObjectCompletionBlock)completion;

/**
 Takes an RKLink object and returns a new RKLink with extra information, such as the upvoteRatio.
 
 @param link The link for which to expand information.
 @param completion An optional block to be executed upon request completion. It takes two arguments: the RKLink object, and any error that occurred.
 */
- (NSURLSessionDataTask *)linkByExpandingInformationForLink:(RKLink *)link completion:(RKObjectCompletionBlock)completion;

#pragma mark - Submitting

/**
 Submits a link post.
 
 @param title The title of the post.
 @param subreddit The subreddit in which to submit the post.
 @param URL The URL to submit.
 @param captchaIdentifier The optional identifier of the CAPTCHA you are submitting with this post.
 @param captchaValue The optional value of the CAPTCHA you are submitting with this post.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)submitLinkPostWithTitle:(NSString *)title subreddit:(RKSubreddit *)subreddit URL:(NSURL *)URL captchaIdentifier:(NSString *)captchaIdentifier captchaValue:(NSString *)captchaValue completion:(RKCompletionBlock)completion;

/**
 Submits a link post.
 
 @param title The title of the post.
 @param subredditName The name of the subreddit in which to submit the post.
 @param URL The URL to submit.
 @param captchaIdentifier The optional identifier of the CAPTCHA you are submitting with this post.
 @param captchaValue The optional value of the CAPTCHA you are submitting with this post.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)submitLinkPostWithTitle:(NSString *)title subredditName:(NSString *)subredditName URL:(NSURL *)URL captchaIdentifier:(NSString *)captchaIdentifier captchaValue:(NSString *)captchaValue completion:(RKCompletionBlock)completion;

/**
 Submits a self post.
 
 @param title The title of the post.
 @param subreddit The subreddit in which to submit the post.
 @param text The text to submit.
 @param captchaIdentifier The optional identifier of the CAPTCHA you are submitting with this post.
 @param captchaValue The optional value of the CAPTCHA you are submitting with this post.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)submitSelfPostWithTitle:(NSString *)title subreddit:(RKSubreddit *)subreddit text:(NSString *)text captchaIdentifier:(NSString *)captchaIdentifier captchaValue:(NSString *)captchaValue completion:(RKCompletionBlock)completion;

/**
 Submits a self post.
 
 @param title The title of the post.
 @param subredditName The name of the subreddit in which to submit the post.
 @param text The text to submit.
 @param captchaIdentifier The optional identifier of the CAPTCHA you are submitting with this post.
 @param captchaValue The optional value of the CAPTCHA you are submitting with this post.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)submitSelfPostWithTitle:(NSString *)title subredditName:(NSString *)subredditName text:(NSString *)text captchaIdentifier:(NSString *)captchaIdentifier captchaValue:(NSString *)captchaValue completion:(RKCompletionBlock)completion;

#pragma mark - Marking NSFW

/**
 Marks a link as not safe for work.
 
 @param link The link to mark as not safe for work.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)markNSFW:(RKLink *)link completion:(RKCompletionBlock)completion;

/**
 Marks a link as not safe for work.
 
 @param fullName The full name of the link to mark as not safe for work.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)markNSFWWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion;

/**
 Marks a link as safe for work.
 
 @param link The link to mark as safe for work.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unmarkNSFW:(RKLink *)link completion:(RKCompletionBlock)completion;

/**
 Marks a link as safe for work.
 
 @param fullName The full name of the link to mark as safe for work.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unmarkNSFWWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion;

#pragma mark - Hiding

/**
 Hides a link.
 
 @param link The link to hide.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)hideLink:(RKLink *)link completion:(RKCompletionBlock)completion;

/**
 Hides a link.
 
 @param fullName The full name of the link to hide.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)hideLinkWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion;

/**
 Unhides a link.
 
 @param link The link to unhide.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unhideLink:(RKLink *)link completion:(RKCompletionBlock)completion;

/**
 Unhides a link.
 
 @param fullName The full name of the link to unhide.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unhideLinkWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion;

/**
 Stores a link visit for a gold user.
 
 @param link The link to store.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)storeVisitedLink:(RKLink *)link completion:(RKCompletionBlock)completion;


/**
 Stores a link visit for a gold user.
 
 @param fullName The full name of the link to store.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)storeVisitedLinkWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion;

@end
