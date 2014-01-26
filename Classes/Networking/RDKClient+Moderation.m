// RDKClient+Moderation.m
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

#import "RDKClient+Moderation.h"
#import "RDKClient+Requests.h"

#import "RDKUser.h"
#import "RDKComment.h"
#import "RDKLink.h"
#import "RDKSubreddit.h"

NSString * NSStringFromDistinguishedStatus(RDKDistinguishedStatus status)
{
    switch (status)
    {
        case RDKDistinguishedStatusYes:
            return @"yes";
            break;
        case RDKDistinguishedStatusNo:
            return @"no";
            break;
        case RDKDistinguishedStatusAdmin:
            return @"admin";
            break;
        case RDKDistinguishedStatusSpecial:
            return @"special";
            break;
        default:
            return @"no";
            break;
    }
}

@implementation RDKClient (Moderation)

- (NSURLSessionDataTask *)setLink:(RDKLink *)link asSticky:(BOOL)sticky completion:(RDKCompletionBlock)completion
{
    return [self setLinkWithFullName:link.fullName asSticky:sticky completion:completion];
}

- (NSURLSessionDataTask *)setLinkWithFullName:(NSString *)fullName asSticky:(BOOL)sticky completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSString *state = sticky ? @"True" : @"False";
    NSDictionary *parameters = @{@"id": fullName, @"state": state};
    
    return [self basicPostTaskWithPath:@"api/set_subreddit_sticky" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)setContestMode:(BOOL)contestMode forLink:(RDKLink *)link completion:(RDKCompletionBlock)completion
{
    return [self setContestMode:contestMode forLinkWithFullName:link.fullName completion:completion];
}

- (NSURLSessionDataTask *)setContestMode:(BOOL)contestMode forLinkWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSString *state = contestMode ? @"True" : @"False";
    NSDictionary *parameters = @{@"id": fullName, @"state": state};
    
    return [self basicPostTaskWithPath:@"api/set_contest_mode" parameters:parameters completion:completion];
}

#pragma mark - Moderator & Contributor Lists

- (NSURLSessionDataTask *)contributorsToSubreddit:(RDKSubreddit *)subreddit completion:(RDKArrayCompletionBlock)completion
{
    return [self contributorsToSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)contributorsToSubredditWithName:(NSString *)name completion:(RDKArrayCompletionBlock)completion
{
    NSParameterAssert(name);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/about/contributors.json", name];
    
    return [self getPath:path parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (responseObject)
        {
            NSArray *contributors = responseObject[@"data"][@"children"];
            completion(contributors, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)moderatorsOfSubreddit:(RDKSubreddit *)subreddit completion:(RDKArrayCompletionBlock)completion
{
    return [self moderatorsOfSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)moderatorsOfSubredditWithName:(NSString *)name completion:(RDKArrayCompletionBlock)completion
{
    NSParameterAssert(name);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/about/moderators.json", name];
    
    return [self getPath:path parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        NSArray *moderators = responseObject[@"data"][@"children"];
        completion(moderators, error);
    }];
}

#pragma mark - Contributor Status

- (NSURLSessionDataTask *)addContributor:(RDKUser *)contributor toSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self addContributorWithUsername:contributor.username toSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)addContributorWithUsername:(NSString *)username toSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    return [self friendTaskWithContainer:fullName subredditName:subredditName name:username type:@"contributor" completion:completion];
}

- (NSURLSessionDataTask *)removeContributor:(RDKUser *)contributor fromSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self removeContributorWithUsername:contributor.username fromSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)removeContributorWithUsername:(NSString *)username fromSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    return [self unfriendTaskWithContainer:fullName subredditName:subredditName name:username type:@"contributor" completion:completion];
}

#pragma mark - Moderator Status

- (NSURLSessionDataTask *)acceptModeratorInvitationForSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self acceptModeratorInvitationForSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)acceptModeratorInvitationForSubredditWithName:(NSString *)subredditName completion:(RDKCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"r/%@/api/accept_moderator_invite", subredditName];
    
    return [self basicPostTaskWithPath:path parameters:nil completion:completion];
}

- (NSURLSessionDataTask *)inviteUser:(RDKUser *)user toModerateSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self inviteUserWithUsername:user.username toModerateSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)inviteUserWithUsername:(NSString *)username toModerateSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    return [self friendTaskWithContainer:fullName subredditName:subredditName name:username type:@"moderator" completion:completion];
}

- (NSURLSessionDataTask *)revokeModeratorInvitationToUser:(RDKUser *)user forSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self revokeModeratorInvitationToUserWithUsername:user.username forSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)revokeModeratorInvitationToUserWithUsername:(NSString *)username forSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    return [self unfriendTaskWithContainer:fullName subredditName:subredditName name:username type:@"moderator_invite" completion:completion];
}

- (NSURLSessionDataTask *)removeModerator:(RDKUser *)moderator fromSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self removeModeratorWithUsername:moderator.username fromSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)removeModeratorWithUsername:(NSString *)username fromSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    return [self unfriendTaskWithContainer:fullName subredditName:subredditName name:username type:@"moderator" completion:completion];
}

#pragma mark - Moderation Tasks

- (NSURLSessionDataTask *)distinguishThingWithFullName:(NSString *)fullName status:(RDKDistinguishedStatus)status completion:(RDKCompletionBlock)completion
{
    NSDictionary *parameters = @{@"how": NSStringFromDistinguishedStatus(status), @"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/distinguish" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)moderationLogForSubreddit:(RDKSubreddit *)subreddit pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self moderationLogForSubredditWithName:subreddit.name pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)moderationLogForSubredditWithName:(NSString *)subredditName pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"r/%@/about/log.json", subredditName];
    
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)moderationQueueForSubreddit:(RDKSubreddit *)subreddit pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self moderationQueueForSubredditWithName:subreddit.name pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)moderationQueueForSubredditWithName:(NSString *)subredditName pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/about/modqueue.json", subredditName];
    
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)reportedContentInSubreddit:(RDKSubreddit *)subreddit pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self reportedContentInSubredditWithName:subreddit.name pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)reportedContentInSubredditWithName:(NSString *)subredditName pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/about/reports.json", subredditName];
    
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)spamContentInSubreddit:(RDKSubreddit *)subreddit pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self spamContentInSubredditWithName:subreddit.name pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)spamContentInSubredditWithName:(NSString *)subredditName pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/about/spam.json", subredditName];
    
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

#pragma mark - Approval & Removal

- (NSURLSessionDataTask *)approveLink:(RDKLink *)link completion:(RDKCompletionBlock)completion
{
    return [self approveThingWithFullName:[link fullName] completion:completion];
}

- (NSURLSessionDataTask *)approveComment:(RDKComment *)comment completion:(RDKCompletionBlock)completion
{
    return [self approveThingWithFullName:[comment fullName] completion:completion];
}

- (NSURLSessionDataTask *)approveThingWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/approve" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)removeLink:(RDKLink *)link completion:(RDKCompletionBlock)completion
{
    return [self removeThingWithFullName:link.fullName completion:completion];
}

- (NSURLSessionDataTask *)removeComment:(RDKComment *)comment completion:(RDKCompletionBlock)completion
{
    return [self removeThingWithFullName:comment.fullName completion:completion];
}

- (NSURLSessionDataTask *)removeThingWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/remove" parameters:parameters completion:completion];
}

#pragma mark - Reports

- (NSURLSessionDataTask *)ignoreReportsForLink:(RDKLink *)link completion:(RDKCompletionBlock)completion
{
    return [self ignoreReportsForThingWithFullName:link.fullName completion:completion];
}

- (NSURLSessionDataTask *)ignoreReportsForComment:(RDKLink *)comment completion:(RDKCompletionBlock)completion
{
    return [self ignoreReportsForThingWithFullName:comment.fullName completion:completion];
}

- (NSURLSessionDataTask *)ignoreReportsForThingWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/ignore_reports" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)unignoreReportsForLink:(RDKLink *)link completion:(RDKCompletionBlock)completion
{
    return [self unignoreReportsForThingWithFullName:link.fullName completion:completion];
}

- (NSURLSessionDataTask *)unignoreReportsForComment:(RDKLink *)comment completion:(RDKCompletionBlock)completion
{
    return [self unignoreReportsForThingWithFullName:comment.fullName completion:completion];
}

- (NSURLSessionDataTask *)unignoreReportsForThingWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/unignore_reports" parameters:parameters completion:completion];
}

#pragma mark - Banning

- (NSURLSessionDataTask *)bannedUsersInSubreddit:(RDKSubreddit *)subreddit completion:(RDKArrayCompletionBlock)completion
{
    return [self bannedUsersInSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)bannedUsersInSubredditWithName:(NSString *)subredditName completion:(RDKArrayCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/about/banned.json", subredditName];
    
    return [self getPath:path parameters:nil completion:^(NSHTTPURLResponse *response, NSDictionary *responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (responseObject)
        {
            NSArray *bannedUsers = responseObject[@"data"][@"children"];
            completion(bannedUsers, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)banUser:(RDKUser *)user fromSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self banUserWithUsername:user.username fromSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)banUserWithUsername:(NSString *)username fromSubredditWithName:(NSString *)name fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    return [self friendTaskWithContainer:fullName subredditName:name name:username type:@"banned" completion:completion];
}

- (NSURLSessionDataTask *)unbanUser:(RDKUser *)user fromSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self unbanUserWithUsername:user.username fromSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)unbanUserWithUsername:(NSString *)username fromSubredditWithName:(NSString *)name fullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    return [self unfriendTaskWithContainer:fullName subredditName:name name:username type:@"banned" completion:completion];
}

#pragma mark - Resignation

- (NSURLSessionDataTask *)resignAsContributorToSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self resignAsContributorToSubredditWithFullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)resignAsContributorToSubredditWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/leavecontributor" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)resignAsModeratorOfSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self resignAsModeratorOfSubredditWithFullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)resignAsModeratorOfSubredditWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/leavemoderator" parameters:parameters completion:completion];
}

#pragma mark - Subreddit Styling

- (NSURLSessionDataTask *)stylesheetForSubreddit:(RDKSubreddit *)subreddit completion:(RDKObjectCompletionBlock)completion
{
    return [self stylesheetForSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)stylesheetForSubredditWithName:(NSString *)subredditName completion:(RDKObjectCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/stylesheet", subredditName];
    
    // This method is pretty dodgy at the moment. It passes the response's URL to the completion block if JSON parsing fails as expected.
    // The response URL will be set to the subreddit's stylesheet URL, since the API method redirects there.
    return [self getPath:path parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (error.code == 3840)
        {
            completion(response.URL, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)setStylesheet:(NSString *)stylesheet forSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self setStylesheet:stylesheet forSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)setStylesheet:(NSString *)stylesheet forSubredditWithName:(NSString *)subredditName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(stylesheet);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"stylesheet_contents": stylesheet, @"op": @"save"};
    NSString *path = [NSString stringWithFormat:@"r/%@/api/subreddit_stylesheet", subredditName];
    
    return [self basicPostTaskWithPath:path parameters:parameters completion:completion];
}

@end
