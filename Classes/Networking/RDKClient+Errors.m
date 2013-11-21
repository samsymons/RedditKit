// RDKClient+Errors.m
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

#import "RDKClient+Errors.h"

@implementation RDKClient (Errors)

const NSInteger RDKClientErrorAuthenticationFailed = 1;

const NSInteger RDKClientErrorInvalidCaptcha = 201;
const NSInteger RDKClientErrorInvalidCSSClassName = 202;
const NSInteger RDKClientErrorInvalidCredentials = 203;
const NSInteger RDKClientErrorRateLimited = 204;
const NSInteger RDKClientErrorTooManyFlairClassNames = 205;
const NSInteger RDKClientErrorArchived = 206;

const NSInteger RDKClientErrorInvalidMultiredditName = 401;
const NSInteger RDKClientErrorPermissionDenied = 401;
const NSInteger RDKClientErrorConflict = 401;

const NSInteger RDKClientErrorInternalServerError = 501;
const NSInteger RDKClientErrorBadGateway = 502;
const NSInteger RDKClientErrorServiceUnavailable = 503;
const NSInteger RDKClientErrorTimedOut = 504;

+ (NSError *)errorFromResponse:(NSHTTPURLResponse *)response responseString:(NSString *)responseString
{
    NSParameterAssert(response);
    NSParameterAssert(responseString);
    
    switch (response.statusCode)
    {
        case 200:
            if ([RDKClient string:responseString containsSubstring:@"WRONG_PASSWORD"]) return [RDKClient invalidCredentialsError];
            if ([RDKClient string:responseString containsSubstring:@"BAD_CAPTCHA"]) return [RDKClient invalidCaptchaError];
            if ([RDKClient string:responseString containsSubstring:@"RATELIMIT"]) return [RDKClient rateLimitedError];
            if ([RDKClient string:responseString containsSubstring:@"BAD_CSS_NAME"]) return [RDKClient invalidCSSClassNameError];
            if ([RDKClient string:responseString containsSubstring:@"TOO_OLD"]) return [RDKClient archivedError];
            if ([RDKClient string:responseString containsSubstring:@"TOO_MUCH_FLAIR_CSS"]) return [RDKClient tooManyFlairClassNamesError];
            
            break;
        case 400:
            if ([RDKClient string:responseString containsSubstring:@"BAD_MULTI_NAME"]) return [RDKClient invalidMultiredditNameError];
            
            break;
        case 403:
            if ([RDKClient string:responseString containsSubstring:@"USER_REQUIRED"]) return [RDKClient authenticationRequiredError];
            
            return [RDKClient permissionDeniedError];
            break;
        case 409:
            return [RDKClient conflictError];
            break;
        case 500:
            return [RDKClient internalServerError];
            break;
        case 502:
            return [RDKClient badGatewayError];
            break;
        case 503:
            return [RDKClient serviceUnavailableError];
            break;
        case 504:
            return [RDKClient timedOutError];
            break;
        default:
            break;
    }
    
    return nil;
}

+ (NSError *)authenticationRequiredError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Authentication required" failureReason:@"This method requires you to be signed in."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorAuthenticationFailed userInfo:userInfo];
}

+ (NSError *)invalidCaptchaError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Invalid CAPTCHA" failureReason:@"The CAPTCHA value or identifier you provided was invalid."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorInvalidCaptcha userInfo:userInfo];
}

+ (NSError *)invalidCSSClassNameError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Invalid CSS class name" failureReason:@"A CSS name you provided contained invalid characters."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorInvalidCSSClassName userInfo:userInfo];
}

+ (NSError *)invalidCredentialsError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Invalid credentials" failureReason:@"Your username or password were incorrect."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorInvalidCredentials userInfo:userInfo];
}

+ (NSError *)rateLimitedError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Rate limited" failureReason:@"You have exceeded reddit's rate limit."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorRateLimited userInfo:userInfo];
}

+ (NSError *)tooManyFlairClassNamesError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Too many flair class names" failureReason:@"You have passed in too many flair class names"];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorTooManyFlairClassNames userInfo:userInfo];
}

+ (NSError *)archivedError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"This object has been archived" failureReason:@"The object you tried to interact with has been archived."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorArchived userInfo:userInfo];
}

+ (NSError *)invalidMultiredditNameError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Invalid multireddit name" failureReason:@"The name provided for the multireddit was invalid."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorInvalidMultiredditName userInfo:userInfo];
}

+ (NSError *)permissionDeniedError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Permission denied" failureReason:@"You don't have permission to access this resource."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorPermissionDenied userInfo:userInfo];
}

+ (NSError *)conflictError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Conflict" failureReason:@"Your attempt to create a resource caused a conflict."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorConflict userInfo:userInfo];
}

+ (NSError *)internalServerError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Internal server error" failureReason:@"The reddit servers suffered an internal server error."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorInternalServerError userInfo:userInfo];
}

+ (NSError *)badGatewayError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Bad gateway" failureReason:@"Bad gateway."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorBadGateway userInfo:userInfo];
}

+ (NSError *)serviceUnavailableError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Service unavailable" failureReason:@"The reddit servers are unavailable."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorServiceUnavailable userInfo:userInfo];
}

+ (NSError *)timedOutError
{
    NSDictionary *userInfo = [RDKClient userInfoWithDescription:@"Timed out" failureReason:@"The reddit servers timed out."];
    return [NSError errorWithDomain:RDKClientErrorDomain code:RDKClientErrorTimedOut userInfo:userInfo];
}

#pragma mark - Private

+ (BOOL)string:(NSString *)string containsSubstring:(NSString *)substring
{
    NSRange range = [string rangeOfString:substring];
    return (range.location != NSNotFound);
}

+ (NSDictionary *)userInfoWithDescription:(NSString *)description failureReason:(NSString *)failureReason
{
    return @{NSLocalizedDescriptionKey: NSLocalizedString(description, @""), NSLocalizedFailureReasonErrorKey: NSLocalizedString(failureReason, @"") };
}

@end
