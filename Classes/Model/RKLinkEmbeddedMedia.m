//
//  RKLinkEmbeddedMedia.m
//  Pods
//
//  Created by Sam Symons on 2014-07-07.
//
//

#import "RKLinkEmbeddedMedia.h"

@implementation RKLinkEmbeddedMedia

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"type": @"type",
             @"authorName": @"oembed.author_name",
             @"authorURL": @"oembed.author_url",
             @"providerURL": @"oembed.provider_url",
             @"providerDescription": @"oembed.description",
             @"providerTitle": @"oembed.title",
             @"width": @"oembed.width",
             @"height": @"oembed.height",
             @"thumbnailWidth": @"oembed.thumbnail_width",
             @"thumbnailHeight": @"oembed.thumbnail_height",
             @"thumbnailURL": @"oembed.thumbnail_url"
             };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, type: %@, thumbnail URL: %@>", NSStringFromClass([self class]), self, self.type, self.thumbnailURL];
}

@end
