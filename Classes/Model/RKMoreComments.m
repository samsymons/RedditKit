//
//  RKMoreComments.m
//  Pods
//
//  Created by Sam Symons on 2014-09-02.
//
//

#import "RKMoreComments.h"

@implementation RKMoreComments

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
                               @"count": @"data.count",
                               @"parentFullName": @"data.parent_id",
                               @"childIdentifiers": @"data.children"
                               };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:keyPaths];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, full name: %@, count: %lui>", NSStringFromClass([self class]), self, self.fullName, (unsigned long)self.count];
}

@end
