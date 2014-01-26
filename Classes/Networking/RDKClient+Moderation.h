// RDKClient+Moderation.h
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

#import "RDKClient.h"
#import "RDKComment.h"
#import "RDKCompletionBlocks.h"

@class RDKComment, RDKLink, RDKPagination, RDKSubreddit, RDKUser;

@interface RDKClient (Moderation)

/**
 Sets a link as the sticky post in its parent subreddit.
 
 @param link The link to set as sticky.
 @param sticky Whether to set the post as sticky.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)setLink:(RDKLink *)link asSticky:(BOOL)sticky completion:(RDKCompletionBlock)completion;

/**
 Sets a link as the sticky post in its parent subreddit.
 
 @param fullName The full name of the link to set as sticky.
 @param sticky Whether to set the post as sticky.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)setLinkWithFullName:(NSString *)fullName asSticky:(BOOL)sticky completion:(RDKCompletionBlock)completion;

/**
 Enables or disables contest mode for a link.
 
 @param contestMode Whether to enable contest mode.
 @param link The link for which contest mode should be enabled or disabled.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)setContestMode:(BOOL)contestMode forLink:(RDKLink *)link completion:(RDKCompletionBlock)completion;

/**
 Enables or disables contest mode for a link.
 
 @param contestMode Whether to enable contest mode.
 @param fullName The full name of the link for which contest mode should be enabled or disabled.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)setContestMode:(BOOL)contestMode forLinkWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

#pragma mark - Moderator & Contributor Lists

/**
 Gets the list of contributors to a subreddit.
 
 @param subreddit The subreddit from which to get the list of contributors.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)contributorsToSubreddit:(RDKSubreddit *)subreddit completion:(RDKArrayCompletionBlock)completion;

/**
 Gets the list of contributors to a subreddit.
 
 @param name The name of the subreddit from which to get the list of contributors.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)contributorsToSubredditWithName:(NSString *)name completion:(RDKArrayCompletionBlock)completion;

/**
 Gets the list of moderators of a subreddit.
 
 @param subreddit The subreddit from which to get the list of moderators.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)moderatorsOfSubreddit:(RDKSubreddit *)subreddit completion:(RDKArrayCompletionBlock)completion;

/**
 Gets the list of moderators of a subreddit.
 
 @param name The name of the subreddit from which to get the list of moderators.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)moderatorsOfSubredditWithName:(NSString *)name completion:(RDKArrayCompletionBlock)completion;

#pragma mark - Contributor Status

/**
 Adds a contributor to a subreddit.
 
 @param contributor The user to add as a contributor.
 @param subreddit The subreddit to which to add the contributor.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)addContributor:(RDKUser *)contributor toSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Adds a contributor to a subreddit.
 
 @param username The username of the user to add as a contributor.
 @param subredditName The name of the subreddit to which to add the contributor.
 @param fullName The full name of the subreddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)addContributorWithUsername:(NSString *)username toSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

/**
 Removes a contributor from a subreddit.
 
 @param contributor The user to remove.
 @param subreddit The subreddit from which to remove the contributor.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeContributor:(RDKUser *)contributor fromSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Removes a contributor from a subreddit.
 
 @param username The username of the user to remove.
 @param subredditName The name of the subreddit from which to remove the contributor.
 @param fullName The full name of the subreddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeContributorWithUsername:(NSString *)username fromSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

#pragma mark - Moderator Status

/**
 Accepts an invitation to become a moderator of a subreddit.
 
 @param subreddit The subreddit for which to accept the invitation.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)acceptModeratorInvitationForSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Accepts an invitation to become a moderator of a subreddit.
 
 @param subredditName The name of the subreddit for which to accept the invitation.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)acceptModeratorInvitationForSubredditWithName:(NSString *)subredditName completion:(RDKCompletionBlock)completion;

/**
 Invites a user to become a moderator of a subreddit.
 
 @param user The user to send an invitation.
 @param subreddit The subreddit to which to add the moderator.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)inviteUser:(RDKUser *)user toModerateSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Invites a user to become a moderator of a subreddit.
 
 @param username The username of the user to send an invitation.
 @param subredditName The name of the subreddit to which to add the moderator.
 @param fullName The full name of the subreddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)inviteUserWithUsername:(NSString *)username toModerateSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

/**
 Revokes an invitiation to a user to become a moderator.
 
 @param user The user whose invitation should be revoked.
 @param subreddit The subreddit which they were invited to moderate.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)revokeModeratorInvitationToUser:(RDKUser *)user forSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Revokes an invitiation to a user to become a moderator.
 
 @param username The username of the user whose invitation should be revoked.
 @param subredditName The name of the subreddit which they were invited to moderate.
 @param fullName The full name of the subreddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)revokeModeratorInvitationToUserWithUsername:(NSString *)username forSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

/**
 Removes a user from being a moderator of a subreddit.
 
 @param moderator The user to remove.
 @param subreddit The subreddit from which to remove the moderator.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeModerator:(RDKUser *)moderator fromSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Removes a user from being a moderator of a subreddit.
 
 @param username The username of the user to remove.
 @param subredditName The name of the subreddit from which to remove the moderator.
 @param fullName The full name of the subreddit.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeModeratorWithUsername:(NSString *)username fromSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

#pragma mark - Moderation Tasks

/**
 Distinguishes a link or a comment.
 
 @param fullName The full name of the link or comment to distinguish.
 @param distinguishedStatus The status of the link or comment.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)distinguishThingWithFullName:(NSString *)fullName status:(RDKDistinguishedStatus)distinguishedStatus completion:(RDKCompletionBlock)completion;

/**
 Gets the moderation log for a subreddit, listing moderation related events which have happened.
 
 @param subreddit The subreddit for which to get the moderation log.
 @param pagination The pagination object to be sent with the request.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)moderationLogForSubreddit:(RDKSubreddit *)subreddit pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets the moderation log for a subreddit, listing moderation related events which have happened.
 
 @param subredditName The name of the subreddit for which to get the moderation log.
 @param pagination The pagination object to be sent with the request.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)moderationLogForSubredditWithName:(NSString *)subredditName pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets the moderation queue for a subreddit, listing links and comments which have been either reported or marked as spam.
 
 @param subreddit The subreddit for which to get the moderation queue.
 @param pagination The pagination object to be sent with the request.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)moderationQueueForSubreddit:(RDKSubreddit *)subreddit pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets the moderation queue for a subreddit, listing links and comments which have been either reported or marked as spam.
 
 @param subredditName The name of the subreddit for which to get the moderation queue.
 @param pagination The pagination object to be sent with the request.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)moderationQueueForSubredditWithName:(NSString *)subredditName pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets links and comments which have been reported by users.
 
 @param subreddit The subreddit for which to get the reported content.
 @param pagination The pagination object to be sent with the request.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)reportedContentInSubreddit:(RDKSubreddit *)subreddit pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets links and comments which have been reported by users.
 
 @param subredditName The name of the subreddit for which to get the reported content.
 @param pagination The pagination object to be sent with the request.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)reportedContentInSubredditWithName:(NSString *)subredditName pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets links and comments which have been reported as spam by users.
 
 @param subreddit The subreddit for which to get content reported as spam.
 @param pagination The pagination object to be sent with the request.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)spamContentInSubreddit:(RDKSubreddit *)subreddit pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

/**
 Gets links and comments which have been reported as spam by users.
 
 @param subredditName The name of the subreddit for which to get content reported as spam.
 @param pagination The pagination object to be sent with the request.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)spamContentInSubredditWithName:(NSString *)subredditName pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion;

#pragma mark - Approval & Removal

/**
 Approves a link.
 
 @param link The link to approve.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)approveLink:(RDKLink *)link completion:(RDKCompletionBlock)completion;

/**
 Approves a comment.
 
 @param comment The comment to approve.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)approveComment:(RDKComment *)comment completion:(RDKCompletionBlock)completion;

/**
 Approves a link or comment.
 
 @param fullName The full name of the link or comment to approve.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)approveThingWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

/**
 Removes a link.
 
 @param link The link to remove.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeLink:(RDKLink *)link completion:(RDKCompletionBlock)completion;

/**
 Removes a comment.
 
 @param comment The comment to remove.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeComment:(RDKComment *)comment completion:(RDKCompletionBlock)completion;

/**
 Removes a link or comment.
 
 @param fullName The full name of the link or comment to remove.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)removeThingWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

#pragma mark - Reports

/**
 Ignores reports for a link, preventing any future report notifications.
 
 @param link The link for which to ignore reports.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)ignoreReportsForLink:(RDKLink *)link completion:(RDKCompletionBlock)completion;

/**
 Ignores reports for a comment, preventing any future report notifications.
 
 @param comment The comment for which to ignore reports.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)ignoreReportsForComment:(RDKComment *)comment completion:(RDKCompletionBlock)completion;

/**
 Ignores reports for a link or comment, preventing any future report notifications.
 
 @param fullName The full name of the link or comment for which to ignore reports.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)ignoreReportsForThingWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

/**
 Unignores reports for a link, allowing future report notifications.
 
 @param link The link for which to unignore reports.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unignoreReportsForLink:(RDKLink *)link completion:(RDKCompletionBlock)completion;

/**
 Unignores reports for a comment, allowing future report notifications.
 
 @param comment The comment for which to unignore reports.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unignoreReportsForComment:(RDKComment *)comment completion:(RDKCompletionBlock)completion;

/**
 Unignores reports for a link or comment, allowing future report notifications.
 
 @param fullName The full name of the link or comment for which to unignore reports.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unignoreReportsForThingWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

#pragma mark - Banning

/**
 Gets a list of banned users for a subreddit.
 
 @param subreddit The subreddit for which to get the list of banned users.
 @param completion The block to be executed upon completion of the request. It takes two arguments: the response array and any error that occurred. The response array contains NSDictionary objects, each representing a friend of the current user. Each dictionary contains three key-value pairs: the friend's full name (the `id` key), their name, and any note attached to them.
 */
- (NSURLSessionDataTask *)bannedUsersInSubreddit:(RDKSubreddit *)subreddit completion:(RDKArrayCompletionBlock)completion;

/**
 Gets a list of banned users for a subreddit.
 
 @param subredditName The name of the subreddit for which to get the list of banned users.
 @param completion The block to be executed upon completion of the request. It takes two arguments: the response array and any error that occurred. The response array contains NSDictionary objects, each representing a friend of the current user. Each dictionary contains three key-value pairs: the friend's full name (the `id` key), their name, and any note attached to them.
 */
- (NSURLSessionDataTask *)bannedUsersInSubredditWithName:(NSString *)subredditName completion:(RDKArrayCompletionBlock)completion;

/**
 Bans a user from a subreddit.
 
 @param user The user to ban.
 @param subreddit The subreddit from which to ban the user.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)banUser:(RDKUser *)user fromSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Bans a user from a subreddit. Requires both the subreddit's name and full name.
 
 @param username The username of the user to ban.
 @param name The name of the subreddit from which to ban the user.
 @param fullName The full name of the subreddit from which to ban the user.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)banUserWithUsername:(NSString *)username fromSubredditWithName:(NSString *)name fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

/**
 Removes a user's ban from a subreddit.
 
 @param user The user whose ban should be removed.
 @param subreddit The subreddit from which to remove the ban.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unbanUser:(RDKUser *)user fromSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Removes a user's ban from a subreddit. Requires both the subreddit's name and full name.
 
 @param username The username of the user whose ban should be removed.
 @param name The subreddit from which to remove the ban.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unbanUserWithUsername:(NSString *)username fromSubredditWithName:(NSString *)name fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

#pragma mark - Resignation

/**
 Resigns as a contributor to a subreddit.
 
 @param subreddit The subreddit from which to resign as a contributor.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)resignAsContributorToSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Resigns as a contributor to a subreddit.
 
 @param fullName The full name of the subreddit from which to resign as a contributor.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)resignAsContributorToSubredditWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

/**
 Resigns as a moderator of a subreddit.
 
 @param subreddit The subreddit from which to resign as a moderator.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)resignAsModeratorOfSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Resigns as a moderator of a subreddit.
 
 @param fullName The full name of the subreddit from which to resign as a moderator.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)resignAsModeratorOfSubredditWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

#pragma mark - Subreddit Styling

/**
 Gets the URL for the subreddit's stylesheet.
 
 @param subreddit The subreddit for which to get the stylesheet URL.
 @param completion The block to be executed upon completion of the request. Its object parameter is an NSURL with the subreddit's stylesheet address.
 */
- (NSURLSessionDataTask *)stylesheetForSubreddit:(RDKSubreddit *)subreddit completion:(RDKObjectCompletionBlock)completion;

/**
 Gets the URL for the subreddit's stylesheet.
 
 @param subredditName The name of the subreddit for which to get the stylesheet URL.
 @param completion The block to be executed upon completion of the request. Its object parameter is an NSURL with the subreddit's stylesheet address.
 */
- (NSURLSessionDataTask *)stylesheetForSubredditWithName:(NSString *)subredditName completion:(RDKObjectCompletionBlock)completion;

/**
 Sets the subreddit's stylesheet.
 
 @param stylesheet The subreddit's new stylesheet.
 @param subreddit The subreddit for which to set the stylesheet.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)setStylesheet:(NSString *)stylesheet forSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion;

/**
 Sets the subreddit's stylesheet.
 
 @param stylesheet The subreddit's new stylesheet.
 @param subredditName The name of the subreddit for which to set the stylesheet.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)setStylesheet:(NSString *)stylesheet forSubredditWithName:(NSString *)subredditName completion:(RDKCompletionBlock)completion;

@end
