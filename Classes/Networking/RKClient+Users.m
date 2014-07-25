// RKClient+Users.m
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

#import "RKClient+Users.h"
#import "RKObjectBuilder.h"
#import "RKClient+Requests.h"
#import "RKClient+Errors.h"
#import "RKUser.h"
#import "RKSubreddit.h"
#import "RKPagination.h"

NSString * RKStringFromUserContentCategory(RKUserContentCategory category)
{
    switch (category)
    {
        case RKUserContentCategoryOverview:
            return @"overview";
            break;
        case RKUserContentCategoryComments:
            return @"comments";
            break;
        case RKUserContentCategorySubmissions:
            return @"submitted";
            break;
        case RKUserContentCategoryGilded:
            return @"gilded";
            break;
        case RKUserContentCategoryLiked:
            return @"liked";
            break;
        case RKUserContentCategoryDisliked:
            return @"disliked";
            break;
        case RKUserContentCategoryHidden:
            return @"hidden";
            break;
        case RKUserContentCategorySaved:
            return @"saved";
            break;
        default:
            return @"overview";
            break;
    }
}

NSString * RKStringFromSubscribedSubredditCategory(RKSubscribedSubredditCategory category)
{
    switch (category)
    {
        case RKSubscribedSubredditCategorySubscriber:
            return @"subscriber";
            break;
        case RKSubscribedSubredditCategoryContributor:
            return @"contributor";
            break;
        case RKSubscribedSubredditCategoryModerator:
            return @"moderator";
            break;
        default:
            return @"subscriber";
            break;
    }
}

@implementation RKClient (Users)

#pragma mark - Current User

- (NSURLSessionDataTask *)currentUserWithCompletion:(RKObjectCompletionBlock)completion
{
    return [self getPath:@"api/me.json" parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (responseObject)
        {
            RKUser *account = [RKObjectBuilder objectFromJSON:responseObject];
            
            if (completion)
            {
                completion(account, nil);
            }
        }
        else
        {
            if (completion)
            {
                completion(nil, error);
            }
        }
    }];
}

- (NSURLSessionDataTask *)deleteCurrentUserWithReason:(NSString *)reason currentPassword:(NSString *)currentPassword completion:(RKCompletionBlock)completion
{
    NSParameterAssert(currentPassword);
    
    NSString *reasonForDeletion = reason ?: @"Deleted via reddit API";
    NSDictionary *parameters = @{@"passwd": currentPassword, @"delete_message": reasonForDeletion};
    
    __weak __typeof(self)weakSelf = self;
    return [self postPath:@"api/delete_user" parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        [weakSelf signOut];
        
        completion(error);
    }];
}

#pragma mark - Subreddits

- (NSURLSessionDataTask *)subscribedSubredditsWithCompletion:(RKListingCompletionBlock)completion
{
    return [self subscribedSubredditsInCategory:RKSubscribedSubredditCategorySubscriber completion:completion];
}

- (NSURLSessionDataTask *)subscribedSubredditsInCategory:(RKSubscribedSubredditCategory)category completion:(RKListingCompletionBlock)completion
{
    return [self subscribedSubredditsInCategory:category pagination:nil completion:completion];
}

- (NSURLSessionDataTask *)subscribedSubredditsInCategory:(RKSubscribedSubredditCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion {
    NSMutableDictionary *taskParameters = [NSMutableDictionary dictionary];
    [taskParameters addEntriesFromDictionary:[pagination dictionaryValue]];

    NSString *path = [NSString stringWithFormat:@"subreddits/mine/%@.json", RKStringFromSubscribedSubredditCategory(category)];

    return [self getPath:path parameters:taskParameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion) return;
        
        if (responseObject)
        {
            // A crude check to see if we have been redirected to the login page:
            
            NSString *path = [[response URL] path];
            NSRange range = [path rangeOfString:@"login"];
            
            if (range.location != NSNotFound)
            {
                completion(nil, nil, [RKClient authenticationRequiredError]);
                return;
            }
            
            // Parse the response:
            
            NSArray *subredditsJSON = responseObject[@"data"][@"children"];
            NSMutableArray *subredditObjects = [[NSMutableArray alloc] initWithCapacity:[subredditsJSON count]];
            
            for (NSDictionary *subredditJSON in subredditsJSON)
            {
                NSError *mantleError = nil;
                RKSubreddit *subreddit = [MTLJSONAdapter modelOfClass:[RKSubreddit class] fromJSONDictionary:subredditJSON error:&mantleError];
                
                if (!mantleError)
                {
                    [subredditObjects addObject:subreddit];
                }
            }
            
            RKPagination *pagination = [RKPagination paginationFromListingResponse:responseObject];
            
            completion([subredditObjects copy], pagination, nil);
        }
        else
        {
            completion(nil, nil, error);
        }
    }];
}

#pragma mark - Other Users

- (NSURLSessionDataTask *)user:(RKUser *)user completion:(RKObjectCompletionBlock)completion
{
    return [self userWithUsername:user.username completion:completion];
}

- (NSURLSessionDataTask *)userWithUsername:(NSString *)username completion:(RKObjectCompletionBlock)completion
{
    NSParameterAssert(username);
    
    NSString *path = [NSString stringWithFormat:@"user/%@/about.json", username];
    
    return [self getPath:path parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (responseObject)
        {
            RKUser *account = [RKObjectBuilder objectFromJSON:responseObject];
            completion(account, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

#pragma mark - User Content

- (NSURLSessionDataTask *)overviewOfUser:(RKUser *)user pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self overviewOfUserWithUsername:user.username pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)overviewOfUserWithUsername:(NSString *)username pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self contentForUserWithUsername:username category:RKUserContentCategoryOverview pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)commentsByUser:(RKUser *)user pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self commentsByUserWithUsername:user.username pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)commentsByUserWithUsername:(NSString *)username pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self contentForUserWithUsername:username category:RKUserContentCategoryComments pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)submissionsByUser:(RKUser *)user pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self submissionsByUserWithUsername:user.username pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)submissionsByUserWithUsername:(NSString *)username pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self contentForUserWithUsername:username category:RKUserContentCategorySubmissions pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)contentForUser:(RKUser *)user category:(RKUserContentCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    return [self contentForUserWithUsername:user.username category:category pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)contentForUserWithUsername:(NSString *)username category:(RKUserContentCategory)category pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion
{
    NSParameterAssert(username);
    
    NSString *path = [NSString stringWithFormat:@"user/%@/%@.json", username, RKStringFromUserContentCategory(category)];
    
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

#pragma mark - Friends

- (NSURLSessionDataTask *)friendsWithCompletion:(RKArrayCompletionBlock)completion
{
    return [self getPath:@"prefs/friends.json" parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            if (![responseObject isKindOfClass:[NSArray class]])
            {
                completion(nil, [RKClient authenticationRequiredError]);
                return;
            }
            
            NSDictionary *friendsListing = [responseObject firstObject];
            NSArray *friends = friendsListing[@"data"][@"children"];
            
            completion(friends, nil);
        }
    }];
}

- (NSURLSessionDataTask *)submissionsByFriendsWithCompletion:(RKListingCompletionBlock)completion
{
    return [self listingTaskWithPath:@"r/friends.json" parameters:nil pagination:nil completion:completion];
}

- (NSURLSessionDataTask *)addFriend:(RKUser *)user completion:(RKCompletionBlock)completion
{
    return [self addFriendWithUsername:user.username completion:completion];
}

- (NSURLSessionDataTask *)addFriendWithUsername:(NSString *)username completion:(RKCompletionBlock)completion
{
    NSParameterAssert(username);
    
    return [self friendTaskWithContainer:self.currentUser.fullName subredditName:nil name:username type:@"friend" completion:completion];
}

- (NSURLSessionDataTask *)removeFriend:(RKUser *)account completion:(RKCompletionBlock)completion
{
    return [self removeFriendWithUsername:account.username completion:completion];
}

- (NSURLSessionDataTask *)removeFriendWithUsername:(NSString *)username completion:(RKCompletionBlock)completion
{
    NSParameterAssert(username);
    
    return [self unfriendTaskWithContainer:self.currentUser.fullName subredditName:nil name:username type:@"friend" completion:completion];
}

#pragma mark - Registration

- (NSURLSessionDataTask *)checkAvailabilityOfUsername:(NSString *)username completion:(RKBooleanCompletionBlock)completion
{
    NSDictionary *parameters = @{@"user": username};
    
    return [self getPath:@"api/username_available.json" parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (completion)
        {
            completion([responseObject boolValue], nil);
        }
    }];
}

@end
