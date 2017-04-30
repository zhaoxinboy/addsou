//
//  SJReadWebView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/4/12.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJReadWebView.h"

@interface SJReadWebView() <WKNavigationDelegate>

@end

@implementation SJReadWebView

- (WKWebView *)webView{
    if (!_webView) {
//        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
//        // 设置偏好设置
//        webConfig.preferences = [[WKPreferences alloc] init];
//        // 默认为0
//        webConfig.preferences.minimumFontSize = 10;
//        // 默认认为YES
//        webConfig.preferences.javaScriptEnabled = YES;
//        // 在iOS上默认为NO，表示不能自动通过窗口打开
//        webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
//        // web内容处理池
//        webConfig.processPool = [[WKProcessPool alloc] init];
//        // 将所有cookie以document.cookie = 'key=value';形式进行拼接
//        NSString *cookieValue = @"document.cookie = 'fromapp=ios';document.cookie = 'channel=appstore';";
//        // 加cookie给h5识别，表明在ios端打开该地址
//        WKUserContentController *userContentController = WKUserContentController.new;
//        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieValue injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//        [userContentController addUserScript:cookieScript];
//        webConfig.userContentController = userContentController;
        
        
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [_webView loadRequest:requestObj];
        
        _webView.navigationDelegate = self;
        
        [self addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _webView;
}

- (NSMutableArray *)urlArr{
    if (!_urlArr) {
        _urlArr = [[NSMutableArray alloc] init];
    }
    return _urlArr;
}


- (instancetype)initWithUrlArr:(NSMutableArray *)urlArr{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kWindowW, kWindowH);
        SJArticleUrlModel *model = (SJArticleUrlModel *)urlArr[0];
        self.urlStr = model.url;
        self.idx = 1;
        self.urlArr = [urlArr copy];
        [self webView];
    }
    return self;
}

- (void)reloadSelfWebWithUrlString:(NSString *)urlstr{
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [_webView loadRequest:requestObj];
}

#pragma mark - WKWebViewDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (webView.scrollView.contentSize.height > kWindowH) {
        NSInteger x = [self getRandomNumber:0 to:150];
        NSInteger y = x + 30;
        [UIView animateWithDuration:y animations:^{
            webView.scrollView.contentOffset = CGPointMake(0, webView.scrollView.contentSize.height);
        } completion:^(BOOL finished) {
            if (self.idx < self.urlArr.count) {
                SJArticleUrlModel *model = (SJArticleUrlModel *)self.urlArr[self.idx];
                self.urlStr = model.url;
                [self reloadSelfWebWithUrlString:self.urlStr];
                self.idx += 1;
            }
        }];
    }
}


// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}


// 是否打开新窗口
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

// 判断是不是新页面
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
