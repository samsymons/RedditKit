// RDKClient+Users.h
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

#import "RDKOAuthClient.h"
#import "RDKCompletionBlocks.h"

typedef NS_ENUM(NSUInteger, RDKUserContentCategory)
{
	RDKUserContentCategoryOverview = 1,
	RDKUserContentCategoryComments,
	RDKUserContentCategorySubmissions,
    RDKUserContentCategoryGilded,
	RDKUserContentCategoryLiked,
	RDKUserContentCategoryDisliked
};

typedef NS_ENUM(NSUInteger, RDKSubscribedSubredditCategory)
{
	RDKSubscribedSubredditCategorySubscriber = 1,
    RDKSubscribedSubredditCategoryContributor,
    RDKSubscribedSubredditCategoryModerator
};

@class RDKUser;

@interface RDKClient (Users)

/**
 Gets the current user.
 
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)currentUserWithCompletion:(RDKObjectCompletionBlock)completion;

/**
 Gets a specific user.
 This method is useful when you already have an RDKUser object, but need to get up-to-date karma totals and post history.
 
 @param user The user object to fetch.
 @param completion The block to be executed upon completion of the request. It takes two arguments: the response object (an RDKUser) and any error that occurred.
 */
- (NSURLSessionDataTask *)user:(RDKUser *)user completion:(RDKObjectCompletionBlock)completion;

/**
 Gets a specific user.
 
 @param username The username to gather information for.
 @param completion The block to be executed upon completion of the request. It takes two arguments: the response object (an RDKUser) and any error that occurred.
 */
- (NSURLSessionDataTask *)userWithUsername:(NSString *)username completion:(RDKObjectCompletionBlock)completion;

/**
 Gets the subreddits to which the current user is subscribed.
 
 @param completion The block to be executed upon completion of the request. It takes three arguments: the response array of RDKSubreddit objects, an RDKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)subscribedSubredditsWithCompletion:(RDKListingCompletionBlock)completion;

/**
 Gets the subreddits to which the current user is subscribed.
 
 @param category The category of subreddits to return.
 @param completion The block to be executed upon completion of the request. It takes three arguments: the response array of RDKSubreddit objects, an RDKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)subscribedSubredditsInCategory:(RDKSubscribedSubredditCategory)category completion:(RDKListingCompletionBlock)completion;

/**
 Gets the subreddits to which the current user is subscribed.

 @param category The category of subreddits to return.
 @param pagination The pagination object to be sent with the request.
 @param completion The block to be executed upon completion of the request. It takes three arguments: the response array of RDKSubreddit objects, an RDKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)subscribedSubredditsInCategory:(RDKSubscribedSubredditCategory)category pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Deletes the current user's account on reddit and signs them out from the RDKClient.
 
 @param reason An optional reason for the account deletion. Defaults to "Deleted via the reddit API".
 @param currentPassword The current user's password.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @note This will delete the current user's reddit account permanently.
 */
- (NSURLSessionDataTask *)deleteCurrentUserWithReason:(NSString *)reason currentPassword:(NSString *)currentPassword completion:(RDKCompletionBlock)completion;

#pragma mark - User Content

/**
 Gets an overview of a user (their most recent links and comments combined).
 
 @param user The user for which to get an overview.
 @param pagination An optional pagination object.
 @param completion The block to be executed upon completion of the request. It takes three arguments: an array of RDKLinks, an RDKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)overviewOfUser:(RDKUser *)user pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets an overview of a user (their most recent links and comments combined).
 
 @param username The username of the user for which to get an overview.
 @param pagination An optional pagination object.
 @param completion The block to be executed upon completion of the request. It takes three arguments: an array of RDKLinks, an RDKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)overviewOfUserWithUsername:(NSString *)username pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets comments submitted by a user.
 
 @param user The user for which to get comments.
 @param pagination An optional pagination object.
 @param completion The block to be executed upon completion of the request. It takes three arguments: an array of RDKLinks, an RDKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)commentsByUser:(RDKUser *)user pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets comments submitted by a user.
 
 @param username The username of the user for which to get comments.
 @param pagination An optional pagination object.
 @param completion The block to be executed upon completion of the request. It takes three arguments: an array of RDKLinks, an RDKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)commentsByUserWithUsername:(NSString *)username pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets submissions by a user.
 
 @param user The user whose submissions should be fetched.
 @param pagination An optional pagination object.
 @param completion The block to be executed upon completion of the request. It takes three arguments: an array of RDKLinks, an RDKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)submissionsByUser:(RDKUser *)user pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets submissions by a user.
 
 @param username The username of the user whose submissions should be fetched.
 @param pagination An optional pagination object.
 @param completion The block to be executed upon completion of the request. It takes three arguments: an array of RDKLinks, an RDKPagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)submissionsByUserWithUsername:(NSString *)username pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets content for a user, such as links or comments they have submitted.
 
 @param user The user for which to fetch content.
 @param category The category of content to fetch.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: the content, a pagination object, and any error that occurred.
 @note Only the Overview, Submissions and Comments categories will be affected by the userContentSortingMethod property on the pagination object.
 */
- (NSURLSessionDataTask *)contentForUser:(RDKUser *)user category:(RDKUserContentCategory)category pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets content for a user, such as links or comments they have submitted.
 
 @param username The username of the user for which to fetch content.
 @param category The category of content to fetch.
 @param pagination The pagination object to be sent with the request.
 @param completion An optional block to be executed upon request completion. It takes three arguments: the content, a pagination object, and any error that occurred.
 */
- (NSURLSessionDataTask *)contentForUserWithUsername:(NSString *)username category:(RDKUserContentCategory)category pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

#pragma mark - Friends

/**
 Gets the current user's friend list.
 
 @param completion The block to be executed upon completion of the request. It takes two arguments: the response array and any error that occurred. The response array contains NSDictionary objects, each representing a friend of the current user. Each dictionary contains three key-value pairs: the friend's full name (the 'id' key), their name (the 'name' key), and any note (the 'note' key) attached to them.
 */
- (NSURLSessionDataTask *)friendsWithCompletion:(RDKArrayCompletionBlock)completion;

/**
 Gets all links submitted by friends of the current user.
 
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)submissionsByFriendsWithCompletion:(RDKListingCompletionBlock)completion;

/**
 Adds a user to the current user's friend list.
 
 @param account The user to add as a friend.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)addFriend:(RDKUser *)account completion:(RDKCompletionBlock)completion;

/**
 Adds a user to the current user's friend list.
 
 @param username The username of the user to add as a friend.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)addFriendWithUsername:(NSString *)username completion:(RDKCompletionBlock)completion;

/**
 Removes a user from the current user's friend list.
 
 @param account The user to remove from the current user's friend list.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeFriend:(RDKUser *)account completion:(RDKCompletionBlock)completion;

/**
 Removes a user from the current user's friend list.
 
 @param username The username of the user to remove from the current user's friend list.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeFriendWithUsername:(NSString *)username completion:(RDKCompletionBlock)completion;

#pragma mark - Registration

/**
 Checks the availability for a username.
 
 @param username The username for which to check availability.
 @param completion An optional block to be executed upon request completion. It takes two arguments: a boolean indicating the username's availability, and any error that occurred.

 */
- (NSURLSessionDataTask *)checkAvailabilityOfUsername:(NSString *)username completion:(RDKBooleanCompletionBlock)completion;

// TODO: Register account

@end
