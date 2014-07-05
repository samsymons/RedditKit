//
//  RKSpecHelper.h
//  Tests
//
//  Created by Sam Symons on 11/5/2013.
//
//

@interface RKSpecHelper : NSObject

+ (id)JSONFromLocalFileWithName:(NSString *)name;
+ (NSString *)contentsOfLocalFileWithName:(NSString *)name;

+ (NSData *)dataWithContentsOfLocalFileWithName:(NSString *)name;

@end
