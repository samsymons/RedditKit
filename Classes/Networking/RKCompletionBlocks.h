// RKCompletionBlocks.h
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

@class RKPagination;

/**
 A standard completion block, which either fails or doesn't.
 */
typedef void (^RKCompletionBlock)(NSError *error);

/**
 A completion block for boolean responses, such as determining whether a user is required to complete a CAPTCHA or not.
 */
typedef void (^RKBooleanCompletionBlock)(BOOL result, NSError *error);

/**
 An object completion block, when retrieving resources that return a single object.
 */
typedef void (^RKObjectCompletionBlock)(id object, NSError *error);

/**
 An array completion block, when retrieving collections of objects.
 */
typedef void (^RKArrayCompletionBlock)(NSArray *collection, NSError *error);

/**
 A listing completion block, when retrieving collections which implement pagination.
 */
typedef void (^RKListingCompletionBlock)(NSArray *collection, RKPagination *pagination, NSError *error);
