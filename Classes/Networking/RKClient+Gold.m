//
//  RKClient+Gold.m
//  Pods
//
//  Created by Sam Symons on 2014-07-24.
//
//

#import "RKClient+Gold.h"
#import "RKClient+Requests.h"
#import "RKThing.h"
#import "RKUser.h"

@implementation RKClient (Gold)

- (NSURLSessionDataTask *)giveGoldToThing:(RKThing *)thing completion:(RKCompletionBlock)completion
{
    NSParameterAssert(thing);
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/gold/gild/%@", thing.fullName];
    return [self basicPostTaskWithPath:path parameters:@{ @"fullname": thing.fullName } completion:completion];
}

- (NSURLSessionDataTask *)giveGoldToUser:(RKUser *)user duration:(NSUInteger)months completion:(RKCompletionBlock)completion
{
    return [self giveGoldToUserWithUsername:user.username duration:months completion:completion];
}

- (NSURLSessionDataTask *)giveGoldToUserWithUsername:(NSString *)username duration:(NSUInteger)months completion:(RKCompletionBlock)completion
{
    NSParameterAssert(username);
    
    NSUInteger duration = MAX(1, months);
    duration = MIN(32, months);
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/gold/give/%@", username];
    return [self basicPostTaskWithPath:path parameters:@{ @"username": username, @"months": @(duration) } completion:completion];
}

@end
