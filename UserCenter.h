//
//  UserCenter.h
//  xunYi7
//
//  Created by david on 13-7-10.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenter : NSObject
+(BOOL)saveWeiboAuth:(NSDictionary *)params;
+(NSDate *)fetchWeiboExpireDate;
+(NSString *)fetchWeiboAccessToken;
+(NSString *)fetchWeiboUid;
+(BOOL)isOutDate;
+(void)removeWeiboAuthCookieData;
+(void)removeWeiboAuthData;
@end
