//
//  SJReadWebView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/4/12.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface SJReadWebView : UIView

@property (nonatomic, strong) WKWebView *webView;      // 网页

@property (nonatomic, strong) NSString *urlStr;   /* 初始化网页链接 */

@property (nonatomic, strong) NSMutableArray *urlArr;      // 链接数组

@property (nonatomic, assign) NSInteger idx;      // 数组角标，代表执行到第几个


- (instancetype)initWithUrlArr:(NSMutableArray *)urlArr;


- (void)reloadSelfWebWithUrlString:(NSString *)urlstr;


// 把url放到队列里操作
- (void)webQueueOperations;

@end
