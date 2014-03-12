// RKClient+Messages.h
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

#import "RKClient.h"
#import "RKCompletionBlocks.h"
#import "RKClient+Users.h"

typedef NS_ENUM(NSUInteger, RKMessageCategory) {
    RKMessageCategoryAll,
    RKMessageCategoryUnread,
    RKMessageCategoryMessages,
    RKMessageCategorySent,
    RKMessageCategoryModerator,
    RKMessageCategoryCommentReplies,
    RKMessageCategoryPostReplies,
    RKMessageCategoryUsernameMentions
};

@class RKUser;
@class RKMessage;
@class RKPagination;

@interface RKClient (Messages)

#pragma mark - Fetching Messages

/**
 Returns messages from the current user's inbox.
 
 @param pagination Pagination information for the request. Uses default information if nil.
 @param read Mark the messages as read on reddit.
 @param completion An optional block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)messageInboxWithPagination:(RKPagination *)pagination markRead:(BOOL)read completion:(RKListingCompletionBlock)completion;

/**
 Returns unread messages from the current user's inbox.
 
 @param pagination Pagination information for the request. Uses default information if nil.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)unreadMessagesWithPagination:(RKPagination *)pagination markRead:(BOOL)read completion:(RKListingCompletionBlock)completion;

/**
 Returns the current user's sent messages.
 
 @param pagination Pagination information for the request. Uses default information if nil.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)sentMessagesWithPagination:(RKPagination *)pagination markRead:(BOOL)read completion:(RKListingCompletionBlock)completion;

/**
 Returns messages from a specific category.
 
 @param category The category from which to fetch messages.
 @param pagination Pagination information for the request. Uses default information if nil.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)messagesInCategory:(RKMessageCategory)category pagination:(RKPagination *)pagination markRead:(BOOL)read completion:(RKListingCompletionBlock)completion;

#pragma mark - Marking As Read/Unread

/**
 Marks a message as read.
 
 @param message The message to be marked as read.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)markMessageAsRead:(RKMessage *)message completion:(RKCompletionBlock)completion;

/**
 Marks an array of messages as read.
 
 @param messages The array of messages to be marked as read. The array must only contain RKMessage objects.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)markMessageArrayAsRead:(NSArray *)messages completion:(RKCompletionBlock)completion;

/**
 Marks a message as read.
 
 @param fullName The full name of the message to be marked as read.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)markMessageWithFullNameAsRead:(NSString *)fullName completion:(RKCompletionBlock)completion;

/**
 Marks a message as unread.
 
 @param message The message to be marked as unread.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)markMessageAsUnread:(RKMessage *)message completion:(RKCompletionBlock)completion;

/**
 Marks an array of messages as unread.
 
 @param messages The array of messages to be marked as unread. The array must only contain RKMessage objects.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)markMessageArrayAsUnread:(NSArray *)messages completion:(RKCompletionBlock)completion;

/**
 Marks a message as unread.
 
 @param fullName The full name of the message to be marked as unread.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)markMessageWithFullNameAsUnread:(NSString *)fullName completion:(RKCompletionBlock)completion;

#pragma mark - Sending Messages

/**
 Sends a message to another reddit user.
 
 @param message The message object to send.
 @param subject The subject of the message.
 @param recipient The username of the message's recipient.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)sendMessage:(NSString *)message subject:(NSString *)subject recipient:(NSString *)recipient completion:(RKCompletionBlock)completion;

/**
 Sends a message to another reddit user.
 
 @param message The message object to send.
 @param subject The subject of the message.
 @param recipient The username of the message's recipient.
 @param captchaIdentifier The identifier of the captcha as determined by reddit.
 @param captchaValue The value of the captcha as determined by the user.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)sendMessage:(NSString *)message subject:(NSString *)subject recipient:(NSString *)recipient captchaIdentifier:(NSString *)captchaIdentifier captchaValue:(NSString *)captchaValue completion:(RKCompletionBlock)completion;

#pragma mark - Blocking Users

/**
 Blocks the author of a private message from being able to send private messages to the current user.
 Users cannot be blocked based on username, as reddit only allows you to block those who have actively harassed you (thus leaving a message in your inbox).
 
 @param message The message whose author should be blocked.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)blockAuthorOfMessage:(RKMessage *)message completion:(RKCompletionBlock)completion;

/**
 Blocks the author of a private message from being able to send private messages to the current user.
 Users cannot be blocked based on username, as reddit only allows you to block those who have actively harassed you (thus leaving a message in your inbox).
 
 @param fullName The full name of the message whose author should be blocked.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)blockAuthorOfMessageWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion;

/**
 Unblocks a user, allowing them to send private messages to you once more.
 
 @param user The user to unblock.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unblockUser:(RKUser *)user completion:(RKCompletionBlock)completion;

/**
 Unblocks a user, allowing them to send private messages to you once more.
 
 @param username The username of the user to unblock.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unblockUserWithUsername:(NSString *)username completion:(RKCompletionBlock)completion;

@end
