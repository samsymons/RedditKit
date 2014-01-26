// RDKPagination.m
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

#import "RDKPagination.h"

NSString * NSStringFromCommentSortingMethod(RDKCommentSortingMethod sortingMethod)
{
    switch (sortingMethod)
    {
        case RDKCommentSortingMethodTop:
            return @"top";
        case RDKCommentSortingMethodBest:
            return @"best";
        case RDKCommentSortingMethodNew:
            return @"new";
        case RDKCommentSortingMethodHot:
            return @"hot";
        case RDKCommentSortingMethodControversial:
            return @"controversial";
        case RDKCommentSortingMethodOld:
            return @"old";
        default:
            return nil;
    }
}

NSString * NSStringFromTimeSortingMethod(RDKTimeSortingMethod sortingMethod)
{
    switch (sortingMethod)
    {
        case RDKTimeSortingMethodThisHour:
            return @"hour";
        case RDKTimeSortingMethodToday:
            return @"day";
        case RDKTimeSortingMethodThisWeek:
            return @"week";
        case RDKTimeSortingMethodThisMonth:
            return @"month";
        case RDKTimeSortingMethodThisYear:
            return @"year";
        case RDKTimeSortingMethodAllTime:
            return @"all";
        default:
            return nil;
	}
}

NSString * NSStringFromUserContentSortingMethod(RDKUserContentSortingMethod sortingMethod)
{
    switch (sortingMethod)
    {
        case RDKUserContentSortingMethodNew:
            return @"new";
        case RDKUserContentSortingMethodHot:
            return @"hot";
        case RDKUserContentSortingMethodTop:
            return @"top";
        case RDKUserContentSortingMethodControversial:
            return @"controversial";
        default:
            return nil;
    }
}

@implementation RDKPagination

+ (RDKPagination *)paginationFromListingResponse:(NSDictionary *)listingResponse
{
    RDKPagination *pagination = [[RDKPagination alloc] init];
    
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

+ (RDKPagination *)paginationWithLimit:(NSUInteger)limit
{
    RDKPagination *pagination = [[RDKPagination alloc] init];
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
    if (limit > 100)
    {
        _limit = 100;
    }
    else
    {
        _limit = limit;
    }
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
        [parameters setObject:NSStringFromTimeSortingMethod(self.timeMethod) forKey:@"t"];
    }
    
    if (self.userContentSortingMethod)
    {
        [parameters setObject:NSStringFromUserContentSortingMethod(self.userContentSortingMethod) forKey:@"sort"];
    }
    
    if ([parameters count] == 0)
    {
        return nil;
    }
    
    return [parameters copy];
}

@end
