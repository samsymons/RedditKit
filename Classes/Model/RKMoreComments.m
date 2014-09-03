//
//  RKMoreComments.m
//  Pods
//
//  Created by Sam Symons on 2014-09-02.
//
//

#import "RKMoreComments.h"

@interface RKMoreComments ()

@property (nonatomic, strong) NSString *actualFullName;

@end

@implementation RKMoreComments

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
                               @"count": @"data.count",
                               @"parentFullName": @"data.parent_id",
                               @"childIdentifiers": @"data.children",
                               @"actualFullName": @"data.name"
                               };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:keyPaths];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, full name: %@, count: %lu>", NSStringFromClass([self class]), self, self.fullName, (unsigned long)self.count];
}

- (NSString *)fullName
{
    return self.actualFullName;
}

@end
