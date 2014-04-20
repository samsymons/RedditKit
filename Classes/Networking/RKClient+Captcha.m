// RKClient+Captcha.m
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

#import "RKClient+Captcha.h"
#import "RKClient+Requests.h"

@implementation RKClient (Captcha)

- (NSURLSessionTask *)needsCaptchaWithCompletion:(RKBooleanCompletionBlock)completion
{
    return [self getPath:@"api/needs_captcha.json" parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (completion)
        {
            completion([responseObject boolValue], nil);
        }
    }];
}

- (NSURLSessionDataTask *)newCaptchaIdentifierWithCompletion:(RKObjectCompletionBlock)completion
{
    return [self postPath:@"api/new_captcha" parameters:nil completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (responseObject)
        {
            NSArray *responseArray = responseObject[@"jquery"];
            NSArray *outerArray = [responseArray lastObject];
            NSArray *catpchaWrapperArray = [outerArray lastObject];
            NSString *captchaValue = [catpchaWrapperArray lastObject];
            
            if (completion)
            {
                completion(captchaValue, nil);
            }
        }
        else
        {
            if (completion)
            {
                completion(nil, error);
            }
        }
    }];
}

- (NSURL *)URLForCaptchaWithIdentifier:(NSString *)identifier
{
    NSParameterAssert(identifier);
    
    NSString *path = [NSString stringWithFormat:@"http://reddit.com/captcha/%@.png", identifier];
    
    return [NSURL URLWithString:path];
}

- (NSURLSessionDataTask *)imageForCaptchaIdentifier:(NSString *)identifier completion:(RKObjectCompletionBlock)completion
{
    NSParameterAssert(identifier);
    
    NSURL *imageURL = [self URLForCaptchaWithIdentifier:identifier];
    NSError *serializerError;
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:imageURL.absoluteString parameters:nil error:&serializerError];
    
    if (serializerError) {
        completion(nil, serializerError);
        return nil;
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!completion)
        {
            return;
        }
        
        __weak __typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error)
            {
                completion([weakSelf imageFromData:data], nil);
            }
            else
            {
                completion(nil, error);
            }
        });
    }];
    
    [task resume];
    
    return task;
}

#pragma mark - Private

- (id)imageFromData:(NSData *)imageData
{
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    return [UIImage imageWithData:imageData];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    NSBitmapImageRep *bitimage = [[NSBitmapImageRep alloc] initWithData:imageData];
    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize([bitimage pixelsWide], [bitimage pixelsHigh])];
    [image addRepresentation:bitimage];
    
    return image;
#endif
}

@end
