//
//  RKTrophy.m
//  Pods
//
//  Created by Sam Symons on 25/06/15.
//
//

#import "RKTrophy.h"

@implementation RKTrophy

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
                               @"trophyIdentifier": @"data.award_id",
                               @"trophyDescription": @"data.description",
                               @"trophyName": @"data.name",
                               @"trophyPath": @"data.url",
                               @"smallIconURL": @"data.icon_40",
                               @"largeIconURL": @"data.icon_70"
                               };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:keyPaths];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, trophy name: %@>", NSStringFromClass([self class]), self, self.trophyName];
}

@end
