//
//  RKMoreComments.h
//  Pods
//
//  Created by Sam Symons on 2014-09-02.
//
//

#import "RKThing.h"

@interface RKMoreComments : RKThing

@property (nonatomic, assign, readonly) NSUInteger count;

@property (nonatomic, strong, readonly) NSString *parentFullName;

@property (nonatomic, strong, readonly) NSArray *childIdentifiers;

@end
