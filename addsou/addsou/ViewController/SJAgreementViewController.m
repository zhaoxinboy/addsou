//
//  SJAgreementViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/3/2.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJAgreementViewController.h"
#import <WebKit/WebKit.h>

@interface SJAgreementViewController ()<WKNavigationDelegate, WKUIDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) SJNavcView *navcView;   /* 自定义导航 */

@property (nonatomic, strong) WKWebView *webView;      // 网页

@end

@implementation SJAgreementViewController{
    CALayer *progresslayer;  // 网页进度条
}

- (WKWebView *)webView{
    if (!_webView) {
        NSLog(@"%@", UserDefaultObjectForKey(LOCAL_READ_LEGAL));
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", UserDefaultObjectForKey(LOCAL_READ_LEGAL)]]]];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [self.view addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        // 进度条监听
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        UIView *progress = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
        progress.backgroundColor = [UIColor clearColor];
        [_webView addSubview:progress];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 2.5);
        layer.backgroundColor = kRGBColor(51, 51, 51).CGColor;
        [progress.layer addSublayer:layer];
        progresslayer = layer;
    }
    return _webView;
}


- (void)dealloc{
    _webView.navigationDelegate = nil;
    _webView.UIDelegate = nil;
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (SJNavcView *)navcView{
    if (!_navcView) {
        _navcView = [[SJNavcView alloc] init];
        [self.view addSubview:_navcView];
        [_navcView.goBackBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
        [_navcView.goBackBtn addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
        _navcView.titleLabel.text = @"法律协议";
    }
    return _navcView;
}

- (void)go2Back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self navcView];
    
    [self webView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
            if ([change[@"new"] floatValue] == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    progresslayer.opacity = 0;
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    progresslayer.frame = CGRectMake(0, 0, 0, 3);
                });
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
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
    
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [self showErrorMsg:@"加载失败"];
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
