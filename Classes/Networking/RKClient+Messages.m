// RKClient+Messages.m
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

#import "RKClient+Messages.h"
#import "RKClient+Requests.h"
#import "RKUser.h"
#import "RKMessage.h"
#import "RKPagination.h"

NSString * RKStringFromMessageCategory(RKMessageCategory messageCategory)
{
    switch (messageCategory)
    {
        case RKMessageCategoryAll:
            return @"inbox";
            break;
        case RKMessageCategoryUnread:
            return @"unread";
            break;
        case RKMessageCategoryMessages:
            return @"messages";
            break;
        case RKMessageCategorySent:
            return @"sent";
            break;
        case RKMessageCategoryModerator:
            return @"moderator";
            break;
        case RKMessageCategoryCommentReplies:
            return @"comments";
            break;
        case RKMessageCategoryPostReplies:
            return @"selfreply";
            break;
        case RKMessageCategoryUsernameMentions:
            return @"mentions";
            break;
        default:
            return @"inbox";
            break;
	}
}

@implementation RKClient (Messages)

#pragma mark - Retrieving Messages

- (NSURLSessionDataTask *)messageInboxWithPagination:(RKPagination *)pagination markRead:(BOOL)read completion:(RKListingCompletionBlock)completion
{
    return [self messagesInCategory:RKMessageCategoryAll pagination:pagination markRead:read completion:completion];
}

- (NSURLSessionDataTask *)unreadMessagesWithPagination:(RKPagination *)pagination markRead:(BOOL)read completion:(RKListingCompletionBlock)completion
{
    return [self messagesInCategory:RKMessageCategoryUnread pagination:pagination markRead:read completion:completion];
}

- (NSURLSessionDataTask *)sentMessagesWithPagination:(RKPagination *)pagination markRead:(BOOL)read completion:(RKListingCompletionBlock)completion
{
    return [self messagesInCategory:RKMessageCategorySent pagination:pagination markRead:read completion:completion];
}

- (NSURLSessionDataTask *)messagesInCategory:(RKMessageCategory)category pagination:(RKPagination *)pagination markRead:(BOOL)read completion:(RKListingCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"message/%@.json", RKStringFromMessageCategory(category)];
    NSDictionary *parameters = @{@"mark": (read) ? @"true" : @"false" };
    
	return [self listingTaskWithPath:path parameters:parameters pagination:pagination completion:completion];
}

#pragma mark - Marking As Read/Unread

- (NSURLSessionDataTask *)markMessageAsRead:(RKMessage *)message completion:(RKCompletionBlock)completion
{
    return [self markMessageWithFullNameAsRead:message.fullName completion:completion];
}

- (NSURLSessionDataTask *)markMessageArrayAsRead:(NSArray *)messages completion:(RKCompletionBlock)completion
{
    NSParameterAssert(messages);
    
    [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSAssert([obj isKindOfClass:[RKMessage class]], @"Object contained in message array must be of type RKMessage");
    }];
    
    NSArray *things = [messages valueForKey:@"fullName"];
    NSDictionary *parameters = @{@"id": [things componentsJoinedByString:@","]};
    return [self basicPostTaskWithPath:@"api/read_message" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)markMessageWithFullNameAsRead:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    return [self basicPostTaskWithPath:@"api/read_message" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)markMessageAsUnread:(RKMessage *)message completion:(RKCompletionBlock)completion
{
    return [self markMessageWithFullNameAsUnread:message.fullName completion:completion];
}

- (NSURLSessionDataTask *)markMessageArrayAsUnread:(NSArray *)messages completion:(RKCompletionBlock)completion
{
    NSParameterAssert(messages);
    
    [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSAssert([obj isKindOfClass:[RKMessage class]], @"Object contained in message array must be of type RKMessage");
    }];
    
    NSArray *things = [messages valueForKey:@"fullName"];
    NSDictionary *parameters = @{@"id": [things componentsJoinedByString:@","]};
    return [self basicPostTaskWithPath:@"api/unread_message" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)markMessageWithFullNameAsUnread:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    return [self basicPostTaskWithPath:@"api/unread_message" parameters:parameters completion:completion];
}

#pragma mark - Sending Messages

- (NSURLSessionDataTask *)sendMessage:(NSString *)message subject:(NSString *)subject recipient:(NSString *)recipient completion:(RKCompletionBlock)completion
{
    return [self sendMessage:message subject:subject recipient:recipient captchaIdentifier:nil captchaValue:nil completion:completion];
}

- (NSURLSessionDataTask *)sendMessage:(NSString *)message subject:(NSString *)subject recipient:(NSString *)recipient captchaIdentifier:(NSString *)captchaIdentifier captchaValue:(NSString *)captchaValue completion:(RKCompletionBlock)completion
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

- (NSURLSessionDataTask *)blockAuthorOfMessage:(RKMessage *)message completion:(RKCompletionBlock)completion
{
    return [self blockAuthorOfMessageWithFullName:message.fullName completion:completion];
}

- (NSURLSessionDataTask *)blockAuthorOfMessageWithFullName:(NSString *)fullName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    
    NSDictionary *parameters = @{@"id": fullName};
    
    return [self basicPostTaskWithPath:@"api/block" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)unblockUser:(RKUser *)user completion:(RKCompletionBlock)completion
{
    return [self unblockUserWithUsername:user.username completion:completion];
}

- (NSURLSessionDataTask *)unblockUserWithUsername:(NSString *)username completion:(RKCompletionBlock)completion
{
    return [self unfriendTaskWithContainer:self.currentUser.fullName subredditName:nil name:username type:@"enemy" completion:completion];
}

@end
