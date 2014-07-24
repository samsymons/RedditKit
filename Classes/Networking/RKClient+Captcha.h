// RKClient+Captcha.h
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

@class AFImageRequestOperation;

@interface RKClient (Captcha)

/**
 Whether the current user will need to fill out a CAPTCHA for certain methods.
 
 @param completion An optional block to be executed upon request completion. It takes two arguments: a boolean indicating whether the user is required to complete a CAPTCHA, and any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionTask *)needsCaptchaWithCompletion:(RKBooleanCompletionBlock)completion;

/**
 Gets a new CAPTCHA identifier from reddit.
 
 @param completion An optional block to be executed upon request completion. It takes two arguments: the CAPTCHA's identifier (an NSString), and any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)newCaptchaIdentifierWithCompletion:(RKObjectCompletionBlock)completion;

/**
 Returns the URL for a CAPTCHA with a specific identifier.
 
 @param identifier The CAPTCHA's identifier, as returned by `newCaptchaIdentifierWithCompletion:`.
 @return The NSURL for the CAPTCHA image.
 @see newCaptchaIdentifierWithCompletion:
 */
- (NSURL *)URLForCaptchaWithIdentifier:(NSString *)identifier;

/**
 Gets a CAPTCHA image from a given identifier.
 
 @param identifier The CAPTCHA identifier.
 @param completion An optional block to be executed upon request completion. It takes two arguments: the CAPTCHA image (UIImage or NSImage), and any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)imageForCaptchaIdentifier:(NSString *)identifier completion:(RKObjectCompletionBlock)completion;

@end
