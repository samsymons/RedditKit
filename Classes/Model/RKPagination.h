// RKPagination.h
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

typedef NS_ENUM(NSUInteger, RKCommentSortingMethod) {
    RKCommentSortingMethodTop = 1,
    RKCommentSortingMethodBest,
    RKCommentSortingMethodNew,
    RKCommentSortingMethodHot,
    RKCommentSortingMethodControversial,
    RKCommentSortingMethodOld
};

typedef NS_ENUM(NSUInteger, RKUserContentSortingMethod) {
    RKUserContentSortingMethodNew = 1,
    RKUserContentSortingMethodHot,
    RKUserContentSortingMethodTop,
    RKUserContentSortingMethodControversial
};

typedef NS_ENUM(NSUInteger, RKTimeSortingMethod) {
    RKTimeSortingMethodThisHour = 1,
    RKTimeSortingMethodToday,
    RKTimeSortingMethodThisWeek,
    RKTimeSortingMethodThisMonth,
    RKTimeSortingMethodThisYear,
    RKTimeSortingMethodAllTime
};

extern NSString * RKStringFromCommentSortingMethod(RKCommentSortingMethod sortingMethod);
extern NSString * RKStringFromTimeSortingMethod(RKTimeSortingMethod sortingMethod);
extern NSString * RKStringFromUserContentSortingMethod(RKUserContentSortingMethod sortingMethod);

@interface RKPagination : NSObject

/*
 The total number of things to return. This is 25 by default, and limited to 100.
 */
@property (nonatomic, assign) NSUInteger limit;

/**
 The full name of the thing for which other objects will be returned before.
 
 This property takes precedence over the `after` property.
 */
@property (nonatomic, copy) NSString *before;

/**
 The full name of the thing for which other objects will be returned after.
 */
@property (nonatomic, copy) NSString *after;

/**
 The sorting method for comments. This affects the order in which comments are returned.
 */
@property (nonatomic, assign) RKCommentSortingMethod commentSortingMethod;

/**
 The sorting method for user content. This affects the order in which user content is returned.
 
 @note Only the RKUserContentSortingMethodTop and RKUserContentSortingMethodControversial sorting methods are affected by the timeMethod property.
 */
@property (nonatomic, assign) RKUserContentSortingMethod userContentSortingMethod;

/**
 The timeframe to sort by. Only used if the subredditCategory is set to RKSubredditSortingMethodControversial or RKSubredditSortingMethodTop.
 */
@property (nonatomic, assign) RKTimeSortingMethod timeMethod;

/**
 Extracts a pagination object from a listing response.
 */
+ (RKPagination *)paginationFromListingResponse:(NSDictionary *)listingResponse;

/**
 Creates and returns a pagination object with default values, and a specied limit of objects to return.
 */
+ (RKPagination *)paginationWithLimit:(NSUInteger)limit;

/**
 Returns the pagination object as an NSDictionary.
 */
- (NSDictionary *)dictionaryValue;

@end
