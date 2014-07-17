//
//  RKLinkEmbeddedMedia.h
//  Pods
//
//  Created by Sam Symons on 2014-07-07.
//
//

#import "Mantle.h"

@interface RKLinkEmbeddedMedia : MTLModel <MTLJSONSerializing>

/**
 The type of the provider, typically their domain name.
 
 @example "imgur.com" or "video"
 */
@property (nonatomic, copy) NSString *type;

/**
 The name of the content's author, if any.
 This is typically populated when viewing video content.
 */
@property (nonatomic, copy) NSString *authorName;

/**
 The URL to the content's author, if any.
 This is typically populated when viewing video content.
 */
@property (nonatomic, copy) NSString *authorURL;

/**
 The URL for the provider.
 
 @example "http://imgur.com"
 */
@property (nonatomic, strong) NSURL *providerURL;

/**
 The description of the provider.
 */
@property (nonatomic, copy) NSURL *providerDescription;

/**
 The title of the provider.
 This is the value you would see in the title bar when visiting the providerURL.
 */
@property (nonatomic, copy) NSURL *providerTitle;

/**
 The scaled-down width of the thumbnail.
 */
@property (nonatomic, assign) CGFloat width;

/**
 The scaled-down height of the thumbnail.
 */
@property (nonatomic, assign) CGFloat height;

/**
 The actual width of the thumbnail.
 */
@property (nonatomic, assign) CGFloat thumbnailWidth;

/**
 The actual width of the thumbnail.
 */
@property (nonatomic, assign) CGFloat thumbnailHeight;

/**
 The direct link to the thumbnail, in its full size.
 */
@property (nonatomic, strong) NSURL *thumbnailURL;

@end
