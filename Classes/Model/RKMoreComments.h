//
//  RKMoreComments.h
//  Pods
//
//  Created by Sam Symons on 2014-09-02.
//
//

#import "RKThing.h"

@interface RKMoreComments : RKThing

/**
 The number of comments referenced by this object.
 */
@property (nonatomic, assign, readonly) NSUInteger count;

/**
 The full name of this object's parent, which is an RKComment object.
 */
@property (nonatomic, strong, readonly) NSString *parentFullName;

/**
 The identifiers of the comments referenced by this object.
 */
@property (nonatomic, strong, readonly) NSArray *childIdentifiers;

@end
