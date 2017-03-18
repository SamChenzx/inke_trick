//
//  SamCacheHelper.h
//  inke
//
//  Created by Sam on 12/16/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^clearCompletion)();

@interface SamCacheHelper : NSObject

+ (NSString *)getAdvertise;

+ (void) setAdvertise :(NSString *) advertiseImage;

+ (NSString *)cachesSize;                                      // get caches size
+ (NSString *)CachesDirectory;                                 // get caches directory
+ (unsigned long long)folderFileSizeAtPath:(NSString *)path;   // get folder size at specific path
+ (void)cleanCachesWithCompletion:(clearCompletion)completion; // clear cache at specific path

@end
