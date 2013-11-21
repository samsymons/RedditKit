// RDKClient+Messages.m
//
// Copyright (c) 2013 Sam Symons (http://samsymons.com/)
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

#import "RDKClient+Messages.h"
#import "RDKClient+Requests.h"
#import "RDKUser.h"
#import "RDKMessage.h"
#import "RDKPagination.h"

NSString * NSStringFromMessageCategory(RDKMessageCategory messageCategory)
{
    switch (messageCategory)
    {
        case RDKMessageCategoryAll:
            return @"inbox";
            break;
        case RDKMessageCategoryUnread:
            return @"unread";
            break;
        case RDKMessageCategoryMessages:
            return @"messages";
            break;
        case RDKMessageCategorySent:
            return @"sent";
            break;
        case RDKMessageCategoryModerator:
            return @"moderator";
            break;
        case RDKMessageCategoryCommentReplies:
            return @"comments";
            break;
        case RDKMessageCategoryPostReplies:
            return @"selfreply";
            break;
        case RDKMessageCategoryUsernameMentions:
            return @"mentions";
            break;
        default:
            return @"inbox";
            break;
	}
}

@implementation RDKClient (Messages)

#pragma mark - Retrieving Messages

- (NSURLSessionDataTask *)messageInboxWithPagination:(RDKPagination *)pagination markRead:(BOOL)read completion:(RDKListingCompletionBlock)completion
{
    return [self messagesInCategory:RDKMessageCategoryAll pagination:pagination markRead:read completion:completion];
}

- (NSURLSessionDataTask *)unreadMessagesWithPagination:(RDKPagination *)pagination markRead:(BOOL)read completion:(RDKListingCompletionBlock)completion
{
    return [self messagesInCategory:RDKMessageCategoryUnread pagination:pagination markRead:read completion:completion];
}

- (NSURLSessionDataTask *)sentMessagesWithPagination:(RDKPagination *)pagination markRead:(BOOL)read completion:(RDKListingCompletionBlock)completion
{
    return [self messagesInCategory:RDKMessageCategorySent pagination:pagination markRead:read completion:completion];
}

- (NSURLSessionDataTask *)messagesInCategory:(RDKMessageCategory)category pagination:(RDKPagination *)pagination markRead:(BOOL)read completion:(RDKListingCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"message/%@.json", NSStringFromMessageCategory(category)];
    
	return [self listingTaskWithPath:path parameters:nil pagination:pagination completion:completion];
}

#pragma mark - Marking As Read/Unread

- (NSURLSessionDataTask *)markMessageAsRead:(RDKMessage *)message completion:(RDKCompletionBlock)completion
{
    return [self markMessageWithFullNameAsRead:message.fullName completion:completion];
}

- (NSURLSessionDataTask *)markMessageWithFullNameAsRead:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    return [self basicPostTaskWithPath:@"api/read_message" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)markMessageAsUnread:(RDKMessage *)message completion:(RDKCompletionBlock)completion
{
    return [self markMessageWithFullNameAsUnread:message.fullName completion:completion];
}

- (NSURLSessionDataTask *)markMessageWithFullNameAsUnread:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    return [self basicPostTaskWithPath:@"api/unread_message" parameters:parameters completion:completion];
}

#pragma mark - Sending Messages

- (NSURLSessionDataTask *)sendMessage:(NSString *)message subject:(NSString *)subject recipient:(NSString *)recipient completion:(RDKCompletionBlock)completion
{
    return [self sendMessage:message subject:subject recipient:recipient captchaIdentifier:nil captchaValue:nil completion:completion];
}

- (NSURLSessionDataTask *)sendMessage:(NSString *)message subject:(NSString *)subject recipient:(NSString *)recipient captchaIdentifier:(NSString *)captchaIdentifier captchaValue:(NSString *)captchaValue completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(message);
    NSParameterAssert(recipient);
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    parameters[@"to"] = recipient;
    parameters[@"text"] = message;
    parameters[@"subject"] = subject;
    
    if (captchaIdentifier && captchaValue)
    {
        parameters[@"iden"] = captchaIdentifier;
        parameters[@"captcha"] = captchaValue;
    }
    
    return [self basicPostTaskWithPath:@"api/compose" parameters:[parameters copy] completion:completion];
}

#pragma mark - Blocking

- (NSURLSessionDataTask *)blockAuthorOfMessage:(RDKMessage *)message completion:(RDKCompletionBlock)completion
{
    return [self blockAuthorOfMessageWithFullName:message.fullName completion:completion];
}

- (NSURLSessionDataTask *)blockAuthorOfMessageWithFullName:(NSString *)fullName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/block" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)unblockUser:(RDKUser *)user completion:(RDKCompletionBlock)completion
{
    return [self unblockUserWithUsername:user.username completion:completion];
}

- (NSURLSessionDataTask *)unblockUserWithUsername:(NSString *)username completion:(RDKCompletionBlock)completion
{
    return [self unfriendTaskWithContainer:self.currentUser.fullName subredditName:nil name:username type:@"enemy" completion:completion];
}

@end
