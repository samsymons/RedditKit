// RKMultireddit.h
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

#import "Mantle.h"

typedef NS_ENUM(NSUInteger, RKMultiredditVisibility) {
    RKMultiredditVisibilityPublic,
    RKMultiredditVisibilityPrivate
};

@interface RKMultireddit : MTLModel <MTLJSONSerializing>

/**
 The multireddit's name.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 The multireddit's path, in the format of '/user/username/m/multiredditname'.
 */
@property (nonatomic, copy, readonly) NSString *path;

/**
 The multireddit's subreddits. The array contains NSStrings, each of which is a multireddit name.
 */
@property (nonatomic, strong, readonly) NSArray *subreddits;

/**
 Whether the current user is able to edit the multireddit.
 */
@property (nonatomic, assign, readonly, getter = isEditable) BOOL editable;

/**
 Whether the subreddit is private or public.
 */
@property (nonatomic, assign, readonly) RKMultiredditVisibility visibility;

/**
 The multireddit's creation date, in UTC.
 */
@property (nonatomic, strong, readonly) NSDate *created;

/**
 The username of the multireddit's owner.
 */
- (NSString *)username;

@end
