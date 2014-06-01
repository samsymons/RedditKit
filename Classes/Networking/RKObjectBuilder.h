// RKObjectBuilder.h
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

extern NSString * const kRKObjectTypeComment;
extern NSString * const kRKObjectTypeAccount;
extern NSString * const kRKObjectTypeLink;
extern NSString * const kRKObjectTypeMessage;
extern NSString * const kRKObjectTypeSubreddit;
extern NSString * const kRKObjectTypeMultireddit;
extern NSString * const kRKObjectTypeMultiredditDescription;
extern NSString * const kRKObjectTypeModeratorAction;
extern NSString * const kRKObjectTypeMore;

@interface RKObjectBuilder : NSObject

+ (instancetype)objectBuilder;

/**
 Takes a JSON dictionary from a reddit API response, figures out its class, then initializes and returns that object.
 */
+ (id)objectFromJSON:(NSDictionary *)JSON;

@end
