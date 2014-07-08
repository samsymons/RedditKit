// RKClient+Moderation.m
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

#import "RKClient+Moderation.h"
#import "RKClient+Requests.h"

#import "RKUser.h"
#import "RKComment.h"
#import "RKLink.h"
#import "RKSubreddit.h"

NSString * RKStringFromDistinguishedStatus(RKDistinguishedStatus status)
{
    switch (status)
    {
        case RKDistinguishedStatusYes:
            return @"yes";
            break;
        case RKDistinguishedStatusNo:
            return @"no";
            break;
        case RKDistinguishedStatusAdmin:
            return @"admin";
            break;
        case RKDistinguishedStatusSpecial:
            return @"special";
            break;
        default:
            return @"no";
            break;
    }
}

@implementation RKClient (Moderation)

- (NSURLSessionDataTask *)setLink:(RKLink *)link asSticky:(BOOL)sticky completion:(RKCompletionBlock)completion
{
    return [self setLinkWithFullName:link.fullName asSticky:sticky completion:completion];
}

- (NSURLSessionDataTask *)setLinkWithFullName:(NSString *)fullName asSticky:(BOOL)sticky completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSString *state = sticky ? @"True" : @"False";
    NSDictionary *parameters = @{@"id": fullName, @"state": state};
    
    return [self basicPostTaskWithPath:@"api/set_subreddit_sticky" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)setContestMode:(BOOL)contestMode forLink:(RKLink *)link completion:(RKCompletionBlock)completion
{
    return [self setContestMode:contestMode forLinkWithFullName:link.fullName completion:completion];
}

- (NSURLSessionDataTask *)setContestMode:(BOOL)contestMode forLinkWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSString *state = contestMode ? @"True" : @"False";
    NSDictionary *parameters = @{@"id": fullName, @"state": state};
    
    return [self basicPostTaskWithPath:@"api/set_contest_mode" parameters:parameters completion:completion];
}

#pragma mark - Moderator & Contributor Lists

- (NSURLSessionDataTask *)contributorsToSubreddit:(RKSubreddit *)subreddit completion:(RKArrayCompletionBlock)completion
{
    return [self contributorsToSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)contributorsToSubredditWithName:(NSString *)name completion:(RKArrayCompletionBlock)completion
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

- (NSURLSessionDataTask *)moderatorsOfSubreddit:(RKSubreddit *)subreddit completion:(RKArrayCompletionBlock)completion
{
    return [self moderatorsOfSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)moderatorsOfSubredditWithName:(NSString *)name completion:(RKArrayCompletionBlock)completion
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

- (NSURLSessionDataTask *)addContributor:(RKUser *)contributor toSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self addContributorWithUsername:contributor.username toSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)addContributorWithUsername:(NSString *)username toSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    return [self friendTaskWithContainer:fullName subredditName:subredditName name:username type:@"contributor" completion:completion];
}

- (NSURLSessionDataTask *)removeContributor:(RKUser *)contributor fromSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self removeContributorWithUsername:contributor.username fromSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)removeContributorWithUsername:(NSString *)username fromSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    return [self unfriendTaskWithContainer:fullName subredditName:subredditName name:username type:@"contributor" completion:completion];
}

#pragma mark - Moderator Status

- (NSURLSessionDataTask *)acceptModeratorInvitationForSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self acceptModeratorInvitationForSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)acceptModeratorInvitationForSubredditWithName:(NSString *)subredditName completion:(RKCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"r/%@/api/accept_moderator_invite", subredditName];
    
    return [self basicPostTaskWithPath:path parameters:nil completion:completion];
}

- (NSURLSessionDataTask *)inviteUser:(RKUser *)user toModerateSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self inviteUserWithUsername:user.username toModerateSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)inviteUserWithUsername:(NSString *)username toModerateSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    return [self friendTaskWithContainer:fullName subredditName:subredditName name:username type:@"moderator" completion:completion];
}

- (NSURLSessionDataTask *)revokeModeratorInvitationToUser:(RKUser *)user forSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self revokeModeratorInvitationToUserWithUsername:user.username forSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)revokeModeratorInvitationToUserWithUsername:(NSString *)username forSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    return [self unfriendTaskWithContainer:fullName subredditName:subredditName name:username type:@"moderator_invite" completion:completion];
}

- (NSURLSessionDataTask *)removeModerator:(RKUser *)moderator fromSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self removeModeratorWithUsername:moderator.username fromSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)removeModeratorWithUsername:(NSString *)username fromSubredditWithName:(NSString *)subredditName fullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    return [self unfriendTaskWithContainer:fullName subredditName:subredditName name:username type:@"moderator" completion:completion];
}

#pragma mark - Moderation Tasks

- (NSURLSessionDataTask *)distinguishThingWithFullName:(NSString *)fullName status:(RKDistinguishedStatus)status completion:(RKCompletionBlock)completion
{
    NSDictionary *parameters = @{@"how": RKStringFromDistinguishedStatus(status), @"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/distinguish" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)moderationLogForSubreddit:(RKSubreddit *)subreddit pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self moderationLogForSubredditWithName:subreddit.name pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)moderationLogForSubredditWithName:(NSString *)subredditName pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"r/%@/about/log.json", subredditName];
    
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)moderationQueueForSubreddit:(RKSubreddit *)subreddit pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self moderationQueueForSubredditWithName:subreddit.name pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)moderationQueueForSubredditWithName:(NSString *)subredditName pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/about/modqueue.json", subredditName];
    
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)reportedContentInSubreddit:(RKSubreddit *)subreddit pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self reportedContentInSubredditWithName:subreddit.name pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)reportedContentInSubredditWithName:(NSString *)subredditName pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/about/reports.json", subredditName];
    
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)spamContentInSubreddit:(RKSubreddit *)subreddit pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self spamContentInSubredditWithName:subreddit.name pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)spamContentInSubredditWithName:(NSString *)subredditName pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/about/spam.json", subredditName];
    
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

#pragma mark - Approval & Removal

- (NSURLSessionDataTask *)approveLink:(RKLink *)link completion:(RKCompletionBlock)completion
{
    return [self approveThingWithFullName:[link fullName] completion:completion];
}

- (NSURLSessionDataTask *)approveComment:(RKComment *)comment completion:(RKCompletionBlock)completion
{
    return [self approveThingWithFullName:[comment fullName] completion:completion];
}

- (NSURLSessionDataTask *)approveThingWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/approve" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)removeLink:(RKLink *)link completion:(RKCompletionBlock)completion
{
    return [self removeThingWithFullName:link.fullName completion:completion];
}

- (NSURLSessionDataTask *)removeComment:(RKComment *)comment completion:(RKCompletionBlock)completion
{
    return [self removeThingWithFullName:comment.fullName completion:completion];
}

- (NSURLSessionDataTask *)removeThingWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/remove" parameters:parameters completion:completion];
}

#pragma mark - Reports

- (NSURLSessionDataTask *)ignoreReportsForLink:(RKLink *)link completion:(RKCompletionBlock)completion
{
    return [self ignoreReportsForThingWithFullName:link.fullName completion:completion];
}

- (NSURLSessionDataTask *)ignoreReportsForComment:(RKLink *)comment completion:(RKCompletionBlock)completion
{
    return [self ignoreReportsForThingWithFullName:comment.fullName completion:completion];
}

- (NSURLSessionDataTask *)ignoreReportsForThingWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/ignore_reports" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)unignoreReportsForLink:(RKLink *)link completion:(RKCompletionBlock)completion
{
    return [self unignoreReportsForThingWithFullName:link.fullName completion:completion];
}

- (NSURLSessionDataTask *)unignoreReportsForComment:(RKLink *)comment completion:(RKCompletionBlock)completion
{
    return [self unignoreReportsForThingWithFullName:comment.fullName completion:completion];
}

- (NSURLSessionDataTask *)unignoreReportsForThingWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/unignore_reports" parameters:parameters completion:completion];
}

#pragma mark - Banning

- (NSURLSessionDataTask *)bannedUsersInSubreddit:(RKSubreddit *)subreddit completion:(RKArrayCompletionBlock)completion
{
    return [self bannedUsersInSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)bannedUsersInSubredditWithName:(NSString *)subredditName completion:(RKArrayCompletionBlock)completion
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

- (NSURLSessionDataTask *)banUser:(RKUser *)user fromSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self banUserWithUsername:user.username fromSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)banUserWithUsername:(NSString *)username fromSubredditWithName:(NSString *)name fullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    return [self friendTaskWithContainer:fullName subredditName:name name:username type:@"banned" completion:completion];
}

- (NSURLSessionDataTask *)unbanUser:(RKUser *)user fromSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self unbanUserWithUsername:user.username fromSubredditWithName:subreddit.name fullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)unbanUserWithUsername:(NSString *)username fromSubredditWithName:(NSString *)name fullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    return [self unfriendTaskWithContainer:fullName subredditName:name name:username type:@"banned" completion:completion];
}

#pragma mark - Resignation

- (NSURLSessionDataTask *)resignAsContributorToSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self resignAsContributorToSubredditWithFullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)resignAsContributorToSubredditWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/leavecontributor" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)resignAsModeratorOfSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self resignAsModeratorOfSubredditWithFullName:subreddit.fullName completion:completion];
}

- (NSURLSessionDataTask *)resignAsModeratorOfSubredditWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/leavemoderator" parameters:parameters completion:completion];
}

#pragma mark - Subreddit Styling

- (NSURLSessionDataTask *)stylesheetForSubreddit:(RKSubreddit *)subreddit completion:(RKObjectCompletionBlock)completion
{
    return [self stylesheetForSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)stylesheetForSubredditWithName:(NSString *)subredditName completion:(RKObjectCompletionBlock)completion
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

- (NSURLSessionDataTask *)setStylesheet:(NSString *)stylesheet forSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self setStylesheet:stylesheet forSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)setStylesheet:(NSString *)stylesheet forSubredditWithName:(NSString *)subredditName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(stylesheet);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"stylesheet_contents": stylesheet, @"op": @"save"};
    NSString *path = [NSString stringWithFormat:@"r/%@/api/subreddit_stylesheet", subredditName];
    
    return [self basicPostTaskWithPath:path parameters:parameters completion:completion];
}

@end
