//
//  RKFullName.h
//  Pods
//
//  Created by Sam Symons on 2015-01-03.
//
//

#import <Foundation/Foundation.h>

@interface RKFullName : NSObject

@property (nonatomic, strong) NSString *fullName;

- (instancetype)initWithFullName:(NSString *)fullName;

/**
 Returns the full name's identifier, stripped of its `kind` value.
 
 @return The full name's identifier.
 */
- (NSString *)identifier;

/**
 Whether the full name is of a valid format.
 
 @return Whether the full name is valid.
 */
- (BOOL)isValid;

@end
