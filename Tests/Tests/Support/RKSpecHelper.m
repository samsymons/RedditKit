//
//  RKSpecHelper.m
//  Tests
//
//  Created by Sam Symons on 11/5/2013.
//
//

#import "RKSpecHelper.h"

@implementation RKSpecHelper

+ (id)JSONFromLocalFileWithName:(NSString *)name
{
	NSData *data = [[self class] dataWithContentsOfLocalFileWithName:name];
	
	NSError *error = nil;
	id JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
	
	if (error)
	{
		return nil;
	}
	
	return JSON;
}

+ (NSString *)contentsOfLocalFileWithName:(NSString *)name
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *filePath = [bundle pathForResource:name ofType:@"json"];
    
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

+ (NSData *)dataWithContentsOfLocalFileWithName:(NSString *)name
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *filePath = [bundle pathForResource:name ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    return data;
}

@end
