//
//  NSString+Common.h
//  addsou
//
//  Created by 杨兆欣 on 2016/12/30.
//  Copyright © 2016年 杨兆欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string;

// 网络提示信息
+ (NSString *)promptStrWithStatus:(NSString *)status;

// 是否包含中文
- (BOOL)includeChinese;

// md5加密
- (NSString *)encryptWithMD5;

// 获取日期
+ (NSDateComponents *)getDateInfo;

// 手机号验证
-(BOOL)isMobilePhoneNumber;

// 删除标点符号
+ (NSString *)stringDeleteString:(NSString *)str;

@end
