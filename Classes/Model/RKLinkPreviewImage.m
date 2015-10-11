// RKLinkPreviewImage.m
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

#import "RKLinkPreviewImage.h"
#import "RKImage.h"
#import "RKObjectBuilder.h"
#import "RKClient.h"

@implementation RKLinkPreviewImage

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"source": @"source",
        @"resolutions": @"resolutions",
        @"nsfwSource": @"variants.nsfw.source",
        @"nsfwResolutions": @"variants.nsfw.resolutions",
        @"identifier": @"id"
    };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, identifier: %@>", NSStringFromClass([self class]), self, self.identifier];
}

#pragma mark - MTLModel

+ (NSValueTransformer *)sourceJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *source) {
        NSError *error = nil;
        RKImage *imageObject = [MTLJSONAdapter modelOfClass:[RKImage class] fromJSONDictionary:source error:&error];

        if (error) {
            return nil;
        }
        else {
            return imageObject;
        }
    }];
}

+ (NSValueTransformer *)resolutionsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id resolutions) {
        NSMutableArray *images = [[NSMutableArray alloc] init];

        for (NSDictionary *imageJSON in resolutions)
        {
            NSError *error = nil;
            id model = [MTLJSONAdapter modelOfClass:[RKImage class] fromJSONDictionary:imageJSON error:&error];

            if (!error)
            {
                [images addObject:model];
            }
            else
            {
                NSLog(@"Failed to build image: %@", error);
            }
        }

        return [images copy];
    }];
}

+ (NSValueTransformer *)nsfwSourceJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *source) {
        NSError *error = nil;
        RKImage *imageObject = [MTLJSONAdapter modelOfClass:[RKImage class] fromJSONDictionary:source error:&error];

        if (error) {
            return nil;
        }
        else {
            return imageObject;
        }
    }];
}

+ (NSValueTransformer *)nsfwResolutionsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(id resolutions) {
        NSMutableArray *images = [[NSMutableArray alloc] init];

        for (NSDictionary *imageJSON in resolutions)
        {
            NSError *error = nil;
            id model = [MTLJSONAdapter modelOfClass:[RKImage class] fromJSONDictionary:imageJSON error:&error];

            if (!error)
            {
                [images addObject:model];
            }
            else
            {
                NSLog(@"Failed to build image: %@", error);
            }
        }

        return [images copy];
    }];
}

@end
