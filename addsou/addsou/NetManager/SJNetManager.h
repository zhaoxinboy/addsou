//
//  SJNetManager.h
//  addsou
//
//  Created by 杨兆欣 on 2016/12/30.
//  Copyright © 2016年 杨兆欣. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCompletionHandle completionHandle:(void(^)(id responseObj, NSError *error))completionHandle

@interface SJNetManager : NSObject

/** 对AFHTTPSessionManager的GET请求方法进行了封装 */
+ (id)GET:(NSString *)path parameters:(NSMutableDictionary *)params completionHandle:(void(^)(id responseObj, NSError *error))completionHandle;

/** 对AFHTTPSessionManager的POST请求方法进行了封装 */
+ (id)POST:(NSString *)path parameters:(NSMutableDictionary *)params completionHandle:(void(^)(id responseObj, NSError *error))completionHandle;


/**
 *  为了应付某些服务器对于中文字符串不支持的情况，需要转化字符串为带有%号形势
 *
 *  @param path   请求的路径，即 ? 前面部分
 *  @param params 请求的参数，即 ? 号后面部分
 *
 *  @return 转化 路径+参数 拼接出的字符串中的中文为 % 号形势
 */
+ (NSString *)percentPathWithPath:(NSString *)path params:(NSDictionary *)params;


@end
