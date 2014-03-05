// RKMessage.h
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

typedef NS_ENUM(NSUInteger, RKMessageType) {
	RKMessageTypeSent,
	RKMessageTypeReceived
};

@interface RKMessage : RKCreated

/**
 Whether the message is unread.
 */
@property (nonatomic, assign, readonly, getter = isUnread) BOOL unread;

/**
 The author of the message.
 */
@property (nonatomic, copy, readonly) NSString *author;

/**
 The body of the message.
 */
@property (nonatomic, copy, readonly) NSString *messageBody;

/**
 The body of the message as HTML.
 */
@property (nonatomic, copy, readonly) NSString *messageBodyHTML;

/**
 The recipient of the message.
 */
@property (nonatomic, copy ,readonly) NSString *recipient;

/**
 The subject of the message.
 */
@property (nonatomic, copy, readonly) NSString *subject;

/**
 The replies to the comment, if any.
 */
@property (nonatomic, strong, readonly) NSArray *replies;

/**
 The type of the message, 
 */
@property (nonatomic, assign, readonly) RKMessageType type;

/**
 The first message.
 */
@property (nonatomic, copy, readonly) NSString *firstMessage;

/**
 The full name of the first message.
 */
@property (nonatomic, copy, readonly) NSString *firstMessageFullName;

/**
 Whether the message is a comment reply.
 */
@property (nonatomic, assign, readonly, getter = isCommentReply) BOOL commentReply;

@end

#pragma mark -

@interface RKCommentReplyMessage : RKMessage

/**
 The title of the link this comment reply was posted on.
 */
@property (nonatomic, copy, readonly) NSString *linkTitle;

/**
 Whether the current user has upvoted the reply.
 */
@property (nonatomic, assign, readonly) BOOL likes;

/**
 A context path for the message, showing the comment and up to three comments before it.
 */
@property (nonatomic, copy, readonly) NSString *context;

/**
 The subreddit the reply was sent in.
 */
@property (nonatomic, copy, readonly) NSString *subreddit;

@end
