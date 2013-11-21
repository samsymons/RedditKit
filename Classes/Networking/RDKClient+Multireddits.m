// RDKClient+Multireddits.m
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

#import "RDKClient+Multireddits.h"
#import "RDKClient+Requests.h"
#import "RDKObjectBuilder.h"
#import "RDKUser.h"
#import "RDKSubreddit.h"
#import "RDKMultiredditDescription.h"

@implementation RDKClient (Multireddits)

#pragma mark - Getting Multireddit Information

- (NSURLSessionDataTask *)multiredditsWithCompletion:(RDKArrayCompletionBlock)completion
{
	return [self getPath:@"api/multi/mine.json" parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
		if (!completion)
		{
			return;
		}
		
		if (responseObject)
		{
			NSMutableArray *multireddits = [[NSMutableArray alloc] initWithCapacity:[responseObject count]];
            
            for (NSDictionary *multireddit in responseObject)
            {
                [multireddits addObject:[RDKObjectBuilder objectFromJSON:multireddit]];
            }
            
			completion(multireddits, nil);
		}
		else
		{
			completion(nil, error);
		}
	}];
}

- (NSURLSessionDataTask *)multiredditWithName:(NSString *)multiredditName user:(RDKUser *)user completion:(RDKObjectCompletionBlock)completion
{
    return [self multiredditWithName:multiredditName userWithUsername:user.username completion:completion];
}

- (NSURLSessionDataTask *)multiredditWithName:(NSString *)multiredditName userWithUsername:(NSString *)username completion:(RDKObjectCompletionBlock)completion
{
    NSParameterAssert(multiredditName);
    NSParameterAssert(username);
    
    NSString *multiredditPath = [self pathForMultiredditWithName:multiredditName ownerName:username];
    NSString *path = [NSString stringWithFormat:@"api/multi%@", multiredditPath];
    
    return [self getPath:path parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (responseObject)
        {
            RDKMultireddit *multireddit = [RDKObjectBuilder objectFromJSON:responseObject];
            completion(multireddit, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)descriptionForMultireddit:(RDKMultireddit *)multireddit completion:(RDKObjectCompletionBlock)completion
{
    return [self descriptionForMultiredditWithName:multireddit.name userWithUsername:multireddit.username completion:completion];
}

- (NSURLSessionDataTask *)descriptionForMultiredditWithName:(NSString *)multiredditName userWithUsername:(NSString *)username completion:(RDKObjectCompletionBlock)completion
{
    NSParameterAssert(multiredditName);
    NSParameterAssert(username);
    
    NSString *multipath = [self pathForMultiredditWithName:multiredditName ownerName:username];
    NSString *path = [NSString stringWithFormat:@"api/multi%@/description", multipath];
    
    return [self getPath:path parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (responseObject)
        {
            RDKMultiredditDescription *multiredditDescription = [RDKObjectBuilder objectFromJSON:responseObject];
            completion(multiredditDescription, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)setDescription:(NSString *)description forMultireddit:(RDKMultireddit *)multireddit completion:(RDKObjectCompletionBlock)completion
{
    return [self setDescription:description forMultiredditWithName:multireddit.name completion:completion];
}

- (NSURLSessionDataTask *)setDescription:(NSString *)description forMultiredditWithName:(NSString *)multiredditName completion:(RDKObjectCompletionBlock)completion
{
    NSParameterAssert(description);
    NSParameterAssert(multiredditName);
    
    NSString *multipath = [self pathForMultiredditWithName:multiredditName ownerName:self.currentUser.username];
    NSString *path = [NSString stringWithFormat:@"api/multi%@/description", multipath];
    
    NSDictionary *model = @{@"body_md": description};
    NSData *modelData = [NSJSONSerialization dataWithJSONObject:model options:kNilOptions error:nil];
    NSString *modelDataString = [[NSString alloc] initWithData:modelData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{@"multipath": multipath, @"model": modelDataString};
    
    return [self putPath:path parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (responseObject)
        {
            RDKMultireddit *multireddit = [RDKObjectBuilder objectFromJSON:responseObject];
            completion(multireddit, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

#pragma mark - Creating, Modifying & Deleting Multireddits

- (NSURLSessionDataTask *)createMultiredditWithName:(NSString *)name subreddits:(NSArray *)subreddits visibility:(RDKMultiredditVisibility)visibility completion:(RDKObjectCompletionBlock)completion
{
    return [self multiredditTaskWithMethod:@"POST" name:name subreddits:subreddits visibility:visibility completion:completion];
}

- (NSURLSessionDataTask *)updateMultiredditWithName:(NSString *)name subreddits:(NSArray *)subreddits visibility:(RDKMultiredditVisibility)visibility completion:(RDKObjectCompletionBlock)completion
{
    return [self multiredditTaskWithMethod:@"PUT" name:name subreddits:subreddits visibility:visibility completion:completion];
}

- (NSURLSessionDataTask *)renameMultireddit:(RDKMultireddit *)multireddit to:(NSString *)newMultiredditName completion:(RDKCompletionBlock)completion
{
    return [self renameMultiredditWithName:multireddit.name to:newMultiredditName completion:completion];
}

- (NSURLSessionDataTask *)renameMultiredditWithName:(NSString *)multiredditName to:(NSString *)newMultiredditName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(multiredditName);
    NSParameterAssert(newMultiredditName);
    
    NSString *oldMultipath = [self pathForMultiredditWithName:multiredditName ownerName:self.currentUser.username];
    NSString *newMultipath = [self pathForMultiredditWithName:newMultiredditName ownerName:self.currentUser.username];
    
    NSDictionary *parameters = @{@"from": oldMultipath, @"to": newMultipath};
    
    return [self basicPostTaskWithPath:@"api/multi/rename" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)copyMultireddit:(RDKMultireddit *)multireddit fromUser:(RDKUser *)user newName:(NSString *)name completion:(RDKCompletionBlock)completion
{
    return [self copyMultiredditWithName:multireddit.name fromUserWithUsername:user.username newName:name completion:completion];
}

- (NSURLSessionDataTask *)copyMultiredditWithName:(NSString *)multiredditName fromUserWithUsername:(NSString *)username newName:(NSString *)name completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(multiredditName);
    NSParameterAssert(username);
    NSParameterAssert(name);
    
    NSString *currentMultipath = [self pathForMultiredditWithName:multiredditName ownerName:username];
    NSString *copiedMultipath = [self pathForMultiredditWithName:name ownerName:self.currentUser.username];
    
    NSDictionary *parameters = @{@"from": currentMultipath, @"to": copiedMultipath};
    
    return [self basicPostTaskWithPath:@"api/multi/copy" parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)deleteMultireddit:(RDKMultireddit *)multireddit completion:(RDKCompletionBlock)completion
{
    return [self deleteMultiredditWithName:multireddit.name completion:completion];
}

- (NSURLSessionDataTask *)deleteMultiredditWithName:(NSString *)multiredditName completion:(RDKCompletionBlock)completion
{
    NSString *multiredditPath = [self pathForMultiredditWithName:multiredditName ownerName:self.currentUser.username];
    NSString *path = [NSString stringWithFormat:@"api/multi%@", multiredditPath];
    NSDictionary *parameters = @{@"multireddit": multiredditPath};
    
    return [self deletePath:path parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        completion(error);
    }];
}

#pragma mark - Managing Multireddit Subreddits

- (NSURLSessionDataTask *)addSubreddit:(RDKSubreddit *)subreddit toMultireddit:(RDKMultireddit *)multireddit completion:(RDKCompletionBlock)completion
{
    return [self addSubredditWithName:subreddit.name toMultiredditWithName:multireddit.name completion:completion];
}

- (NSURLSessionDataTask *)addSubredditWithName:(NSString *)subredditName toMultiredditWithName:(NSString *)multiredditName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    NSParameterAssert(multiredditName);
    
    NSString *multiredditPath = [self pathForMultiredditWithName:multiredditName ownerName:self.currentUser.username];
    NSString *path = [NSString stringWithFormat:@"api/multi%@/r/%@", multiredditPath, subredditName];
    
    NSDictionary *model = @{@"name": subredditName};
    NSData *modelData = [NSJSONSerialization dataWithJSONObject:model options:kNilOptions error:nil];
    NSString *modelDataString = [[NSString alloc] initWithData:modelData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{@"model": modelDataString};
    
    return [self putPath:path parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        completion(error);
    }];
}

- (NSURLSessionDataTask *)removeSubreddit:(RDKSubreddit *)subreddit fromMultireddit:(RDKMultireddit *)multireddit completion:(RDKCompletionBlock)completion
{
    return [self removeSubredditWithName:subreddit.name fromMultiredditWithName:multireddit.name completion:completion];
}

- (NSURLSessionDataTask *)removeSubredditWithName:(NSString *)subredditName fromMultiredditWithName:(NSString *)multiredditName completion:(RDKCompletionBlock)completion
{
    NSParameterAssert(subredditName);
    NSParameterAssert(multiredditName);
    
    NSString *multiredditPath = [self pathForMultiredditWithName:multiredditName ownerName:self.currentUser.username];
    NSString *path = [NSString stringWithFormat:@"api/multi%@/r/%@", multiredditPath, subredditName];
    
    return [self deletePath:path parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        completion(error);
    }];
}

#pragma mark - Private

- (NSURLSessionDataTask *)multiredditTaskWithMethod:(NSString *)method name:(NSString *)name subreddits:(NSArray *)subreddits visibility:(RDKMultiredditVisibility)visibility completion:(RDKObjectCompletionBlock)completion
{
    NSParameterAssert(name);
    NSParameterAssert(subreddits);
    
    // Set up the initial request parameters:
    
    NSString *multiredditVisibility = (visibility == RDKMultiredditVisibilityPublic) ? @"public" : @"private";
    NSString *multiredditPath = [self pathForMultiredditWithName:name ownerName:self.currentUser.username];
    NSMutableArray *multiredditSubreddits = [[NSMutableArray alloc] initWithCapacity:subreddits.count];
    
    for (NSString *subreddit in subreddits)
    {
        NSDictionary *subredditDictionary = @{@"name": subreddit};
        [multiredditSubreddits addObject:subredditDictionary];
    }
    
    // Build the model parameter:
    
    NSDictionary *model = @{@"visibility": multiredditVisibility, @"subreddits": [multiredditSubreddits copy]};
    NSData *modelData = [NSJSONSerialization dataWithJSONObject:model options:kNilOptions error:nil];
    NSString *modelDataString = [[NSString alloc] initWithData:modelData encoding:NSUTF8StringEncoding];
    
    // Create the final path and parameters:
    
    NSString *path = [NSString stringWithFormat:@"api/multi%@", multiredditPath];
    NSDictionary *parameters = @{@"multipath": multiredditPath, @"model": modelDataString};
    
    // Fire off the request with the appropriate HTTP method:
    
    return [self taskWithMethod:method path:path parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        if (responseObject)
        {
            RDKMultireddit *multireddit = [RDKObjectBuilder objectFromJSON:responseObject];
            completion(multireddit, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSString *)pathForMultiredditWithName:(NSString *)name ownerName:(NSString *)ownerName
{
    return [NSString stringWithFormat:@"/user/%@/m/%@", ownerName, name];
}

@end
