// RKClient+Requests.h
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
#import "AFHTTPSessionManager.h"

typedef void(^RKRequestCompletionBlock)(NSHTTPURLResponse *response, id responseObject, NSError *error);

@interface RKClient (Requests)

/**
 Many of reddit's API methods require a set of parameters and simply return an error if they fail, and nothing of value when they succeed.
 This method eliminates much of the repetition when writing methods around these methods.
 
 @param path The path to request.
 @param parameters The parameters to pass with the request.
 @param completion A block to execute at the end of the request.
 */
- (NSURLSessionDataTask *)basicPostTaskWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RKCompletionBlock)completion;

/**
 This method makes a request for a listing and converts the response into objects.
 
 @param path The path to request.
 @param parameters The parameters to pass with the request.
 @param pagination The optional pagination object.
 @param completion A block to execute at the end of the request.
 */
- (NSURLSessionDataTask *)listingTaskWithPath:(NSString *)path parameters:(NSDictionary *)parameters pagination:(RKPagination *)pagination completion:(RKListingCompletionBlock)completion;

/**
 This method makes a request for a listing and returns the full response.
 This is in contrast to listingTaskWithPath:parameters:pagination:completion: which returns
 a listing in its formatted state, with all JSON parsed.
 
 @param path The path to request.
 @param parameters The parameters to pass with the request.
 @param pagination The optional pagination object.
 @param completion A block to execute at the end of the request.
 */
- (NSURLSessionDataTask *)fullListingWithPath:(NSString *)path parameters:(NSDictionary *)parameters pagination:(RKPagination *)pagination completion:(RKObjectCompletionBlock)completion;

/**
 This method wraps around the 'api/friend' API, as many different methods are based on this endpoint.
 
 @param container The 'container' parameter.
 @param subredditName The 'r' parameter.
 @param name The 'name' parameter.
 @param type The 'type' parameter.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)friendTaskWithContainer:(NSString *)container subredditName:(NSString *)subredditName name:(NSString *)name type:(NSString *)type completion:(RKCompletionBlock)completion;

/**
 This method wraps around the 'api/unfriend' API, as many different methods are based on this endpoint.
 
 @param container The 'container' parameter.
 @param subredditName The 'r' parameter.
 @param name The 'name' parameter.
 @param type The 'type' parameter.
 @param completion An optional block to be executed upon request completion. Its only argument is any error that occurred.
 */
- (NSURLSessionDataTask *)unfriendTaskWithContainer:(NSString *)container subredditName:(NSString *)subredditName name:(NSString *)name type:(NSString *)type completion:(RKCompletionBlock)completion;

#pragma mark - Response Helpers

/**
 Extracts RKThing subclasses from a listing response.
 */
- (NSArray *)objectsFromListingResponse:(NSDictionary *)listingResponse;

#pragma mark - Request Helpers

- (NSURLSessionDataTask *)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RKRequestCompletionBlock)completion;
- (NSURLSessionDataTask *)postPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RKRequestCompletionBlock)completion;
- (NSURLSessionDataTask *)putPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RKRequestCompletionBlock)completion;
- (NSURLSessionDataTask *)deletePath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RKRequestCompletionBlock)completion;

/**
 A base request method for use throughout the library.
 
 @param method The method to use; one of 'GET', 'POST', 'PUT' or 'DELETE'.
 @param path The path to request.
 @param parameters The parameters to pass with the request.
 @param completion A block to execute at the end of the request.
 @return The newly created NSURLSessionDataTask.
 */
- (NSURLSessionDataTask *)taskWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters completion:(RKRequestCompletionBlock)completion;

@end
