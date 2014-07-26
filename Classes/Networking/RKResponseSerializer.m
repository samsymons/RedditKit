// RKResponseSerializer.m
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

#import "RKResponseSerializer.h"

#import "RKClient.h"
#import "RKClient+Errors.h"

@implementation RKResponseSerializer

- (instancetype)init
{
    if (self = [super init])
    {
        self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/css", nil];
    }
    
    return self;
}

#pragma mark - AFURLRequestSerialization

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError **)error
{
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Attempt to parse the JSON:
    
    NSError *parseError = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
    
    if (parseError) {
        NSError *responseError = [RKClient errorFromResponse:(NSHTTPURLResponse *)response responseString:responseString];
        
        if (responseError && error != NULL)
        {
            *error = responseError;
            return nil;
        }
    }
    else {
        NSError *responseError = [RKClient errorFromResponseObject:responseObject];
        
        if (responseError && error != NULL)
        {
            *error = responseError;
            return nil;
        }
    }
    
    return responseObject;
}

@end
