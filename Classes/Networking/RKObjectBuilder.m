// RKObjectBuilder.m
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

#import "RKObjectBuilder.h"
#import "Mantle.h"
#import "RKClient.h"
#import "RKThing.h"
#import "RKUser.h"
#import "RKComment.h"
#import "RKLink.h"
#import "RKSubreddit.h"
#import "RKMessage.h"
#import "RKMultireddit.h"
#import "RKMultiredditDescription.h"
#import "RKModeratorAction.h"

NSString * const kRKObjectTypeComment = @"t1";
NSString * const kRKObjectTypeAccount = @"t2";
NSString * const kRKObjectTypeLink = @"t3";
NSString * const kRKObjectTypeMessage = @"t4";
NSString * const kRKObjectTypeSubreddit = @"t5";
NSString * const kRKObjectTypeMultireddit = @"LabeledMulti";
NSString * const kRKObjectTypeMultiredditDescription = @"LabeledMultiDescription";
NSString * const kRKObjectTypeModeratorAction = @"modaction";
NSString * const kRKObjectTypeMore = @"more";

@interface RKObjectBuilder ()

- (Class)classForObjectKind:(NSString *)objectKind;

@end

@implementation RKObjectBuilder

+ (instancetype)objectBuilder
{
    static RKObjectBuilder *objectBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objectBuilder = [[RKObjectBuilder alloc] init];
    });
    
    return objectBuilder;
}

+ (id)objectFromJSON:(NSDictionary *)JSON
{
    NSString *kind = JSON[@"kind"];
    
    Class objectClass = [[RKObjectBuilder objectBuilder] classForObjectKind:kind];
    
    if (!objectClass)
    {
        return nil;
    }
    
    // Check for a specific attribute if the object's class was equal to RKComment.
    // This is because, when fetching a user's messages, comment replies are given to us with the kRKObjectTypeComment type.
    // Instead, the JSON of comment replies matches that of actual RKMessages.
    
    if (objectClass == [RKComment class])
    {
        if ([JSON valueForKeyPath:@"data.was_comment"])
        {
            objectClass = [RKMessage class];
        }
    }
    
    // Continue with building:
    
    NSError *error = nil;
    id model = [MTLJSONAdapter modelOfClass:objectClass fromJSONDictionary:JSON error:&error];
    
    if (!error)
    {
        return model;
    }
    else
    {
        NSLog(@"Failed to build model: %@", error);
        return nil;
    }
}

#pragma mark - Private

- (Class)classForObjectKind:(NSString *)objectKind
{
    if ([objectKind isEqualToString:kRKObjectTypeComment])
    {
        return [RKComment class];
    }
    else if ([objectKind isEqualToString:kRKObjectTypeAccount])
    {
        return [RKUser class];
    }
    else if ([objectKind isEqualToString:kRKObjectTypeLink])
    {
        return [RKLink class];
    }
    else if ([objectKind isEqualToString:kRKObjectTypeMessage])
    {
        return [RKMessage class];
    }
    else if ([objectKind isEqualToString:kRKObjectTypeMultireddit])
    {
        return [RKMultireddit class];
    }
    else if ([objectKind isEqualToString:kRKObjectTypeSubreddit])
    {
        return [RKSubreddit class];
    }
    else if ([objectKind isEqualToString:kRKObjectTypeMultiredditDescription])
    {
        return [RKMultiredditDescription class];
    }
    else if ([objectKind isEqualToString:kRKObjectTypeModeratorAction])
    {
        return [RKModeratorAction class];
    }
    else if ([objectKind isEqualToString:kRKObjectTypeMore])
    {
        // TODO: Add support for the More type.
    }
    
    return nil;
}

@end
