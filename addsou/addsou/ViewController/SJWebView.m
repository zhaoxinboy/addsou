//
//  SJWebView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/3/21.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJWebView.h"
#import "QDRSwipeView.h"

@interface SJWebView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) QDRSwipeView *leftSwipeView;     //右滑左侧出现视图用于返回上一页面

@property (nonatomic, strong) QDRSwipeView *rightSwipeView;    // 左滑右侧出现视图用于前进到上一页面

@end

@implementation SJWebView{
    CALayer *progresslayer;  // 网页进度条
    CGFloat marginOffset;  // 上下滑动距离
}

- (JSContext *)context{
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
}

- (instancetype)initWithUrlStr:(NSString *)urlStr andAppImageUrlStr:(NSString *)appImageUrlStr andSuperCode:(NSString *)superCode withAppName:(NSString *)appName{
    self = [super init];
    if (self) {
        _urlStr = urlStr;
        _appImageUrlStr = appImageUrlStr;
        _superCode = superCode;
        _appName = appName;
        [self titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW, 40));
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kWindowW - 60, 20));
            make.bottom.mas_equalTo(0);
        }];
        
    }
    return _titleLabel;
}

- (QDRSwipeView *)leftSwipeView{
    if (!_leftSwipeView) {
        _leftSwipeView = [[QDRSwipeView alloc] initWithFrame:CGRectMake(-44, kWindowH / 2 - 22, 44, 44)];
        _leftSwipeView.swipeLabel.text = @"\U0000e64a";
        [self addSubview:_leftSwipeView];
        [self bringSubviewToFront:_leftSwipeView];
    }
    return _leftSwipeView;
}

- (QDRSwipeView *)rightSwipeView{
    if (!_rightSwipeView) {
        _rightSwipeView = [[QDRSwipeView alloc] initWithFrame:CGRectMake(kWindowW, kWindowH / 2 - 22, 44, 44)];
        _rightSwipeView.swipeLabel.text = @"\U0000e64d";
        [self addSubview:_rightSwipeView];
        [self bringSubviewToFront:_rightSwipeView];
    }
    return _rightSwipeView;
}


- (void)dealloc
{
    self.tabView.tabDelegate = nil;
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"URL"];
//    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"contextMenuMessageHandler"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        webConfig.preferences = [[WKPreferences alloc] init];
        // 默认为0
        webConfig.preferences.minimumFontSize = 10;
        // 默认认为YES
        webConfig.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // web内容处理池
        webConfig.processPool = [[WKProcessPool alloc] init];
        // 将所有cookie以document.cookie = 'key=value';形式进行拼接
        NSString *cookieValue = @"document.cookie = 'fromapp=ios';document.cookie = 'channel=appstore';";
        // 加cookie给h5识别，表明在ios端打开该地址
        
        
        WKUserContentController *userContentController = WKUserContentController.new;
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieValue injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//        [userContentController addScriptMessageHandler:self name:@"contextMenuMessageHandler"];
        [userContentController addUserScript:cookieScript];
        webConfig.userContentController = userContentController;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webConfig];
        
        //        _webView.allowsBackForwardNavigationGestures = YES;
        
        NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [_webView loadRequest:requestObj];
        
        [self addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(40);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-44);
        }];
        // 进度条监听
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        UIView *progress = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 3)];
        progress.backgroundColor = [UIColor clearColor];
        [_webView addSubview:progress];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 2.5);
        layer.backgroundColor = kRGBColor(51, 51, 51).CGColor;
        [progress.layer addSublayer:layer];
        progresslayer = layer;
        // 标题监听
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:NULL];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        panGestureRecognizer.delegate = self;
        [_webView addGestureRecognizer:panGestureRecognizer]; // 添加托移手势
    }
    return _webView;
}

//- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
//    
//    
//    NSLog(@"%@", message.body);
//}




//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
//        return YES;
//    }
//    return NO;
//}

// 左右滑动手势方法
- (void)handlePan:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.webView];
    CGRect leftFrame = self.leftSwipeView.frame;
    CGRect rightFrame = self.rightSwipeView.frame;
    CGRect webFrame = self.webView.frame;
    CGRect tabFrame = self.tabView.frame;
    
    if (translation.x > 0) {  // 向右滑动
        if (_webView.canGoBack) {
            leftFrame.origin.x = -44 + translation.x;
            if (leftFrame.origin.x >= 0) {
                leftFrame.origin.x = 0;
            }
            self.leftSwipeView.frame = leftFrame;
        }
    }else if(translation.x < 0){  //向左滑动
        if (_webView.canGoForward) {
            rightFrame.origin.x = kWindowW + translation.x;
            if (rightFrame.origin.x <= kWindowW - 44) {
                rightFrame.origin.x = kWindowW - 44;
            }
            self.rightSwipeView.frame = rightFrame;
        }
    }else if(translation.y < 0){  //向上滑动
        
//        webFrame.size.height = kWindowH - 40 - 44 - translation.y;
//        tabFrame.origin.y = kWindowH - 44 - translation.y;
//        if (webFrame.size.height >= kWindowH - 40) {
//            webFrame.size.height = kWindowH - 40;
//            tabFrame.origin.y = kWindowH;
//        }
//        self.webView.frame = webFrame;
//        self.tabView.frame = tabFrame;
        
        
    }else if(translation.y > 0){  //向下滑动
        
//        webFrame.size.height = kWindowH - 40 - 44 + translation.y;
//        tabFrame.origin.y = kWindowH - 44 + translation.y;
//        if (webFrame.size.height <= kWindowH - 40 - 44) {
//            webFrame.size.height = kWindowH - 40 - 44;
//            tabFrame.origin.y = kWindowH - 44;
//        }
//        self.webView.frame = webFrame;
//        self.tabView.frame = tabFrame;

    }
    if ([recognizer state] == UIGestureRecognizerStateEnded) { // 停止拖动
        [self checkForPartialScroll];
    }
}

//左右滑动手势停止的方法
- (void)checkForPartialScroll{
    
//    if (self.webView.frame.size.height >= kWindowH - 40 - 22) {
//        [UIView animateWithDuration:0.2 animations:^{
//            self.tabView.frame = CGRectMake(0, kWindowH,  kWindowW, 44);
//            self.webView.frame = CGRectMake(0, 40, kWindowW, kWindowH - 40);
//        }];
//    }else{
//        [UIView animateWithDuration:0.2 animations:^{
//            self.tabView.frame = CGRectMake(0, kWindowH - 44,  kWindowW, 44);
//            self.webView.frame = CGRectMake(0, 40, kWindowW, kWindowH - 84);
//        }];
//    }
    
    
    if (self.leftSwipeView.frame.origin.x == 0) {
        [_webView goBack];
        [UIView animateWithDuration:0.1 animations:^{
            _leftSwipeView.frame = CGRectMake(-44, kWindowH / 2 - 22, 44, 44);
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            _leftSwipeView.frame = CGRectMake(-44, kWindowH / 2 - 22, 44, 44);
        }];
    }
    if (self.rightSwipeView.frame.origin.x == kWindowW - 44){
        [_webView goForward];
        [UIView animateWithDuration:0.1 animations:^{
            _rightSwipeView.frame = CGRectMake(kWindowW, kWindowH / 2 - 22, 44, 44);
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            _rightSwipeView.frame = CGRectMake(kWindowW, kWindowH / 2 - 22, 44, 44);
        }];
    }
}



- (SJTabView *)tabView{
    if (!_tabView) {
        _tabView = [[SJTabView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tabView];
        [_tabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW, 44));
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(_webView.mas_bottom).mas_equalTo(0);
        }];
    }
    return _tabView;
}


// kvo监控进度条进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (object == _webView){
        if([keyPath isEqualToString:@"estimatedProgress"]) {
            progresslayer.opacity = 1;
            //不要让进度条倒着走...有时候goback会出现这种情况
            if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
                return;
            }
            progresslayer.frame = CGRectMake(0, 0, kWindowW * [change[@"new"] floatValue], 3);
            if ([change[@"new"] floatValue] == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    progresslayer.opacity = 0;
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    progresslayer.frame = CGRectMake(0, 0, 0, 3);
                });
            }
        }else if([keyPath isEqualToString:@"title"]){
            if (object == self.webView) {
                _titleLabel.text = self.webView.title;
            }
        }else if([keyPath isEqualToString:@"URL"]){
            if (object == self.webView) {
                _urlStr = [self.webView.URL absoluteString];
            }
            
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
