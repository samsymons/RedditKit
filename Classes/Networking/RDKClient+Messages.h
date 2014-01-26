// RDKClient+Messages.h
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

#import "RDKClient.h"
#import "RDKCompletionBlocks.h"
#import "RDKClient+Users.h"

typedef NS_ENUM(NSUInteger, RDKMessageCategory) {
    RDKMessageCategoryAll,
    RDKMessageCategoryUnread,
    RDKMessageCategoryMessages,
    RDKMessageCategorySent,
    RDKMessageCategoryModerator,
    RDKMessageCategoryCommentReplies,
    RDKMessageCategoryPostReplies,
    RDKMessageCategoryUsernameMentions
};

@class RDKUser;
@class RDKMessage;
@class RDKPagination;

@interface RDKClient (Messages)

#pragma mark - Fetching Messages

/**
 Returns messages from the current user's inbox.
 
 @param pagination Pagination information for the request. Uses default information if nil.
 @param read Mark the messages as read on reddit.
 @param completion An optional block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)messageInboxWithPagination:(RDKPagination *)pagination markRead:(BOOL)read completion:(RDKListingCompletionBlock)completion;

/**
 Returns unread messages from the current user's inbox.
 
 @param pagination Pagination information for the request. Uses default information if nil.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)unreadMessagesWithPagination:(RDKPagination *)pagination markRead:(BOOL)read completion:(RDKListingCompletionBlock)completion;

/**
 Returns the current user's sent messages.
 
 @param pagination Pagination information for the request. Uses default information if nil.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)sentMessagesWithPagination:(RDKPagination *)pagination markRead:(BOOL)read completion:(RDKListingCompletionBlock)completion;

/**
 Returns messages from a specific category.
 
 @param category The category from which to fetch messages.
 @param pagination Pagination information for the request. Uses default information if nil.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)messagesInCategory:(RDKMessageCategory)category pagination:(RDKPagination *)pagination markRead:(BOOL)read completion:(RDKListingCompletionBlock)completion;

#pragma mark - Marking As Read/Unread

/**
 Marks a message as read.
 
 @param message The message to be marked as read.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)markMessageAsRead:(RDKMessage *)message completion:(RDKCompletionBlock)completion;

/**
 Marks a message as read.
 
 @param fullName The full name of the message to be marked as read.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)markMessageWithFullNameAsRead:(NSString *)fullName completion:(RDKCompletionBlock)completion;

/**
 Marks a message as unread.
 
 @param message The message to be marked as unread.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)markMessageAsUnread:(RDKMessage *)message completion:(RDKCompletionBlock)completion;

/**
 Marks a message as unread.
 
 @param fullName The full name of the message to be marked as unread.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)markMessageWithFullNameAsUnread:(NSString *)fullName completion:(RDKCompletionBlock)completion;

#pragma mark - Sending Messages

/**
 Sends a message to another reddit user.
 
 @param message The message object to send.
 @param subject The subject of the message.
 @param recipient The username of the message's recipient.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)sendMessage:(NSString *)message subject:(NSString *)subject recipient:(NSString *)recipient completion:(RDKCompletionBlock)completion;

/**
 Sends a message to another reddit user.
 
 @param message The message object to send.
 @param subject The subject of the message.
 @param recipient The username of the message's recipient.
 @param captchaIdentifier The identifier of the captcha as determined by reddit.
 @param captchaValue The value of the captcha as determined by the user.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)sendMessage:(NSString *)message subject:(NSString *)subject recipient:(NSString *)recipient captchaIdentifier:(NSString *)captchaIdentifier captchaValue:(NSString *)captchaValue completion:(RDKCompletionBlock)completion;

#pragma mark - Blocking Users

/**
 Blocks the author of a private message from being able to send private messages to the current user.
 Users cannot be blocked based on username, as reddit only allows you to block those who have actively harassed you (thus leaving a message in your inbox).
 
 @param message The message whose author should be blocked.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)blockAuthorOfMessage:(RDKMessage *)message completion:(RDKCompletionBlock)completion;

/**
 Blocks the author of a private message from being able to send private messages to the current user.
 Users cannot be blocked based on username, as reddit only allows you to block those who have actively harassed you (thus leaving a message in your inbox).
 
 @param fullName The full name of the message whose author should be blocked.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)blockAuthorOfMessageWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion;

/**
 Unblocks a user, allowing them to send private messages to you once more.
 
 @param user The user to unblock.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unblockUser:(RDKUser *)user completion:(RDKCompletionBlock)completion;

/**
 Unblocks a user, allowing them to send private messages to you once more.
 
 @param username The username of the user to unblock.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unblockUserWithUsername:(NSString *)username completion:(RDKCompletionBlock)completion;

@end
