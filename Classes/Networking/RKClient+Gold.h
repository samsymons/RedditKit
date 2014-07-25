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

- (NSURLSessionDataTask *)giveGoldToThing:(RKThing *)thing completion:(RKCompletionBlock)completion;

- (NSURLSessionDataTask *)giveGoldToUser:(RKUser *)user duration:(NSUInteger)months completion:(RKCompletionBlock)completion;

- (NSURLSessionDataTask *)giveGoldToUserWithUsername:(NSString *)username duration:(NSUInteger)months completion:(RKCompletionBlock)completion;

@end
