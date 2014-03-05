// RKClient+Apps.h
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

@class RKUser;

@interface RKClient (Apps)

/**
 Creates an app under the current user's account.
 
 @param name The name of the app.
 @param description The description of the app.
 @param aboutURL The URL providing more information about the app.
 @param redirectURL The redirect URL for the app.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)createAppWithName:(NSString *)name description:(NSString *)description aboutURL:(NSString *)aboutURL redirectURL:(NSString *)redirectURL completion:(RKCompletionBlock)completion;

/**
 Updates an app's details.
 
 @param identifier The identifier of the app to update.
 @param name The name of the app.
 @param description The description of the app.
 @param aboutURL The URL providing more information about the app.
 @param redirectURL The redirect URL for the app.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)updateAppWithIdentifier:(NSString *)identifier name:(NSString *)name description:(NSString *)description aboutURL:(NSString *)aboutURL redirectURL:(NSString *)redirectURL completion:(RKCompletionBlock)completion;

/**
 Deletes an app.
 
 @param identifier The identifier of the app to delete.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)deleteAppWithIdentifier:(NSString *)identifier completion:(RKCompletionBlock)completion;

/**
 Revokes an app.
 
 @param identifier The identifier of the app to revoke.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)revokeAppWithIdentifier:(NSString *)identifier completion:(RKCompletionBlock)completion;

/**
 Adds a reddit user as a developer of an app.
 
 @param developer The user to add as a developer.
 @param identifier The app's identifier.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)addDeveloper:(RKUser *)developer toAppWithIdentifier:(NSString *)identifier completion:(RKCompletionBlock)completion;

/**
 Adds a reddit user as a developer of an app.
 
 @param username The username of the user to add as a developer.
 @param identifier The app's identifier.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)addDeveloperWithUsername:(NSString *)username toAppWithIdentifier:(NSString *)identifier completion:(RKCompletionBlock)completion;

/**
 Removes a reddit user from being a developer of an app.
 
 @param developer The user to remove as a developer.
 @param identifier The app's identifier.
 @param completion The block to be executed upon completion of the request.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)removeDeveloper:(RKUser *)developer fromAppWithIdentifier:(NSString *)identifier completion:(RKCompletionBlock)completion;

/**
 Removes a reddit user from being a developer of an app.
 
 @param username The username of the user to remove as a developer.
 @param identifier The app's identifier.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)removeDeveloperWithUsername:(NSString *)username fromAppWithIdentifier:(NSString *)identifier completion:(RKCompletionBlock)completion;

@end
