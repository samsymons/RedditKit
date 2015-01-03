//
//  RKFullName.m
//  Pods
//
//  Created by Sam Symons on 2015-01-03.
//
//

#import "RKFullName.h"

@implementation RKFullName

- (instancetype)initWithFullName:(NSString *)fullName
{
    NSParameterAssert(fullName);
    
    if (self = [super init])
    {
        _fullName = fullName;
    }
    
    return self;
}

- (NSString *)identifier
{
    if ([self isValid]) {
        NSArray *components = [[self fullName] componentsSeparatedByString:@"_"];
        return components.lastObject;
    }
    
    return nil;
}

- (BOOL)isValid
{
    NSError *error = nil;
    
    NSString *pattern = @"t[0-9]_.+";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    
    if (error || self.fullName == nil)
    {
        return NO;
    }
    
    NSRange range = NSMakeRange(0, self.fullName.length);
    NSArray *matches = [expression matchesInString:self.fullName options:kNilOptions range:range];
    
    return ([matches count] > 0);
}

@end
