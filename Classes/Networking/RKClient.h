// RKClient.h
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

#import "AFHTTPSessionManager.h"
#import "RKCompletionBlocks.h"

extern NSString * const RKClientErrorDomain;

@class RKUser;

@interface RKClient : AFHTTPSessionManager

/**
 The currently signed in user.
 */
@property (nonatomic, strong, readonly) RKUser *currentUser;

/**
 The modhash value for the current user.
 */
@property (nonatomic, strong) NSString *modhash;

/**
 The session cookie value for the current user.
 */
@property (nonatomic, strong) NSString *sessionIdentifier;

/**
 How many requests are allowed before the rate limit is reset.
 
 @note This is only accurate at the time of the last request.
 */
@property (nonatomic, assign) NSUInteger rateLimitedRequestsRemaining;

/**
 How many requests have been made in this current rate limited period.
 
 @note This is only accurate at the time of the last request.
 */
@property (nonatomic, assign) NSUInteger rateLimitedRequestsUsed;

/**
 The time, in seconds, until the rate limit resets.
 
 @note This is only accurate at the time of the last request.
 */
@property (nonatomic, assign) NSTimeInterval timeUntilRateLimitReset;

/**
 The user agent for requests sent to reddit.
 */
@property (nonatomic, strong) NSString *userAgent;

+ (instancetype)sharedClient;

/**
 The URL to base HTTP requests on. Override this in an RKClient subclass to change the base URL.
 */
+ (NSURL *)APIBaseURL;

/**
 The URL to base HTTPS requests on. Override this in an RKClient subclass to change the base HTTPS URL.
 */
+ (NSURL *)APIBaseHTTPSURL;

/**
 Signs into reddit.
 
 @param username The user's username.
 @param password The user's password.
 @param completion The block to be executed upon completion of the request.
 */
- (NSURLSessionDataTask *)signInWithUsername:(NSString *)username password:(NSString *)password completion:(RKCompletionBlock)completion;

/**
 Updates the current user. This is useful for getting updated karma totals, or checking whether they have unread private messages.
 
 @param completion The block to be executed upon completion of the request.
 */
- (void)updateCurrentUserWithCompletion:(RKCompletionBlock)completion;

/**
 Whether or not there is a user currently signed in.
 
 @note This returns YES if there is an existing modhash value, but cannot guarantee its validity.
 */
- (BOOL)isSignedIn;

/**
 Signs the current user out.
 */
- (void)signOut;

@end
