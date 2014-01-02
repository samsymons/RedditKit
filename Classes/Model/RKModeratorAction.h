// RKModeratorAction.h
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

#import "RKCreated.h"

@interface RKModeratorAction : RKCreated

/**
 The action taken by the moderator.
 */
@property (nonatomic, strong) NSString *action;

/**
 A human-readable string providing more details about the action.
 */
@property (nonatomic, strong) NSString *details;

/**
 The username of the moderator who performed the action.
 */
@property (nonatomic, strong) NSString *moderatorUsername;

/**
 The identifier (not full name) of the moderator who performed the action.
 */
@property (nonatomic, strong) NSString *moderatorIdentifier;

/**
 The name of the subreddit in which the action was performed.
 */
@property (nonatomic, strong) NSString *subredditName;

/**
 The identifier (not full name) of the subreddit in which the action was performed.
 */
@property (nonatomic, strong) NSString *subredditIdentifier;

/**
 The full name of the action's target.
 For example, if the action taken was to remove a link, the target would be the link's full name.
 */
@property (nonatomic, strong) NSString *targetFullName;

@end
