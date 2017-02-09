//
//  SJWebViewController.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJBaseViewController.h"

@interface SJWebViewController : SJBaseViewController

- (instancetype)initWithUrlStr:(NSString *)urlStr andAppImageUrlStr:(NSString *)appImageUrlStr andSuperCode:(NSString *)superCode withAppName:(NSString *)appName;

@property (nonatomic, strong) NSString *urlStr;   /* 初始化网页链接 */

@property (nonatomic, strong) NSString *appImageUrlStr;   /* 初始化左侧logo链接 */

@property (nonatomic, strong) NSString *superCode;   /* 去广告代码 */

@property (nonatomic, strong) NSString *appName;      // 应用名称


@end
