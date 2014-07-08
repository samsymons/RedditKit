// RKClient+Flair.m
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

#import "RKClient+Flair.h"
#import "RKClient+Requests.h"
#import "RKSubreddit.h"
#import "RKUser.h"
#import "RKLink.h"

NSString * RKStringFromFlairType(RKFlairTemplateType templateType)
{
    switch (templateType)
    {
        case RKFlairTemplateTypeLink:
            return @"LINK_FLAIR";
            break;
        case RKFlairTemplateTypeUser:
            return @"USER_FLAIR";
            break;
        default:
            return nil;
    }
}

NSString * RKStringFromUserFlairPosition(RKUserFlairPosition userFlairPosition)
{
    switch (userFlairPosition)
    {
        case RKUserFlairPositionLeft:
            return @"left";
            break;
        case RKUserFlairPositionRight:
            return @"right";
            break;
        default:
            return @"right";
            break;
    }
}

NSString * RKStringFromLinkFlairPosition(RKLinkFlairPosition linkFlairPosition)
{
    switch (linkFlairPosition)
    {
        case RKLinkFlairPositionLeft:
            return @"left";
            break;
        case RKLinkFlairPositionRight:
            return @"right";
            break;
        case RKLinkFlairPositionNone:
            return @"";
            break;
        default:
            return @"right";
            break;
    }
}

@implementation RKClient (Flair)

- (NSURLSessionDataTask *)setFlairOptionsForSubreddit:(RKSubreddit *)subreddit flairEnabled:(BOOL)flairEnabled userFlairPosition:(RKUserFlairPosition)userFlairPosition allowSelfAssignedUserFlair:(BOOL)userFlair linkFlairPosition:(RKLinkFlairPosition)linkFlairPosition allowSelfAssignedLinkFlair:(BOOL)linkFlair completion:(RKCompletionBlock)completion
{
    return [self setFlairOptionsForSubredditWithName:subreddit.name flairEnabled:flairEnabled userFlairPosition:userFlairPosition allowSelfAssignedUserFlair:userFlair linkFlairPosition:linkFlairPosition allowSelfAssignedLinkFlair:linkFlair completion:completion];
}

- (NSURLSessionDataTask *)setFlairOptionsForSubredditWithName:(NSString *)subredditName flairEnabled:(BOOL)flairEnabled userFlairPosition:(RKUserFlairPosition)userFlairPosition allowSelfAssignedUserFlair:(BOOL)userFlair linkFlairPosition:(RKLinkFlairPosition)linkFlairPosition allowSelfAssignedLinkFlair:(BOOL)linkFlair completion:(RKCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    NSParameterAssert(userFlairPosition);
    NSParameterAssert(linkFlairPosition);
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:7];
    
    NSString *flairEnabledString = flairEnabled ? @"true" : @"false";
    [parameters setObject:flairEnabledString forKey:@"flair_enabled"];
    
    [parameters setObject:RKStringFromUserFlairPosition(userFlairPosition) forKey:@"flair_position"];
    NSString *userFlairSelfAssignEnabledString = userFlair ? @"true" : @"false";
    [parameters setObject:userFlairSelfAssignEnabledString	forKey:@"flair_self_assign_enabled"];
    
    [parameters setObject:RKStringFromLinkFlairPosition(linkFlairPosition) forKey:@"link_flair_position"];
    NSString *linkFlairSelfAssignEnabledString = linkFlair ? @"true" : @"false";
    [parameters setObject:linkFlairSelfAssignEnabledString	forKey:@"link_flair_self_assign_enabled"];
    
    [parameters setObject:subredditName	forKey:@"r"];
    
    return [self basicPostTaskWithPath:@"api/flairconfig" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)flairListForSubreddit:(RKSubreddit *)subreddit completion:(RKArrayCompletionBlock)completion
{
    return [self flairListForSubredditWithName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)flairListForSubredditWithName:(NSString *)subredditName completion:(RKArrayCompletionBlock)completion
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

- (NSURLSessionDataTask *)allowFlair:(BOOL)flairAllowed inSubreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self allowFlair:flairAllowed inSubredditWithName:subreddit.title completion:completion];
}

- (NSURLSessionDataTask *)allowFlair:(BOOL)flairAllowed inSubredditWithName:(NSString *)subredditName completion:(RKCompletionBlock)completion;
{
    NSParameterAssert(subredditName);
    
    NSString *flairAllowedString = flairAllowed ? @"true" : @"false";
    NSDictionary *parameters = @{@"enabled": flairAllowedString, @"r": subredditName};
    
    return [self basicPostTaskWithPath:@"api/setflairenabled" parameters:parameters completion:completion];
}

#pragma mark - Creating Flair

- (NSURLSessionDataTask *)createFlairTemplateOfType:(RKFlairTemplateType)type subreddit:(RKSubreddit *)subreddit text:(NSString *)text flairClass:(NSString *)flairClass completion:(RKCompletionBlock)completion
{
    return [self createFlairTemplateOfType:type subredditName:subreddit.title text:text flairClass:flairClass completion:completion];
}

- (NSURLSessionDataTask *)createFlairTemplateOfType:(RKFlairTemplateType)type subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RKCompletionBlock)completion
{
    NSParameterAssert(type);
    NSParameterAssert(subredditName);
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    if (text) [parameters setObject:text forKey:@"text"];
    if (flairClass) [parameters setObject:flairClass forKey:@"css_class"];
    
    [parameters setObject:subredditName forKey:@"r"];
    [parameters setObject:RKStringFromFlairType(type) forKey:@"flair_type"];
    
    return [self basicPostTaskWithPath:@"api/flairtemplate" parameters:parameters completion:completion];
}

#pragma mark - Setting Flair

- (NSURLSessionDataTask *)setFlairForUser:(RKUser *)user subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RKCompletionBlock)completion
{
    return [self setFlairForUserWithUsername:user.username subredditName:subredditName text:text flairClass:flairClass completion:completion];
}

- (NSURLSessionDataTask *)setFlairForUserWithUsername:(NSString *)username subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RKCompletionBlock)completion
{
    NSParameterAssert(username);
    NSParameterAssert(subredditName);
    NSParameterAssert(text);
    NSParameterAssert(flairClass);
	
    NSDictionary *parameters = @{@"r": subredditName, @"name": username, @"text": text, @"css_class": flairClass};
    return [self basicPostTaskWithPath:@"api/flair" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)setFlairForLink:(RKLink *)link subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RKCompletionBlock)completion
{
    return [self setFlairForLinkWithFullName:[link fullName] subredditName:subredditName text:text flairClass:flairClass completion:completion];
}

- (NSURLSessionDataTask *)setFlairForLinkWithFullName:(NSString *)fullName subredditName:(NSString *)subredditName text:(NSString *)text flairClass:(NSString *)flairClass completion:(RKCompletionBlock)completion
{
    NSParameterAssert(fullName);
    NSParameterAssert(subredditName);
    NSParameterAssert(text);
    NSParameterAssert(flairClass);
    
    NSDictionary *parameters = @{@"r": subredditName, @"link": fullName, @"text": text, @"css_class": flairClass};
    return [self basicPostTaskWithPath:@"api/flair" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)setFlairWithCSV:(NSString *)flairCSV subreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self setFlairWithCSV:flairCSV subredditName:subreddit.title completion:completion];
}

- (NSURLSessionDataTask *)setFlairWithCSV:(NSString *)flairCSV subredditName:(NSString *)subredditName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(flairCSV);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"flair_csv": flairCSV, @"r": subredditName};
    
    return [self basicPostTaskWithPath:@"api/flaircsv.json" parameters:parameters completion:completion];
}

#pragma mark - Deleting Flair

- (NSURLSessionDataTask *)clearFlairTemplatesOfType:(RKFlairTemplateType)type subreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self clearFlairTemplatesOfType:type subredditName:subreddit.title completion:completion];
}

- (NSURLSessionDataTask *)clearFlairTemplatesOfType:(RKFlairTemplateType)type subredditName:(NSString *)subredditName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(type);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"flair_type": RKStringFromFlairType(type), @"r": subredditName};
    return [self basicPostTaskWithPath:@"api/clearflairtemplates" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)deleteFlairTemplateWithIdentifier:(NSString *)identifier subreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self deleteFlairTemplateWithIdentifier:identifier subredditName:subreddit.name completion:completion];
}

- (NSURLSessionDataTask *)deleteFlairTemplateWithIdentifier:(NSString *)identifier subredditName:(NSString *)subredditName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(identifier);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"flair_template_id": identifier, @"r": subredditName};
    return [self basicPostTaskWithPath:@"api/deleteflairtemplate" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)deleteFlairForUser:(RKUser *)user subreddit:(RKSubreddit *)subreddit completion:(RKCompletionBlock)completion
{
    return [self deleteFlairForUserWithUsername:user.username subredditName:subreddit.title completion:completion];
}

- (NSURLSessionDataTask *)deleteFlairForUserWithUsername:(NSString *)username subredditName:(NSString *)subredditName completion:(RKCompletionBlock)completion
{
    NSParameterAssert(username);
    NSParameterAssert(subredditName);
    
    NSDictionary *parameters = @{@"name": username, @"r": subredditName};
    return [self basicPostTaskWithPath:@"api/deleteflair" parameters:parameters completion:completion];
}

@end
