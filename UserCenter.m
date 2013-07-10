//
//  UserCenter.m
//  xunYi7
//
//  Created by david on 13-7-10.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "UserCenter.h"

@implementation UserCenter

/**
 * @description 存储微博登录的信息
 */
+(BOOL)saveWeiboAuth:(NSDictionary *)params{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              [params objectForKey:@"access_token"], @"AccessTokenKey",
                              [params objectForKey:@"expires_in"], @"ExpirationDateKey",
                              [params objectForKey:@"uid"], @"UserIDKey",
                              [params objectForKey:@"access_token"], @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //微博的时间戳的转换
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"ExpirationDateKey = %@",[[accountDefaults objectForKey:@"SinaWeiboAuthData"] objectForKey:@"ExpirationDateKey"]);
    return YES;
}

/**
 * @description 获取微博登录的过期时间
 */
+(NSDate *)fetchWeiboExpireDate{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    if([accountDefaults objectForKey:@"SinaWeiboAuthData"] != nil){
        return [[accountDefaults objectForKey:@"SinaWeiboAuthData"] valueForKey:@"ExpirationDateKey"];
    }
    return nil;
}

/**
 * @description 获取微博登录的AccessToken
 */
+(NSString *)fetchWeiboAccessToken{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    if([accountDefaults objectForKey:@"SinaWeiboAuthData"] != nil){
        return [[accountDefaults objectForKey:@"SinaWeiboAuthData"] valueForKey:@"AccessTokenKey"];
    }
    return nil;
}

/**
 * @description 获取登录的微博用户的id
 */
+(NSString *)fetchWeiboUid{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    if([accountDefaults objectForKey:@"SinaWeiboAuthData"] != nil){
        return [[accountDefaults objectForKey:@"SinaWeiboAuthData"] valueForKey:@"UserIDKey"];
    }
    return nil;
}

/**
 * @description 判断是否过期
 */
+(BOOL)isOutDate{
    //现在时刻的时间戳
    NSDate *newDate =[NSDate date];
    NSString *timeStamp =[NSString stringWithFormat:@"%lu", (long)[newDate timeIntervalSince1970]];
    
    //微博的时间戳的转换
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    
    
    if([accountDefaults objectForKey:@"SinaWeiboAuthData"] == nil){
        return YES;
    }
    
    if([[accountDefaults objectForKey:@"SinaWeiboAuthData"] objectForKey:@"ExpirationDateKey"] == nil){
        return YES;
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSDate *weiBoDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[[accountDefaults objectForKey:@"SinaWeiboAuthData"] objectForKey:@"ExpirationDateKey"]]];
    
    NSLog(@"weiBoDate ExpirationDateKey = %@",[[accountDefaults objectForKey:@"SinaWeiboAuthData"] objectForKey:@"ExpirationDateKey"]);
//    NSString *weiBoDateStamp = [NSString stringWithFormat:@"%lu", (long) [weiBoDate timeIntervalSince1970]];
    NSString *weiBoDateStamp = [NSString stringWithFormat:@"%@",[[accountDefaults objectForKey:@"SinaWeiboAuthData"] objectForKey:@"ExpirationDateKey"]];
    
    
    
    NSLog(@"weiBoDateStamp=%@, timeStamp = %@",[[accountDefaults objectForKey:@"SinaWeiboAuthData"] objectForKey:@"ExpirationDateKey"],timeStamp);
    if([timeStamp compare:weiBoDateStamp] < 0){//未过期
        return NO;
    }else{//已经过期
        [self removeWeiboAuthData];
        return YES;
    }
    return NO;
}

/**
 * @description 移出微博的登录的cookie信息
 */
+(void)removeWeiboAuthCookieData{
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* sinaweiboCookies = [cookies cookiesForURL:
                                 [NSURL URLWithString:@"https://open.weibo.cn"]];
    
    for (NSHTTPCookie* cookie in sinaweiboCookies)
    {
        [cookies deleteCookie:cookie];
    }
}


/**
 * @description 移出微博的登录的信息
 */
+(void)removeWeiboAuthData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}
@end
