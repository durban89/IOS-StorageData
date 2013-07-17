//
//  StorageData.h
//  xunYi7
//
//  Created by david on 13-6-28.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageData : NSObject<NSURLConnectionDataDelegate, NSURLConnectionDelegate>{
    id<NSURLConnectionDataDelegate>delegate;
}

#pragma mark - 获取远程数据
+(NSMutableData *)remoteFetchData:(NSString *)dataUrl;
#pragma mark - 获取本地数据
+(NSMutableData *)localFetchData:(NSString *)dataUrl;
#pragma mark - 获取本地数据的Dcitionary格式-艺人排行榜
+(NSDictionary *) localFetchPersonRankDictionayData:(NSString *)dataUrlString;
#pragma mark - 获取本地数据的Dcitionary格式-艺人签到排行
+(NSDictionary *) localFetchStarkCheckDictionayData:(NSString *)dataUrlString;
#pragma mark - 获取本地数据的Dcitionary格式-hotTeleplay
+(NSDictionary *) localFetchHotTeleplayDictionayData:(NSString *)dataUrlString;
#pragma mark - 获取本地数据的Dcitionary格式-找演员
+(NSDictionary *) localFetchFindPerformersDictionayData:(NSString *)dataUrlString;
#pragma mark - 获取远程数据的Dcitionary格式-找演员
+(NSDictionary *) remoteFetchFindPerformersDictionayData:(NSString *)dataUrlString;
#pragma mark - 获取本地数据的Dcitionary格式-电视剧排行榜
+(NSDictionary *) localFetchTeleplayRankDictionayData:(NSString *)dataUrlString;
#pragma mark - 获取本地数据的Dcitionary格式-关注列表
+(NSDictionary *) localFetchAttentionListDictionayData:(NSString *)dataUrlString;
#pragma mark - 获取远程数据的Dcitionary格式-关注列表
+(NSDictionary *) remoteFetchAttentionListDictionayData:(NSString *)dataUrlString;
#pragma mark - 获取本地数据的Dcitionary格式-机会列表
+(NSDictionary *) localFetchChanceListDictionayData:(NSString *)dataUrlString;
#pragma mark - 存储Dictionary格式的数据到本地-艺人排行版
+(void) savePersonRankDictionaryToLocal:(NSMutableDictionary *)data dataUrlString:(NSString *)urlString;
#pragma mark - 保存上传的图片
+(void) saveUploadImage:(UIImage *)image withName:(NSString *)imageName;
#pragma mark - 上传图片
+(NSString *) uploadImage:(UIImage *)image withName:(NSString *)imageName;
#pragma mark - 获取上传图片的路径
+(NSString *) fetchUploadImagePath;
#pragma mark - 获取上传图片的路径
+(NSString *) fetchUploadImagePath:(NSString *)imageName;
#pragma mark - 删除上传图片
+(void) removeUploadImage:(UIImage *)image withName:(NSString *)imageName;
#pragma mark - 判断上传的图片是否存在
+(NSString *)isFileExists:(NSString *)fullpath;
#pragma mark - 删除文件
+(void) removeFile:(NSString *)filePath;
@end
