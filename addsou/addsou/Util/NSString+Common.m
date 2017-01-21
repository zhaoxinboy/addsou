//
//  NSString+Common.m
//  addsou
//
//  Created by 杨兆欣 on 2016/12/30.
//  Copyright © 2016年 杨兆欣. All rights reserved.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation NSString (Common)

// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

// 网络提示信息
+ (NSString *)promptStrWithStatus:(NSString *)status{
    NSString *promptStr = nil;
    if ([status isEqualToString:@"2000"]) {
        promptStr = @"未找到相关数据";
    }else if ([status isEqualToString:@"2001"]){
        promptStr = @"用户公司未找到";
    }else if ([status isEqualToString:@"2002"]){
        promptStr = @"传入参数缺少key";
    }else if ([status isEqualToString:@"2003"]){
        promptStr = @"传入参数为空";
    }else if ([status isEqualToString:@"2004"]){
        promptStr = @"登录失败，用户密码错误";
    }else if ([status isEqualToString:@"2005"]){
        promptStr = @"请求方式错误";
    }else if ([status isEqualToString:@"2006"]){
        promptStr = @"服务器内部错误";
    }else if ([status isEqualToString:@"2007"]){
        promptStr = @"抱歉您还没有登录";
    }else if ([status isEqualToString:@"2008"]){
        promptStr = @"传入type类型错误或获取不到序列号";
    }else if ([status isEqualToString:@"2009"]){
        promptStr = @"不符合唯一性检";
    }else if ([status isEqualToString:@"2010"]){
        promptStr = @"您不能通过此方式登录";
    }else if ([status isEqualToString:@"2011"]){
        promptStr = @"无此手机用户";
    }else if ([status isEqualToString:@"2012"]){
        promptStr = @"帐号密码不正确";
    }else if ([status isEqualToString:@"2013"]){
        promptStr = @"帐号密码不正确";
    }else if ([status isEqualToString:@"2014"]){
        promptStr = @"无此手机用户";
    }else if ([status isEqualToString:@"2015"]){
        promptStr = @"无此用户";
    }else if ([status isEqualToString:@"2016"]){
        promptStr = @"手机号格式错误";
    }else if ([status isEqualToString:@"2017"]){
        promptStr = @"验证码发送失败";
    }else if ([status isEqualToString:@"2018"]){
        promptStr = @"验证码获取频繁";
    }else if ([status isEqualToString:@"2019"]){
        promptStr = @"验证码校验失败";
    }else if ([status isEqualToString:@"2020"]){
        promptStr = @"您已注册过,请登录或通过忘记密码找回";
    }else if ([status isEqualToString:@"3006"]){
        promptStr = @"获取auth错误";
    }else if ([status isEqualToString:@"3007"]){
        promptStr = @"无法获取权限";
    }else if ([status isEqualToString:@"3008"]){
        promptStr = @"权限校验错误";
    }
    return promptStr;
}

// 是否包含中文
- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

// md5加密
- (NSString *)encryptWithMD5{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i< CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x",digest[i]];
    }
    return result.copy;
}

/**
 *    NSCalendarUnitWeekday
 *     获取指定日期的年，月，日，星期，时,分,秒信息
 */
+ (NSDateComponents *)getDateInfo
{
    NSDate * date  = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSGregorianCalendar
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:date];
    
    DLog(@"年 = year = %ld",comps.year);
    DLog(@"月 = month = %ld",comps.month);
    DLog(@"日 = day = %ld",comps.day);
    DLog(@"时 = hour = %ld",comps.hour);
    DLog(@"分 = minute = %ld",comps.minute);
    DLog(@"秒 = second = %ld",comps.second);
    DLog(@"星期 =weekDay = %ld ",comps.weekday);
    return comps;
}

// 手机号验证
-(BOOL)isMobilePhoneNumber{
    if (self.length < 11){
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}


@end
