//
//  SJWebView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/3/21.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "SJTabView.h"
#import <JavaScriptCore/JavaScriptCore.h>


@protocol SJWebViewDelegate <NSObject>



@end

@interface SJWebView : UIView

@property (nonatomic, strong) JSContext *context;      // js调用OC

@property (nonatomic, strong) WKWebView *webView;      // 网页

@property (nonatomic, strong) UILabel *titleLabel;      // 标题

@property (nonatomic, strong) SJTabView *tabView;      // 底部

@property (nonatomic, assign) id<SJWebViewDelegate> webDelegate;      // 代理方法


@property (nonatomic, strong) NSString *urlStr;   /* 初始化网页链接 */

@property (nonatomic, strong) NSString *appImageUrlStr;   /* 初始化左侧logo链接 */

@property (nonatomic, strong) NSString *superCode;   /* 去广告代码 */

@property (nonatomic, strong) NSString *appName;      // 应用名称

- (instancetype)initWithUrlStr:(NSString *)urlStr andAppImageUrlStr:(NSString *)appImageUrlStr andSuperCode:(NSString *)superCode withAppName:(NSString *)appName;



@end
