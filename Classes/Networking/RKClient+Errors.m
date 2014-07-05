// RKClient+Errors.m
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

#import "RKClient+Errors.h"

@implementation RKClient (Errors)

const NSInteger RKClientErrorAuthenticationFailed = 1;

const NSInteger RKClientErrorInvalidCaptcha = 201;
const NSInteger RKClientErrorInvalidCSSClassName = 202;
const NSInteger RKClientErrorInvalidCredentials = 203;
const NSInteger RKClientErrorRateLimited = 204;
const NSInteger RKClientErrorTooManyFlairClassNames = 205;
const NSInteger RKClientErrorArchived = 206;
const NSInteger RKClientErrorInvalidSubreddit = 207;

const NSInteger RKClientErrorInvalidMultiredditName = 401;
const NSInteger RKClientErrorPermissionDenied = 402;
const NSInteger RKClientErrorConflict = 403;
const NSInteger RKClientErrorNotFound = 404;

const NSInteger RKClientErrorInternalServerError = 501;
const NSInteger RKClientErrorBadGateway = 502;
const NSInteger RKClientErrorServiceUnavailable = 503;
const NSInteger RKClientErrorTimedOut = 504;

+ (NSError *)errorFromResponse:(NSHTTPURLResponse *)response responseString:(NSString *)responseString
{
    NSParameterAssert(response);
    NSParameterAssert(responseString);
    
    return [[self class] errorFromStatusCode:response.statusCode responseString:responseString];
}

+ (NSError *)errorFromStatusCode:(NSInteger)statusCode responseString:(NSString *)responseString
{
    switch (statusCode)
    {
        case 200:
            if ([RKClient string:responseString containsSubstring:@"WRONG_PASSWORD"]) return [RKClient invalidCredentialsError];
            if ([RKClient string:responseString containsSubstring:@"BAD_CAPTCHA"]) return [RKClient invalidCaptchaError];
            if ([RKClient string:responseString containsSubstring:@"RATELIMIT"]) return [RKClient rateLimitedError];
            if ([RKClient string:responseString containsSubstring:@"BAD_CSS_NAME"]) return [RKClient invalidCSSClassNameError];
            if ([RKClient string:responseString containsSubstring:@"TOO_OLD"]) return [RKClient archivedError];
            if ([RKClient string:responseString containsSubstring:@"TOO_MUCH_FLAIR_CSS"]) return [RKClient tooManyFlairClassNamesError];
            if ([RKClient string:responseString containsSubstring:@"SUBREDDIT_NOEXIST"]) return [RKClient invalidSubredditError];
            
            break;
        case 400:
            if ([RKClient string:responseString containsSubstring:@"BAD_MULTI_NAME"]) return [RKClient invalidMultiredditNameError];
            
            break;
        case 403:
            if ([RKClient string:responseString containsSubstring:@"USER_REQUIRED"]) return [RKClient authenticationRequiredError];
            
            return [RKClient permissionDeniedError];
            break;
        case 404:
            return [RKClient notFoundError];
            break;
        case 409:
            return [RKClient conflictError];
            break;
        case 500:
            return [RKClient internalServerError];
            break;
        case 502:
            return [RKClient badGatewayError];
            break;
        case 503:
            return [RKClient serviceUnavailableError];
            break;
        case 504:
            return [RKClient timedOutError];
            break;
        default:
            break;
    }
    
    return nil;
}

+ (NSError *)errorFromResponseObject:(id)responseObject
{
    NSParameterAssert(responseObject);
    
    if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *response = responseObject;
        NSNumber *statusCodeError = response[@"error"];
        NSArray *errors = [response valueForKeyPath:@"json.errors"];
        
        if ([errors isKindOfClass:[NSArray class]] && [errors count] > 0)
        {
            id firstObject = [errors firstObject];
            
            if ([firstObject isKindOfClass:[NSArray class]] && [firstObject count] > 1)
            {
                NSString *firstString = [firstObject firstObject];
                NSString *secondString = [firstObject objectAtIndex:1];
                
                if ([firstString isKindOfClass:[NSString class]] && [secondString isKindOfClass:[NSString class]])
                {
                    return [[self class] errorFromStatusCode:200 responseString:firstString];
                }
            }
        }
        else if (statusCodeError)
        {
            return [[self class] errorFromStatusCode:[statusCodeError integerValue] responseString:@""];
        }
    }
    
    return nil;
}

+ (NSError *)authenticationRequiredError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Authentication required" failureReason:@"This method requires you to be signed in."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorAuthenticationFailed userInfo:userInfo];
}

+ (NSError *)invalidCaptchaError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Invalid CAPTCHA" failureReason:@"The CAPTCHA value or identifier you provided was invalid."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorInvalidCaptcha userInfo:userInfo];
}

+ (NSError *)invalidCSSClassNameError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Invalid CSS class name" failureReason:@"A CSS name you provided contained invalid characters."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorInvalidCSSClassName userInfo:userInfo];
}

+ (NSError *)invalidCredentialsError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Invalid credentials" failureReason:@"Your username or password were incorrect."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorInvalidCredentials userInfo:userInfo];
}

+ (NSError *)rateLimitedError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Rate limited" failureReason:@"You have exceeded reddit's rate limit."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorRateLimited userInfo:userInfo];
}

+ (NSError *)tooManyFlairClassNamesError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Too many flair class names" failureReason:@"You have passed in too many flair class names"];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorTooManyFlairClassNames userInfo:userInfo];
}

+ (NSError *)invalidSubredditError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"That subreddit does not exist" failureReason:@"You have entered an invalid subreddit name"];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorInvalidSubreddit userInfo:userInfo];
}

+ (NSError *)archivedError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"This object has been archived" failureReason:@"The object you tried to interact with has been archived."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorArchived userInfo:userInfo];
}

+ (NSError *)invalidMultiredditNameError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Invalid multireddit name" failureReason:@"The name provided for the multireddit was invalid."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorInvalidMultiredditName userInfo:userInfo];
}

+ (NSError *)permissionDeniedError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Permission denied" failureReason:@"You don't have permission to access this resource."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorPermissionDenied userInfo:userInfo];
}

+ (NSError *)conflictError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Conflict" failureReason:@"Your attempt to create a resource caused a conflict."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorConflict userInfo:userInfo];
}

+ (NSError *)notFoundError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Not found" failureReason:@"This content could not be found."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorNotFound userInfo:userInfo];
}

+ (NSError *)internalServerError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Internal server error" failureReason:@"The reddit servers suffered an internal server error."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorInternalServerError userInfo:userInfo];
}

+ (NSError *)badGatewayError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Bad gateway" failureReason:@"Bad gateway."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorBadGateway userInfo:userInfo];
}

+ (NSError *)serviceUnavailableError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Service unavailable" failureReason:@"The reddit servers are unavailable."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorServiceUnavailable userInfo:userInfo];
}

+ (NSError *)timedOutError
{
    NSDictionary *userInfo = [RKClient userInfoWithDescription:@"Timed out" failureReason:@"The reddit servers timed out."];
    return [NSError errorWithDomain:RKClientErrorDomain code:RKClientErrorTimedOut userInfo:userInfo];
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
