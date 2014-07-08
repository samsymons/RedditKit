// RKPagination.m
//
// Copyright (c) 2014 Sam Symons (http://samsymons.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RKPagination.h"

NSString * RKStringFromCommentSortingMethod(RKCommentSortingMethod sortingMethod)
{
    switch (sortingMethod)
    {
        case RKCommentSortingMethodTop:
            return @"top";
        case RKCommentSortingMethodBest:
            return @"best";
        case RKCommentSortingMethodNew:
            return @"new";
        case RKCommentSortingMethodHot:
            return @"hot";
        case RKCommentSortingMethodControversial:
            return @"controversial";
        case RKCommentSortingMethodOld:
            return @"old";
        default:
            return nil;
    }
}

NSString * RKStringFromTimeSortingMethod(RKTimeSortingMethod sortingMethod)
{
    switch (sortingMethod)
    {
        case RKTimeSortingMethodThisHour:
            return @"hour";
        case RKTimeSortingMethodToday:
            return @"day";
        case RKTimeSortingMethodThisWeek:
            return @"week";
        case RKTimeSortingMethodThisMonth:
            return @"month";
        case RKTimeSortingMethodThisYear:
            return @"year";
        case RKTimeSortingMethodAllTime:
            return @"all";
        default:
            return nil;
	}
}

NSString * RKStringFromUserContentSortingMethod(RKUserContentSortingMethod sortingMethod)
{
    switch (sortingMethod)
    {
        case RKUserContentSortingMethodNew:
            return @"new";
        case RKUserContentSortingMethodHot:
            return @"hot";
        case RKUserContentSortingMethodTop:
            return @"top";
        case RKUserContentSortingMethodControversial:
            return @"controversial";
        default:
            return nil;
    }
}

@implementation RKPagination

+ (RKPagination *)paginationFromListingResponse:(NSDictionary *)listingResponse
{
    RKPagination *pagination = [[RKPagination alloc] init];
    
    id before = [listingResponse valueForKeyPath:@"data.before"];
    id after = [listingResponse valueForKeyPath:@"data.after"];
    
    if (before == [NSNull null] && after == [NSNull null])
    {
        return nil;
    }
    
    if (before != [NSNull null])
    {
        pagination.before = before;
    }
    
    if (after != [NSNull null])
    {
        pagination.after = after;
    }
    
    return pagination;
}

+ (RKPagination *)paginationWithLimit:(NSUInteger)limit
{
    RKPagination *pagination = [[RKPagination alloc] init];
    
    pagination.limit = limit;
    
    return pagination;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _limit = 25;
    }
    
    return self;
}

- (void)setLimit:(NSUInteger)limit
{
    _limit = MIN(100, limit);
}

- (NSString *)description
{
    NSString *className = NSStringFromClass([self class]);
    return [NSString stringWithFormat:@"<%@: %p, before: %@, after: %@>", className, self, self.before, self.after];
}

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    if (self.limit)
    {
        [parameters setObject:[NSString stringWithFormat:@"%lu", (unsigned long)self.limit] forKey:@"limit"];
    }
    
    if (self.before)
    {
        [parameters setObject:self.before forKey:@"before"];
    }
    
    if (self.after)
    {
        [parameters setObject:self.after forKey:@"after"];
    }
    
    if (self.timeMethod)
    {
        [parameters setObject:RKStringFromTimeSortingMethod(self.timeMethod) forKey:@"t"];
    }
    
    if (self.userContentSortingMethod)
    {
        [parameters setObject:RKStringFromUserContentSortingMethod(self.userContentSortingMethod) forKey:@"sort"];
    }
    
    if ([parameters count] == 0)
    {
        return nil;
    }
    
    return [parameters copy];
}

@end
