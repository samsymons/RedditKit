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
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *commentsPath = [bundle pathForResource:name ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:commentsPath];
	
	NSError *error = nil;
	id JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
	
	if (error)
	{
		return nil;
	}
	
	return JSON;
}

@end
