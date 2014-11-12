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
 Array of children comment identifiers represented by this RKMoreComment object.
 */
@property (nonatomic, strong, readonly) NSArray *children;

/**
 The total number of comments represented by all the children comments (and children's children's comments, etc. ad infinitum).
 */
@property (nonatomic, assign, readonly) NSInteger count;

/**
 The identifier of the comment's parent, if it has one. (It will only have one if the comment is a reply.)
 */
@property (nonatomic, copy, readonly) NSString *parentID;

@end
