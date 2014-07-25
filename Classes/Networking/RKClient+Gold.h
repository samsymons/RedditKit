//
//  RKClient+Gold.h
//  Pods
//
//  Created by Sam Symons on 2014-07-24.
//
//

#import "RKClient.h"
#import "RKCompletionBlocks.h"

@class RKThing;

@interface RKClient (Gold)

/**
 Give reddit gold to a specific user for something they did.
 Requires that the current user has available creddits.
 
 @param thing The thing to give gold to. This is typically a comment.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)giveGoldToThing:(RKThing *)thing completion:(RKCompletionBlock)completion;

/**
 Give reddit gold to a specific user.
 Requires that the current user has available creddits.
 
 @param user The user to give gold to.
 @param duration The duration for which the user should receive gold. This is between 1 and 32 months.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)giveGoldToUser:(RKUser *)user duration:(NSUInteger)months completion:(RKCompletionBlock)completion;

/**
 Give reddit gold to a specific user.
 Requires that the current user has available creddits.
 
 @param username The username of the user to give gold to.
 @param duration The duration for which the user should receive gold. This is between 1 and 32 months.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)giveGoldToUserWithUsername:(NSString *)username duration:(NSUInteger)months completion:(RKCompletionBlock)completion;

@end
