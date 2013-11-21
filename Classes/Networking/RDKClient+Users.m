// RDKClient+Users.m
//
// Copyright (c) 2013 Sam Symons (http://samsymons.com/)
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

#import "RDKClient+Users.h"
#import "RDKObjectBuilder.h"
#import "RDKClient+Requests.h"
#import "RDKClient+Errors.h"
#import "RDKUser.h"
#import "RDKSubreddit.h"
#import "RDKPagination.h"

NSString * NSStringFromUserContentCategory(RDKUserContentCategory category)
{
    switch (category)
    {
        case RDKUserContentCategoryOverview:
            return @"overview";
            break;
        case RDKUserContentCategoryComments:
            return @"comments";
            break;
        case RDKUserContentCategorySubmissions:
            return @"submitted";
            break;
        case RDKUserContentCategoryGilded:
            return @"gilded";
            break;
        case RDKUserContentCategoryLiked:
            return @"liked";
            break;
        case RDKUserContentCategoryDisliked:
            return @"disliked";
            break;
        default:
            return @"overview";
            break;
    }
}

NSString * NSStringFromSubscribedSubredditCategory(RDKSubscribedSubredditCategory category)
{
    switch (category)
    {
        case RDKSubscribedSubredditCategorySubscriber:
            return @"subscriber";
            break;
        case RDKSubscribedSubredditCategoryContributor:
            return @"contributor";
            break;
        case RDKSubscribedSubredditCategoryModerator:
            return @"moderator";
            break;
        default:
            return @"subscriber";
            break;
    }
}

@implementation RDKClient (Users)

- (NSURLSessionDataTask *)currentUserWithCompletion:(RDKObjectCompletionBlock)completion
{
    return [self getPath:[[self class] userInformationURLPath] parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (responseObject)
        {
            RDKUser *account = [RDKObjectBuilder objectFromJSON:responseObject];
            
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

- (NSURLSessionDataTask *)user:(RDKUser *)user completion:(RDKObjectCompletionBlock)completion
{
    return [self userWithUsername:user.username completion:completion];
}

- (NSURLSessionDataTask *)userWithUsername:(NSString *)username completion:(RDKObjectCompletionBlock)completion
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
            RDKUser *account = [RDKObjectBuilder objectFromJSON:responseObject];
            completion(account, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)subscribedSubredditsWithCompletion:(RDKArrayCompletionBlock)completion
{
    return [self subscribedSubredditsInCategory:RDKSubscribedSubredditCategorySubscriber completion:completion];
}

- (NSURLSessionDataTask *)subscribedSubredditsInCategory:(RDKSubscribedSubredditCategory)category completion:(RDKArrayCompletionBlock)completion
{
    NSDictionary *parameters = @{@"un": @"samsymons"};
    NSString *path = [NSString stringWithFormat:@"subreddits/mine/%@.json", NSStringFromSubscribedSubredditCategory(category)];
    
    return [self getPath:path parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion) return;
        
        if (responseObject)
        {
            // A crude check to see if we have been redirected to the login page:
            
            NSString *path = [[response URL] path];
            NSRange range = [path rangeOfString:@"login"];
            
            if (range.location != NSNotFound)
            {
                completion(nil, [RDKClient authenticationRequiredError]);
                return;
            }
            
            // Parse the response:
            
            NSArray *subredditsJSON = responseObject[@"data"][@"children"];
            NSMutableArray *subredditObjects = [[NSMutableArray alloc] initWithCapacity:[subredditsJSON count]];
            
            for (NSDictionary *subredditJSON in subredditsJSON)
            {
                NSError *mantleError = nil;
                RDKSubreddit *subreddit = [MTLJSONAdapter modelOfClass:[RDKSubreddit class] fromJSONDictionary:subredditJSON error:&mantleError];
                
                if (!mantleError)
                {
                    [subredditObjects addObject:subreddit];
                }
            }
            
            completion([subredditObjects copy], nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)deleteCurrentUserWithReason:(NSString *)reason currentPassword:(NSString *)currentPassword completion:(RDKCompletionBlock)completion
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

#pragma mark - User Content

- (NSURLSessionDataTask *)overviewOfUser:(RDKUser *)user pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self overviewOfUserWithUsername:user.username pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)overviewOfUserWithUsername:(NSString *)username pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self contentForUserWithUsername:username category:RDKUserContentCategoryOverview pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)commentsByUser:(RDKUser *)user pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self commentsByUserWithUsername:user.username pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)commentsByUserWithUsername:(NSString *)username pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self contentForUserWithUsername:username category:RDKUserContentCategoryComments pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)submissionsByUser:(RDKUser *)user pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self submissionsByUserWithUsername:user.username pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)submissionsByUserWithUsername:(NSString *)username pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self contentForUserWithUsername:username category:RDKUserContentCategorySubmissions pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)contentForUser:(RDKUser *)user category:(RDKUserContentCategory)category pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    return [self contentForUserWithUsername:user.username category:category pagination:pagination completion:completion];
}

- (NSURLSessionDataTask *)contentForUserWithUsername:(NSString *)username category:(RDKUserContentCategory)category pagination:(RDKPagination *)pagination completion:(RDKListingCompletionBlock)completion
{
    NSParameterAssert(username);
    
    NSString *path = [NSString stringWithFormat:@"user/%@/%@.json", username, NSStringFromUserContentCategory(category)];
    
    return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

#pragma mark - Friends

- (NSURLSessionDataTask *)friendsWithCompletion:(RDKArrayCompletionBlock)completion
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
                completion(nil, [RDKClient authenticationRequiredError]);
                return;
            }
            
            NSDictionary *friendsListing = [responseObject firstObject];
            NSArray *friends = friendsListing[@"data"][@"children"];
            
            completion(friends, nil);
        }
    }];
}

- (NSURLSessionDataTask *)submissionsByFriendsWithCompletion:(RDKListingCompletionBlock)completion
{
    return [self listingTaskWithPath:@"r/friends.json" parameters:nil pagination:nil completion:completion];
}

- (NSURLSessionDataTask *)addFriend:(RDKUser *)user completion:(RDKCompletionBlock)completion
{
    return [self addFriendWithUsername:user.username completion:completion];
}

- (NSURLSessionDataTask *)addFriendWithUsername:(NSString *)username completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(username);
    
    return [self friendTaskWithContainer:self.currentUser.fullName subredditName:nil name:username type:@"friend" completion:completion];
}

- (NSURLSessionDataTask *)removeFriend:(RDKUser *)account completion:(RDKCompletionBlock)completion
{
    return [self removeFriendWithUsername:account.username completion:completion];
}

- (NSURLSessionDataTask *)removeFriendWithUsername:(NSString *)username completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(username);
    
    return [self unfriendTaskWithContainer:self.currentUser.fullName subredditName:nil name:username type:@"friend" completion:completion];
}

#pragma mark - Registration

- (NSURLSessionDataTask *)checkAvailabilityOfUsername:(NSString *)username completion:(RDKBooleanCompletionBlock)completion
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
