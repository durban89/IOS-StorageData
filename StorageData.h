//
//  StorageData.h
//  xunYi7
//
//  Created by david on 13-6-28.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageData : NSObject<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

+(NSMutableData *)remoteFetchData:(NSString *)dataUrl;
+(NSMutableData *)localFetchData:(NSString *)dataUrl;
+(void) saveUploadImage:(UIImage *)image withName:(NSString *)imageName;
+(NSString *) uploadImage:(UIImage *)image withName:(NSString *)imageName;
+(NSString *) fetchUploadImagePath;
+(NSString *) fetchUploadImagePath:(NSString *)imageName;
+(void) removeUploadImage:(UIImage *)image withName:(NSString *)imageName;
+(NSString *)isFileExists:(NSString *)fullpath;
+(void) removeFile:(NSString *)filePath;
@end
