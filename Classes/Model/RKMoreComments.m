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
                               @"parentID": @"data.parent_id",
                               @"fullName": @"data.name", // set the fullName property immediately, so we return something like "t1_ce40nud", and not "more_ce40nud" (or <kind>_<identifier>).
                               @"count": @"data.count",
                               @"children": @"data.children"
                               };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:keyPaths];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, parentID: %@, fullName: %@, count: %li>", NSStringFromClass([self class]), self, self.parentID, self.fullName, (long)self.count];
}

@end
