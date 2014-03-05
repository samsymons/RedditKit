// RKClient+Flair.h
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

typedef NS_ENUM(NSUInteger, RKFlairTemplateType) {
	RKFlairTemplateTypeUser = 1,
	RKFlairTemplateTypeLink
};

typedef NS_ENUM(NSUInteger, RKUserFlairPosition) {
	RKUserFlairPositionLeft = 1,
	RKUserFlairPositionRight
};

typedef NS_ENUM(NSUInteger, RKLinkFlairPosition) {
	RKLinkFlairPositionNone = 1,
	RKLinkFlairPositionLeft,
	RKLinkFlairPositionRight
};

@class RKUser;
@class RKLink;
@class RKSubreddit;

@interface RKClient (Flair)

/**
 Set flair options for a subreddit. Requires that the current user be a moderator of the subreddit specified.
 
 @param subreddit The subreddit to set flair options for.
 @param flairEnabled Whether or not flair should be enabled for the subreddit.
 @param userFlairPosition The position for which flair will appear beside usernames.
 @param userFlair Whether or not users may assign their own flair.
 @param linkFlairPosition The position for which flair will appear beside link titles.
 @param linkFlair Whether or not users may assign flair to their links.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)setFlairOptionsForSubreddit:(RKSubreddit *)subreddit flairEnabled:(BOOL)flairEnabled userFlairPosition:(RKUserFlairPosition)userFlairPosition allowSelfAssignedUserFlair:(BOOL)userFlair linkFlairPosition:(RKLinkFlairPosition)linkFlairPosition allowSelfAssignedLinkFlair:(BOOL)linkFlair completion:(RKCompletionBlock)completion;

/**
 Set flair options for a subreddit. Requires that the current user be a moderator of the subreddit specified.
 
 @param subredditName The name of the subreddit to set flair options for.
 @param flairEnabled Whether or not flair should be enabled for the subreddit.
 @param userFlairPosition The position for which flair will appear beside usernames.
 @param userFlair Whether or not users may assign their own flair.
 @param linkFlairPosition The position for which flair will appear beside link titles.
 @param linkFlair Whether or not users may assign flair to their links.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)setFlairOptionsForSubredditWithName:(NSString *)subredditName flairEnabled:(BOOL)flairEnabled userFlairPosition:(RKUserFlairPosition)userFlairPosition allowSelfAssignedUserFlair:(BOOL)userFlair linkFlairPosition:(RKLinkFlairPosition)linkFlairPosition allowSelfAssignedLinkFlair:(BOOL)linkFlair completion:(RKCompletionBlock)completion;

/**
 Gets a list of users and their flair for a given subreddit.
 
 @param subreddit The subreddit for which to get users and flair.
 @param completion An optional block to be executed upon request completion. It takes two arguments: an NSArray, and any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)flairListForSubreddit:(RKSubreddit *)subreddit completion:(RKArrayCompletionBlock)completion;

/**
 Gets a list of users and their flair for a given subreddit.
 
 @param subredditName The subreddit for which to get users and flair.
 @param completion An optional block to be executed upon request completion. It takes two arguments: an NSArray, and any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)flairListForSubredditWithName:(NSString *)subredditName completion:(RKArrayCompletionBlock)completion;

/**
 Allows or disallows flair in a subreddit.
 
 @param flairAllowed Whether flair is allowed.
 @param subreddit The subreddit for which to allow or disallow flair.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)allowFlair:(BOOL)flairAllowed inSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion;

/**
 Allows or disallows flair in a subreddit.
 
 @param flairAllowed Whether flair is allowed.
 @param subredditName The name of the subreddit for which to allow or disallow flair.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)allowFlair:(BOOL)flairAllowed inSubredditWithName:(NSString *)subredditName completion:(RKCompletionBlock)completion;

#pragma mark - Creating Flair

/**
 Creates a flair template.
 
 @param type The type of template to create.
 @param subreddit The subreddit to create the flair template in.
 @param text The text for the template.
 @param flairClass The CSS class for the template. This can be up to ten different class names, separated by whitespace. An error will be returned if there are any more than ten class names.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)createFlairTemplateOfType:(RKFlairTemplateType)type subreddit:(RKSubreddit *)subreddit text:(NSString *)text flairClass:(NSString *)flairClass completion:(RKCompletionBlock)completion;

/**
 Creates a flair template.
 
 @param type The type of template to create.
 @param subredditName The name of the subreddit to create the flair template in.
 @param text The text for the template.
 @param flairClass The CSS class for the template. This can be up to ten different class names, separated by whitespace. An error will be returned if there are any more than ten class names.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)createFlairTemplateOfType:(RKFlairTemplateType)type subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RKCompletionBlock)completion;

#pragma mark - Setting Flair

/**
 Sets flair for a user.
 
 @param user The user for which to set flair.
 @param subredditName The name of the subreddit to create the flair template in.
 @param text The text for the template.
 @param flairClass The CSS class for the template.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)setFlairForUser:(RKUser *)user subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RKCompletionBlock)completion;

/**
 Sets flair for a user.
 
 @param username The username of the user for which to set flair.
 @param subredditName The name of the subreddit to create the flair template in.
 @param text The text for the template.
 @param flairClass The CSS class for the template.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)setFlairForUserWithUsername:(NSString *)username subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RKCompletionBlock)completion;

/**
 Sets flair for a link.
 
 @param link The link for which to set flair.
 @param subredditName The name of the subreddit to create the flair template in.
 @param text The text for the template.
 @param flairClass The CSS class for the template.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)setFlairForLink:(RKLink *)link subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RKCompletionBlock)completion;

/**
 Sets flair for a link.
 
 @param fullName The full name of the link for which to set flair.
 @param subredditName The name of the subreddit to create the flair template in.
 @param text The text for the template.
 @param flairClass The CSS class for the template.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)setFlairForLinkWithFullName:(NSString *)fullName subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RKCompletionBlock)completion;

/**
 Creates flair templates from a CSV string.
 
 @param flairCSV The CSV string.
 @param subreddit The subreddit in which to create the flair.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 @note Each line has a CSV format of 'user,flair-text,css_class', and is limited to 100 lines.
 */
- (NSURLSessionDataTask *)setFlairWithCSV:(NSString *)flairCSV subreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion;

/**
 Creates flair templates from a CSV string.
 Each line in the CSV file requires a format of 'user,flair-text,css_class', and is limited to 100 lines.
 
 @param flairCSV The CSV string.
 @param subredditName The name of the subreddit in which to create the flair.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)setFlairWithCSV:(NSString *)flairCSV subredditName:(NSString *)subredditName completion:(RKCompletionBlock)completion;

#pragma mark - Deleting Flair

/**
 Clear flair templates of a certain type.
 
 @param type The type of template to clear.
 @param subreddit The subreddit for which to clear flair templates.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)clearFlairTemplatesOfType:(RKFlairTemplateType)type subreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion;

/**
 Clear flair templates of a certain type.
 
 @param type The type of template to clear.
 @param subredditName The name of the subreddit for which to clear flair templates.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)clearFlairTemplatesOfType:(RKFlairTemplateType)type subredditName:(NSString *)subredditName completion:(RKCompletionBlock)completion;

/**
 Deletes a flair template.
 
 @param identifier The identifier of the flair template to delete.
 @param subreddit The subreddit containing the flair template.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)deleteFlairTemplateWithIdentifier:(NSString *)identifier subreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion;

/**
 Deletes a flair template.
 
 @param identifier The identifier of the flair template to delete.
 @param subredditName The name of the subreddit containing the flair template.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)deleteFlairTemplateWithIdentifier:(NSString *)identifier subredditName:(NSString *)subredditName completion:(RKCompletionBlock)completion;

/**
 Removes flair that is assigned to a user.
 
 @param user The user for which to remove the flair.
 @param subreddit The name of the subreddit containing the user.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)deleteFlairForUser:(RKUser *)user subreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion;

/**
 Removes flair that is assigned to a user.
 
 @param username The name of the user for which to remove the flair.
 @param subredditName The name of the subreddit containing the user.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 @return The NSURLSessionDataTask for the request.
 */
- (NSURLSessionDataTask *)deleteFlairForUserWithUsername:(NSString *)username subredditName:(NSString *)subredditName completion:(RKCompletionBlock)completion;

@end
