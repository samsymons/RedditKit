//
//  RKAccessToken.h
//  Pods
//
//  Created by Sam Symons on 25/06/15.
//
//

#import <Foundation/Foundation.h>

@interface RKAccessToken : NSObject

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, assign) NSUInteger duration;

@property (nonatomic, copy, readonly) NSString *tokenType;

@end
