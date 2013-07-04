//
//  StorageData.m
//  xunYi7
//
//  Created by david on 13-6-28.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "StorageData.h"
#import "xunYi7AppDelegate.h"

@implementation StorageData

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"开始结didReceiveData搜数据");
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"开始结didReceiveResponse搜数据");
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"connectionDidFinishLoading");
}

+(NSMutableData *)remoteFetchData:(NSString *)dataUrl{
    NSString *currentDataFilePath = [[self dataPath] stringByAppendingPathComponent:[self fetchTodayDate]];
    
    //创建目录
    currentDataFilePath = [self createDirectory:currentDataFilePath];
    
    currentDataFilePath = [currentDataFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[self md5:dataUrl]]];
    
    if([xunYi7AppDelegate isReachable]){
        NSURL *url = [[NSURL alloc] initWithString:dataUrl];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                  timeoutInterval:60];
        
        NSURLResponse *response = [[NSURLResponse alloc] init];
        NSError *receiveDataError = [[NSError alloc] init];
        
        NSMutableData *receivedData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request
                                                                             returningResponse:&response
                                                                                         error:&receiveDataError];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        return receivedData;
    }else{
        [xunYi7AppDelegate showNetworkMessage];
    }

    return nil;
}

+(NSMutableData *)localFetchData:(NSString *)dataUrl{
    
    NSString *currentDataFilePath = [[self dataPath] stringByAppendingPathComponent:[self fetchTodayDate]];
    NSString *yesterdayDataFilePath = [[self dataPath] stringByAppendingPathComponent:[self fetchYesterdayDate]];
    
    //创建目录
    currentDataFilePath = [self createDirectory:currentDataFilePath];
    
    currentDataFilePath = [currentDataFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[self md5:dataUrl]]];
    yesterdayDataFilePath = [yesterdayDataFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[self md5:dataUrl]]];
    
    NSMutableData *localData = [self fromFilenamePathFetchLocalData:currentDataFilePath];
    
    if(localData != nil){//本地数据
        return localData;
        
    }else{//远程获取数据
        
        NSMutableData *receivedData = [self remoteFetchData:dataUrl];
        
        if(receivedData != nil){
            if([self storageDataToFile:receivedData fileName:currentDataFilePath]){
                NSLog(@"保存成功");
                [self removeDirectory];
            }else{
                NSLog(@"保存失败");
            }
        }else{
            if((localData = [self fromFilenamePathFetchLocalData:yesterdayDataFilePath]) != nil){
                return localData;
            }
        }
        return receivedData;
    }
    return nil;
}

//md5加密字符串
+(NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}
//上传图片存储
+(void) saveUploadImage:(UIImage *)image withName:(NSString *)imageName{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error;
    
    // 获取沙盒目录
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    fullPath = [fullPath stringByAppendingPathComponent:@"tmpImage"];
    if(![fileManager fileExistsAtPath:fullPath]){
        [fileManager createDirectoryAtPath:fullPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
    }
   
    fullPath = [fullPath stringByAppendingPathComponent:imageName];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

//上传图片删除
+(void) removeUploadImage:(UIImage *)image withName:(NSString *)imageName{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error;
    
    // 获取沙盒目录
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    fullPath = [fullPath stringByAppendingPathComponent:@"tmpImage"];
    if(![fileManager fileExistsAtPath:fullPath]){
        [fileManager removeItemAtPath:fullPath error:&error];
    }
}

//获取存储的图片
+(NSString *)fetchUploadImagePath:(NSString *)imageName{
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    fullPath = [fullPath stringByAppendingPathComponent:@"tmpImage"];
    fullPath = [fullPath stringByAppendingPathComponent:imageName];
    return fullPath;
}

//判断文件是否存在
+(NSString *)isFileExists:(NSString *)fullpath{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if([fileManager fileExistsAtPath:fullpath]){
        return fullpath;
    }
    return nil;
}

//数据存储
//+(void)

//获取存储文件的目录
+(NSString *)dataPath{
    //此处首先指定了图片存取路径（默认写到应用程序沙盒 中）
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //并给文件起个文件名
    NSString *filePathDerectory = [paths objectAtIndex:0];
    
    return filePathDerectory;
}

//获取指定文件的数据
+(NSMutableData *)fromFilenamePathFetchLocalData:(NSString *)filename{
    //保存数据到指定文件中
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if([fileManager fileExistsAtPath:filename]){
        NSData *data = [fileManager contentsAtPath:filename];
        return [data mutableCopy];
    }
    
    return nil;
}

//存储数据到指定文件
+(BOOL) storageDataToFile:(NSData *)data fileName:(NSString *)fileName{
    //保存数据到指定文件中
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if([fileManager createFileAtPath:fileName contents:data attributes:nil]){
        return YES;
    }else{
        return NO;
    }
}

//删除文件
+(void) deleteFile:(NSString *)fileName{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error;
    [fileManager removeItemAtPath:fileName error:&error];
}

//获取今天的日期
+(NSString *) fetchTodayDate{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:currentDate];
}

//获取昨天的日期
+(NSString *) fetchYesterdayDate{
    NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(24 * 60 * 60)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:yesterdayDate];
}

//获取前天的日期
+(NSString *) fetchYesterdayBeforeDate{
    NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(2 * (24 * 60 * 60))];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:yesterdayDate];
}

//获取存储文件的数据

//创建文件

//创建目录
+(NSString *) createDirectory:(NSString *)directoryName{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error;
    if(![fileManager fileExistsAtPath:directoryName]){
        [fileManager createDirectoryAtPath:directoryName
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
        if(error == nil){
            return directoryName;
        }else{
            return directoryName;
        }
    }else{
        return directoryName;
    }
}
//删除文件
+(void) removeFile:(NSString *)filePath{
    NSError *error;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if([fileManager fileExistsAtPath:filePath]){
        [fileManager removeItemAtPath:filePath error:&error];
    }
    if(error){
        NSLog(@"error = %@",error);
    }
}

//删除目录
+(void) removeDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *removeDirectoryPath = [documentsPath stringByAppendingPathComponent:[self fetchYesterdayBeforeDate]];
    NSError *error;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if([fileManager fileExistsAtPath:removeDirectoryPath]){
        [fileManager removeItemAtPath:removeDirectoryPath error:&error];
    }
    if(error){
        NSLog(@"error = %@",error);
    }
}
@end
