// RKThing.h
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

@interface RKThing : MTLModel <MTLJSONSerializing>

/**
 A string identifier that indicates the object's type.
 This can be one of the follow types (these values are case sensitive):
 
 t1: Comment
 t2: Account
 t3: Link
 t4: Message
 t5: Subreddit
 */
@property (nonatomic, copy, readonly) NSString *kind;

/**
 A unique identifier for an object, in base 36.
 */
@property (nonatomic, copy, readonly) NSString *identifier;

/**
 The full name of the object, which is the object's kind and identifier joined by an underscore.
 Example: t3_15bfi0 is the full name of a link object.
 */
@property (nonatomic, copy, readonly) NSString *fullName;

@end
