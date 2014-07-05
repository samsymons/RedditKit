// RKClient+Errors.h
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

@interface RKClient (Errors)

extern const NSInteger RKClientErrorAuthenticationFailed;

extern const NSInteger RKClientErrorInvalidCaptcha;
extern const NSInteger RKClientErrorInvalidCSSClassName;
extern const NSInteger RKClientErrorInvalidCredentials;
extern const NSInteger RKClientErrorRateLimited;
extern const NSInteger RKClientErrorTooManyFlairClassNames;
extern const NSInteger RKClientErrorArchived;
extern const NSInteger RKClientErrorInvalidSubreddit;

extern const NSInteger RKClientErrorInvalidMultiredditName;
extern const NSInteger RKClientErrorPermissionDenied;
extern const NSInteger RKClientErrorConflict;
extern const NSInteger RKClientErrorNotFound;

extern const NSInteger RKClientErrorInternalServerError;
extern const NSInteger RKClientErrorBadGateway;
extern const NSInteger RKClientErrorServiceUnavailable;
extern const NSInteger RKClientErrorTimedOut;

/**
 Returns any errors found in a response.
 */
+ (NSError *)errorFromResponse:(NSHTTPURLResponse *)response responseString:(NSString *)responseString;

+ (NSError *)errorFromResponseObject:(id)responseObject;

/**
 Returns an error that occurs when there is no user signed in and an attempt is made to access a resouce which requires authentication.
 For example, this error occurs when attempting to retrieve a list of subscribed subreddits without being signed in.
 */
+ (NSError *)authenticationRequiredError;

/**
 Returns an error that occurs when the user filled out a CAPTCHA incorrectly, or provided an invalid CAPTCHA identifier.
 */
+ (NSError *)invalidCaptchaError;

/**
 Returns an error that occurs when the user included an invalid CSS class name.
 */
+ (NSError *)invalidCSSClassNameError;

/**
 Returns an error that occurs when the user attempts to sign in but either the username or password were incorrect.
 */
+ (NSError *)invalidCredentialsError;

/**
 Returns an error that occurs when you provide an invalid subreddit name.
 */
+ (NSError *)invalidSubredditError;

/**
 Returns an error that occurs when the user is rate limited.
 */
+ (NSError *)rateLimitedError;

/**
 Returns an error that occurs when the user provides too many flair class names.
 */
+ (NSError *)tooManyFlairClassNamesError;

/**
 Returns an error that occurs when the user attempts to interact with an object that has been archived.
 */
+ (NSError *)archivedError;

/**
 Returns an error that occurs when you provide an invalid multireddit name.
 */
+ (NSError *)invalidMultiredditNameError;

/**
 Returns an error that occurs when the user was denied access to a particular resource, such as a subreddit.
 */
+ (NSError *)permissionDeniedError;

/**
 Returns an error that occurs when a conflict was attempted.
 */
+ (NSError *)conflictError;

/**
 Returns an error that occurs when trying to retrieve content that could not be found.
 
 @example This happens when trying to retrive the info of a subreddit which does not exist.
 */
+ (NSError *)notFoundError;

/**
 Returns an error that occurs when the reddit servers are unavailable.
 */
+ (NSError *)serviceUnavailableError;

/**
 Returns an error that occurs when the reddit servers timed out.
 */
+ (NSError *)timedOutError;

@end
