//
//  SamCacheHelper.m
//  inke
//
//  Created by Sam on 12/16/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamCacheHelper.h"

#define adImage @"advertiseImage"

@implementation SamCacheHelper

+ (NSString *)getAdvertise
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:adImage];
}

+ (void)setAdvertise:(NSString *)advertiseImage
{
    
    [[NSUserDefaults standardUserDefaults] setObject:advertiseImage forKey:@"advertiseImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)cachesSize
{
    return [self sizeStringAtPath:[self cachesDirectory]];
}

+ (NSString *)cachesDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (unsigned long long)singleFileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        unsigned long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

+ (unsigned long long)folderFileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExisting = [fileManager fileExistsAtPath:path];
    
    if (isExisting){
        NSEnumerator *childFileEnumerator = [[fileManager subpathsAtPath:path] objectEnumerator];
        unsigned long long folderSize = 0;
        NSString *fileName = @"";
        while ((fileName = [childFileEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self singleFileSizeAtPath:fileAbsolutePath];
        }
        return folderSize;
    } else {
        NSLog(@"File does not exist");
        return 0;
    }
}

+ (NSString *)sizeStringAtPath:(NSString *)path
{
    unsigned long long folderSize = [self folderFileSizeAtPath:path];
    NSString *sizeString = [NSByteCountFormatter stringFromByteCount:folderSize countStyle:NSByteCountFormatterCountStyleFile];
    NSLog(@"Folder size: %@",sizeString);
    return sizeString;
}

+ (void)clearCache:(NSString *)path completion:(clearCompletion)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0 ), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            NSArray *childerFiles = [fileManager subpathsAtPath:path];
            for (NSString *fileName in childerFiles) {
                NSError *error = nil;
                NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:&error];
                //if (error) NSLog(@"Delete abortively！error = %@",error);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    });
}

+ (void)cleanCachesWithCompletion:(clearCompletion)completion
{
    [self clearCache:[self cachesDirectory] completion:^() {
        completion();
    }];
}




@end
