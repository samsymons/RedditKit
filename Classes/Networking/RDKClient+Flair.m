// RDKClient+Flair.m
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

#import "RDKClient+Flair.h"
#import "RDKClient+Requests.h"
#import "RDKSubreddit.h"
#import "RDKUser.h"
#import "RDKLink.h"

NSString * NSStringFromFlairType(RDKFlairTemplateType templateType)
{
    switch (templateType)
    {
        case RDKFlairTemplateTypeLink:
            return @"LINK_FLAIR";
            break;
        case RDKFlairTemplateTypeUser:
            return @"USER_FLAIR";
            break;
        default:
            return nil;
    }
}

NSString * NSStringFromUserFlairPosition(RDKUserFlairPosition userFlairPosition)
{
    switch (userFlairPosition)
    {
        case RDKUserFlairPositionLeft:
            return @"left";
            break;
        case RDKUserFlairPositionRight:
            return @"right";
            break;
        default:
            return @"right";
            break;
    }
}

NSString * NSStringFromLinkFlairPosition(RDKLinkFlairPosition linkFlairPosition)
{
    switch (linkFlairPosition)
    {
        case RDKLinkFlairPositionLeft:
            return @"left";
            break;
        case RDKLinkFlairPositionRight:
            return @"right";
            break;
        case RDKLinkFlairPositionNone:
            return @"";
            break;
        default:
            return @"right";
            break;
    }
}

@implementation RDKClient (Flair)

- (NSURLSessionDataTask *)setFlairOptionsForSubreddit:(RDKSubreddit *)subreddit flairEnabled:(BOOL)flairEnabled userFlairPosition:(RDKUserFlairPosition)userFlairPosition allowSelfAssignedUserFlair:(BOOL)userFlair linkFlairPosition:(RDKLinkFlairPosition)linkFlairPosition allowSelfAssignedLinkFlair:(BOOL)linkFlair completion:(RDKCompletionBlock)completion
{
    return [self setFlairOptionsForSubredditWithName:subreddit.name flairEnabled:flairEnabled userFlairPosition:userFlairPosition allowSelfAssignedUserFlair:userFlair linkFlairPosition:linkFlairPosition allowSelfAssignedLinkFlair:linkFlair completion:completion];
}

- (NSURLSessionDataTask *)setFlairOptionsForSubredditWithName:(NSString *)subredditName flairEnabled:(BOOL)flairEnabled userFlairPosition:(RDKUserFlairPosition)userFlairPosition allowSelfAssignedUserFlair:(BOOL)userFlair linkFlairPosition:(RDKLinkFlairPosition)linkFlairPosition allowSelfAssignedLinkFlair:(BOOL)linkFlair completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    NSParameterAssert(userFlairPosition);
    NSParameterAssert(linkFlairPosition);
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:7];
    
    NSString *flairEnabledString = flairEnabled ? @"true" : @"false";
    [parameters setObject:flairEnabledString forKey:@"flair_enabled"];
    
    [parameters setObject:NSStringFromUserFlairPosition(userFlairPosition) forKey:@"flair_position"];
    NSString *userFlairSelfAssignEnabledString = userFlair ? @"true" : @"false";
    [parameters setObject:userFlairSelfAssignEnabledString	forKey:@"flair_self_assign_enabled"];
    
    [parameters setObject:NSStringFromLinkFlairPosition(linkFlairPosition) forKey:@"link_flair_position"];
    NSString *linkFlairSelfAssignEnabledString = linkFlair ? @"true" : @"false";
    [parameters setObject:linkFlairSelfAssignEnabledString	forKey:@"link_flair_self_assign_enabled"];
    
    [parameters setObject:subredditName	forKey:@"r"];
    
    return [self basicPostTaskWithPath:@"api/flairconfig" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)flairListForSubreddit:(RDKSubreddit *)subreddit completion:(RDKArrayCompletionBlock)completion
{
    return [self flairListForSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)flairListForSubredditWithName:(NSString *)subredditName completion:(RDKArrayCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    
    NSString *path = [NSString stringWithFormat:@"r/%@/api/flairlist.json", subredditName];
    
    return [self getPath:path parameters:nil completion:^(NSHTTPURLResponse *response, NSDictionary *responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (responseObject)
        {
            NSArray *list = responseObject[@"users"];
            completion(list, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)allowFlair:(BOOL)flairAllowed inSubreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self allowFlair:flairAllowed inSubredditWithName:subreddit.title completion:completion];
}

- (NSURLSessionDataTask *)allowFlair:(BOOL)flairAllowed inSubredditWithName:(NSString *)subredditName completion:(RDKCompletionBlock)completion;
{
    NSParameterAssert(subredditName);
    
    NSString *flairAllowedString = flairAllowed ? @"true" : @"false";
    NSDictionary *parameters = @{@"enabled": flairAllowedString, @"r": subredditName};
    
    return [self basicPostTaskWithPath:@"api/setflairenabled" parameters:parameters completion:completion];
}

#pragma mark - Creating Flair

- (NSURLSessionDataTask *)createFlairTemplateOfType:(RDKFlairTemplateType)type subreddit:(RDKSubreddit *)subreddit text:(NSString *)text flairClass:(NSString *)flairClass completion:(RDKCompletionBlock)completion
{
    return [self createFlairTemplateOfType:type subredditName:subreddit.title text:text flairClass:flairClass completion:completion];
}

- (NSURLSessionDataTask *)createFlairTemplateOfType:(RDKFlairTemplateType)type subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(type);
    NSParameterAssert(subredditName);
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    if (text) [parameters setObject:text forKey:@"text"];
    if (flairClass) [parameters setObject:flairClass forKey:@"css_class"];
    
    [parameters setObject:subredditName forKey:@"r"];
    [parameters setObject:NSStringFromFlairType(type) forKey:@"flair_type"];
    
    return [self basicPostTaskWithPath:@"api/flairtemplate" parameters:parameters completion:completion];
}

#pragma mark - Setting Flair

- (NSURLSessionDataTask *)setFlairForUser:(RDKUser *)user subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RDKCompletionBlock)completion
{
    return [self setFlairForUserWithUsername:user.username subredditName:subredditName text:text flairClass:flairClass completion:completion];
}

- (NSURLSessionDataTask *)setFlairForUserWithUsername:(NSString *)username subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(username);
    NSParameterAssert(subredditName);
    NSParameterAssert(text);
    NSParameterAssert(flairClass);
	
    NSDictionary *parameters = @{@"r": subredditName, @"name": username, @"text": text, @"css_class": flairClass};
    return [self basicPostTaskWithPath:@"api/flair" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)setFlairForLink:(RDKLink *)link subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RDKCompletionBlock)completion
{
    return [self setFlairForLinkWithFullName:[link fullName] subredditName:subredditName text:text flairClass:flairClass completion:completion];
}

- (NSURLSessionDataTask *)setFlairForLinkWithFullName:(NSString *)fullName subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    NSParameterAssert(subredditName);
    NSParameterAssert(text);
    NSParameterAssert(flairClass);
    
    NSDictionary *parameters = @{@"r": subredditName, @"link": fullName, @"text": text, @"css_class": flairClass};
    return [self basicPostTaskWithPath:@"api/flair" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)setFlairWithCSV:(NSString *)flairCSV subreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self setFlairWithCSV:flairCSV subredditName:subreddit.title completion:completion];
}

- (NSURLSessionDataTask *)setFlairWithCSV:(NSString *)flairCSV subredditName:(NSString *)subredditName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(flairCSV);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"flair_csv": flairCSV, @"r": subredditName};
    
    return [self basicPostTaskWithPath:@"api/flaircsv.json" parameters:parameters completion:completion];
}

#pragma mark - Deleting Flair

- (NSURLSessionDataTask *)clearFlairTemplatesOfType:(RDKFlairTemplateType)type subreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self clearFlairTemplatesOfType:type subredditName:subreddit.title completion:completion];
}

- (NSURLSessionDataTask *)clearFlairTemplatesOfType:(RDKFlairTemplateType)type subredditName:(NSString *)subredditName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(type);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"flair_type": NSStringFromFlairType(type), @"r": subredditName};
    return [self basicPostTaskWithPath:@"api/clearflairtemplates" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)deleteFlairTemplateWithIdentifier:(NSString *)identifier subreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self deleteFlairTemplateWithIdentifier:identifier subredditName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)deleteFlairTemplateWithIdentifier:(NSString *)identifier subredditName:(NSString *)subredditName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(identifier);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"flair_template_id": identifier, @"r": subredditName};
    return [self basicPostTaskWithPath:@"api/deleteflairtemplate" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)deleteFlairForUser:(RDKUser *)user subreddit:(RDKSubreddit *)subreddit completion:(RDKCompletionBlock)completion
{
    return [self deleteFlairForUserWithUsername:user.username subredditName:subreddit.title completion:completion];
}

- (NSURLSessionDataTask *)deleteFlairForUserWithUsername:(NSString *)username subredditName:(NSString *)subredditName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(username);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"name": username, @"r": subredditName};
    return [self basicPostTaskWithPath:@"api/deleteflair" parameters:parameters completion:completion];
}

@end
