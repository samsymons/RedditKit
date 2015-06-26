//
//  RKTrophy.h
//  Pods
//
//  Created by Sam Symons on 25/06/15.
//
//

#import "RKThing.h"

@interface RKTrophy : RKThing

@property (nonatomic, copy, readonly) NSString *trophyIdentifier;

@property (nonatomic, copy, readonly) NSString *trophyName;
@property (nonatomic, copy, readonly) NSString *trophyDescription;
@property (nonatomic, copy, readonly) NSString *trophyPath;

@property (nonatomic, copy, readonly) NSURL *smallIconURL;
@property (nonatomic, copy, readonly) NSURL *largeIconURL;

@end
