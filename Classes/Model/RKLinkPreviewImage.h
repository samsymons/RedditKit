// RKLinkPreviewImage.h
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

#import "Mantle.h"

@class RKImage;

@interface RKLinkPreviewImage : MTLModel <MTLJSONSerializing>

/**
 The source of the image.
 */
@property (nonatomic, strong) RKImage *source;

/**
 An array of resolutions for the preview image. This array contains RKImage objects.
 */
@property (nonatomic, strong) NSArray *resolutions;

/**
 The source of the nsfw variant
 */
@property (nonatomic, strong) RKImage *nsfwSource;

/**
 An array of resolutions for the nsfw variant. This array contains RKImage objects.
 */
@property (nonatomic, strong) NSArray *nsfwResolutions;

/**
 The identifier of the preview image.
 */
@property (nonatomic, strong) NSString *identifier;

@end
