// RKUser.h
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

@interface RKUser : RKCreated

/**
 The user's reddit username.
 */
@property (nonatomic, strong, readonly) NSString *username;

/**
 The user's total comment karma.
 */
@property (nonatomic, assign, readonly) NSInteger commentKarma;

/**
 The user's total link karma.
 */
@property (nonatomic, assign, readonly) NSInteger linkKarma;

/**
 Whether the user has unread mail.
 */
@property (nonatomic, assign, readonly) BOOL hasMail;

/**
 Whether the user has unread moderator mail.
 */
@property (nonatomic, assign, readonly) BOOL hasModeratorMail;

/**
 Whether the user has verified their email address.
 */
@property (nonatomic, assign, readonly) BOOL hasVerifiedEmailAddress;

/**
 Whether the user has reddit gold.
 */
@property (nonatomic, assign, readonly, getter = isGold) BOOL gold;

/**
 Whether the user is a friend of the current user.
 */
@property (nonatomic, assign, readonly, getter = isFriend) BOOL friend;

/**
 Whether the user is a moderator of a subreddit.
 */
@property (nonatomic, assign, readonly, getter = isMod) BOOL mod;

/**
 Whether the user has indicated that they are over 18.
 */
@property (nonatomic, assign, readonly, getter = isOver18) BOOL over18;

@end
