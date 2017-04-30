//
//  SJWebViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJWebViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "SJWebView.h"
#import "SJWebSettingViewController.h"
#import "SJBookMarksViewController.h"
#import "SJReadWebView.h"


@interface SJWebViewController ()<WKNavigationDelegate, WKUIDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, WXApiDelegate, SJWebSetDelegate, SJTabViewDelegate, contextMenuHelperDelegate>


@end

@implementation SJWebViewController{
    CALayer *progresslayer;  // 网页进度条
    CGFloat marginOffset;  // 上下滑动距离
    
    UIImage *_saveImage;      //网页长按保存图片
    NSString *_qrCodeString;    // 二维码识别信息
    
    SJContextMenuHelper *_contextMenuHelper;
    
}



- (instancetype)initWithUrlStr:(NSString *)urlStr andAppImageUrlStr:(NSString *)appImageUrlStr andSuperCode:(NSString *)superCode withAppName:(NSString *)appName
{
    self = [super init];
    if (self) {
        _urlStr = urlStr;
        _appImageUrlStr = appImageUrlStr;
        _superCode = superCode;
        _appName = appName;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES; // 使右滑返回手势不可用
}

- (void)dealloc{
    _sjWebView.tabView.tabDelegate = nil;
    _sjWebView.webView.navigationDelegate = nil;
    _sjWebView.webView.UIDelegate = nil;
    _sjWebView.webView.scrollView.delegate = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)loadView{
    
    [self sjWebView];
    self.view = self.sjWebView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 刷量关闭
//    NSDateComponents *data = [NSString getDateInfo];
//    NSString *str = [NSString stringWithFormat:@"%ld%ld%ld", (long)data.year, (long)data.month, (long)data.day];
//    if (UserDefaultObjectForKey(LOCAL_READ_DATAINFO)) {
//        if (![str isEqualToString:UserDefaultObjectForKey(LOCAL_READ_DATAINFO)]) {
//            __weak typeof (self) wself = self;
//            [self.homeVM getArticleUrlCompleteHandle:^(NSError *error) {
//                SJReadWebView *readWeb = [[SJReadWebView alloc] initWithUrlArr:wself.homeVM.artArr];
////                [self.view addSubview:readWeb];
//            }];
//            UserDefaultSetObjectForKey(str, LOCAL_READ_DATAINFO)
//        }
//    }else{
//        UserDefaultSetObjectForKey(str, LOCAL_READ_DATAINFO)
//    }
    
    // Do any additional setup after loading the view.
}




#pragma mark - 初始化网页

- (SJWebView *)sjWebView{
    if (!_sjWebView) {
        _sjWebView = [[SJWebView alloc] initWithUrlStr:_urlStr andAppImageUrlStr:_appImageUrlStr andSuperCode:_superCode withAppName:_appName];
        _sjWebView.frame = CGRectMake(0, 0, kWindowW, kWindowH);
        _sjWebView.webView.navigationDelegate = self;
        _sjWebView.webView.UIDelegate = self;
        _sjWebView.webView.scrollView.delegate = self;
        
        _sjWebView.tabView.tabDelegate = self;
        _contextMenuHelper = [[SJContextMenuHelper alloc] initWithWebViewController:self];
        _contextMenuHelper.contextMenuHelpserDelegate = self;
        
    }
    return _sjWebView;
}


#pragma mark - contextMenuHelperDelegate
- (void)contextMenuHelper:(SJContextMenuHelper *)contextMenuHelper didLongPressElements:(Elements *)elements gestureRecognizer:(UILongPressGestureRecognizer *)gestureRegcognizer{
    CGPoint touchPoint = [gestureRegcognizer locationInView:self.sjWebView.webView];
    
    __weak typeof(self) wself = self;
    
    if (elements.image) {
        NSData *data = [NSData dataWithContentsOfURL:elements.image];
        UIImage *image = [UIImage imageWithData:data];
        if (!image) {
            DLog(@"读取图片失败");
            return;
        }
        _saveImage = image;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        //取消:style:UIAlertActionStyleCancel
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [wself loadImageFinished:_saveImage];//保存图片到本地相册
        }];
        [alertController addAction:moreAction];
//        if ([self isAvailableQRcodeIn:image]) {
//            UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"识别图中二维码" style:UIAlertActionStyleDefault handler:nil];
//            [alertController addAction:moreAction];
//        }
        
        if ([UserDefaultObjectForKey(LOCAL_READ_ISFILTERAD) isEqualToString:@"1"]) {
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"屏蔽广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SJUrlModel *model = [SJUrlModel new];
                [_sjWebView.webView evaluateJavaScript:[NSString stringWithFormat:@"removeImgByUrl('%@')", elements.image.absoluteString] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                    if (!error) {
                        model.isOpen = @"1";
                        model.url = _sjWebView.webView.URL.absoluteString;
                        model.imgUrl = elements.image.absoluteString;
                        [[FMDBURLManager sharedFMDBUrlManager] addUrlModel:model];
                    }
                    DLog(@"%@", result);
                }];
                
            }];
            [alertController addAction:OKAction];
        }
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    
}

#pragma mark - 保存图片到相册
- (void)loadImageFinished:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        [self showSuccessMsg:@"已成功保存图片"];
    }
    DLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo)
}



#pragma mark - 释放一些东西
- (void)removeOther{
    if ([LOCAL_READ_ISOTHER isEqualToString:LOCAL_READ_SHUCHENG]) {
        
    }
}

#pragma mark - SJTabViewDelegate
- (void)clickOnTheBtnWithTag:(NSInteger)tag{
    
    SJWebSettingViewController *vc = nil;
    switch (tag) {
        case SJTabViewGoBack: //后退
            if (_sjWebView.webView.canGoBack) {
                [_sjWebView.webView goBack];
            }else{
                [self removeOther];
                [self saveReadUrl];//续读功能保存链接
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        case SJTabViewHomePage: //回到主页
            [self removeOther];
            [self saveReadUrl];//续读功能保存链接
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case SJTabViewSetting: //弹出式图
            vc = [[SJWebSettingViewController alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            vc.setDelegate = self;
            [self presentViewController:vc animated:NO completion:NULL];
            break;
            
        default:
            break;
    }
}

#pragma mark - 设置页面按钮点击方法 
- (void)everyBtnClick:(UIButton *)sender{
    SJBookMarksViewController *vc = nil;
    switch (sender.tag) {
        case SJWebSettingTypeAddBook:  // 添加书签
            [self addBookViewFMDBWithBtn:sender];
            break;
        case SJWebSettingTypeShare:    // 分享
            [self goShare];
            break;
        case SJWebSettingTypeRefresh:   // 刷新
            [_sjWebView.webView reload];
            break;
        case SJWebSettingTypeForWard:   // 前进
            [_sjWebView.webView goForward];
            break;
        case SJWebSettingTypeBook:     // 到书签页面
            vc = [[SJBookMarksViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark 添加/删除书签操作
- (void)addBookViewFMDBWithBtn:(UIButton *)sender{
    if (!sender.selected) {
        // 添加一个书签
        QDRBookViewModel *model = [[QDRBookViewModel alloc] init];
        model.appName = _appName;
        model.titlestr = _sjWebView.titleLabel.text;
        model.url = [_sjWebView.webView.URL absoluteString];
        model.userUUID = LOCAL_READ_UUID;
        model.imageData = [self UIImageToBase64Str:[self screenView:_sjWebView.webView]];
        model.titleData = _appImageUrlStr;
        model.superCode = _superCode;
        if ([[FMDBManager sharedFMDBManager] addBookView:model]) {
            [self showSuccessMsg:@"添加书签成功"];
        }else{
            [self showSuccessMsg:@"添加书签失败，请重试"];
        }
    }else{
        NSMutableArray *arr = [[FMDBManager sharedFMDBManager] getAllBookView];
        for (int i = 0; i < arr.count; i++) {
            QDRBookViewModel *model = [[QDRBookViewModel alloc] init];
            model = arr[i];
            DLog(@"%@", [_sjWebView.webView.URL absoluteString])
            if ([model.url isEqualToString:[_sjWebView.webView.URL absoluteString]]) {
                if ([[FMDBManager sharedFMDBManager] deleteBookView:model]){
                    [self showSuccessMsg:@"删除书签成功"];
                }else{
                    [self showSuccessMsg:@"删除书签失败，请重试"];
                }
            }
        }
    }
    
}


#pragma mark 弹出分享视图
- (void)goShare{
    NSURL *shareUrl = _sjWebView.webView.URL;
    NSArray *activityItem=@[shareUrl];
    //里面initWithActivityItems  传的是item的数组  如果直接用图片数组的话 会经常出现 微信断开的错误
    UIActivityViewController *activityView =[[UIActivityViewController alloc] initWithActivityItems:activityItem applicationActivities:nil];
    //需要忽略的分享
    activityView.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePostToWeibo
                                           ,UIActivityTypeMessage
                                           ,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,
                                           UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,
                                           //                                            UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks
                                           ];
    activityView.restorationIdentifier = @"activity";
    [activityView setTitle:@"分享"];
    [self presentViewController:activityView animated:TRUE completion:nil];
}


#pragma mark 判断图片是否为二维码
- (BOOL)isAvailableQRcodeIn:(UIImage *)img{
    UIImage *image = [img imageByInsetEdge:UIEdgeInsetsMake(-20, -20, -20, -20) withColor:[UIColor lightGrayColor]];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        _qrCodeString = [feature.messageString copy];
        DLog(@"二维码信息:%@", _qrCodeString);
        return YES;
    } else {
        DLog(@"无可识别的二维码");
        return NO;
    }
}

#pragma mark - WKWebViewDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    __weak typeof(self)wself = self;
    // 不执行前段界面弹出列表的JS代码
    [_sjWebView.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:^(id _Nullable i, NSError * _Nullable error) {
        DLog(@"Error -> %@", error);
    }];
    
    DLog(@"%@", [self jsString])
    // 注入JS代码
    [webView evaluateJavaScript:[self jsString] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        DLog(@"%@", result)
        [wself checkJsWithCompletion:^{
            DLog(@"注入成功")
        }];
    }];
}

// 获取自定义js代码
- (NSString *)jsString{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"removejs.js" withExtension:nil];
    return [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
}

- (void)checkJsWithCompletion:(void(^)())completion{
    NSString *js = @"typeof removeImgByUrl;";
    [self.sjWebView.webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        DLog(@"%@", result)
        // 检测是否被注入
        if (error != nil) {
            DLog(@"error : %@", error);
            return;
        }
        
        completion();
    }];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    // 执行一段JS代码
    DLog(@"self.supercode  %@", self.superCode)
    [_sjWebView.webView evaluateJavaScript:self.superCode completionHandler:^(id _Nullable i, NSError * _Nullable error) {
        DLog(@"Error -> %@", error);
    }];
    
    // 标题为空
    if ([NSString isBlankString:_sjWebView.titleLabel.text]) {
        _sjWebView.titleLabel.text = @"暂无标题哦！";
    }
    
    
    // 屏蔽广告开关
    if ([UserDefaultObjectForKey(LOCAL_READ_ISFILTERAD) isEqualToString:@"1"]) {
        // 从数据库中取出去广告相关数据，进行删除
        for (SJUrlModel *model in [[FMDBURLManager sharedFMDBUrlManager] getAllUrlModel]) {
            if ([_sjWebView.webView.URL.absoluteString isEqualToString:model.url]) {
                [_sjWebView.webView evaluateJavaScript:[NSString stringWithFormat:@"removeImgByUrl('%@')", model.imgUrl] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                    DLog(@"%@", result);
                }];
            }
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self showErrorMsg:@"加载失败"];
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

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    DLog(@"111");
}


- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WKWebViewScrollViewDelegate
// 正在拖拽
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentOffset = scrollView.contentOffset.y;
    static CGFloat lastOffset;
    
    NSLog(@"%f", currentOffset);
    
    if ((currentOffset <= 0) || ((scrollView.contentSize.height >= kWindowH - 44 - 40) && (currentOffset >= scrollView.contentSize.height - kWindowH - 44 - 40))) {
        return;
    }
    marginOffset = currentOffset - lastOffset;
    
    CGFloat tabBarY = _sjWebView.tabView.y;
    CGFloat webH = _sjWebView.webView.height;
    if (marginOffset < 0) { //向下滚动，显示navigationBar和TabBar。设置statusBar不透明
        tabBarY -= fabs((marginOffset));
        webH -= fabs((marginOffset));
        if (tabBarY <= kWindowH - _sjWebView.tabView.height) {//上移navBar到其顶部和屏幕顶部相同的时候，不准在下移
            tabBarY = kWindowH - 44;
            webH = kWindowH - 84;
        }
        _sjWebView.tabView.frame = CGRectMake(0, tabBarY, kWindowW, 44);
        _sjWebView.webView.frame = CGRectMake(0, 40, kWindowW, webH);
        
        
    }else{//向上滚动,隐藏navigationBar和TabBar，设置statusBar透明
        tabBarY += fabs((marginOffset));
        webH += fabs((marginOffset));
        if (tabBarY >= kWindowH) {
            tabBarY = kWindowH;
            webH = kWindowH - 40;
        }
        _sjWebView.tabView.frame = CGRectMake(0, tabBarY, kWindowW, 44);
        _sjWebView.webView.frame = CGRectMake(0, 40, kWindowW, webH);
    }
    
    lastOffset = currentOffset;
    
}

// 拖拽完了
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self regularScrollView:scrollView];
}

// 减速完了
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self regularScrollView:scrollView];
}

// 拖拽完成后固定滚动视图
- (void)regularScrollView:(UIScrollView *)scrollView
{
    CGFloat tabY = _sjWebView.tabView.y;
    
    if (tabY >= kWindowH - 22 ) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _sjWebView.tabView.frame = CGRectMake(0, kWindowH,  kWindowW, 44);
            _sjWebView.webView.frame = CGRectMake(0, 40, kWindowW, kWindowH - 40);
            if (scrollView.contentOffset.y <= 0) {
                _sjWebView.webView.scrollView.contentOffset = CGPointMake(0, 0);
            }
        }];
        
        
    }else{//否则显示两个bar
        [UIView animateWithDuration:0.2 animations:^{
            _sjWebView.tabView.frame = CGRectMake(0, kWindowH - 44,  kWindowW, 44);
            _sjWebView.webView.frame = CGRectMake(0, 40, kWindowW, kWindowH - 84);
        }];
    }
}

// 保存链接用于下次继续阅读
- (void)saveReadUrl{
    if ([LOCAL_READ_ISOTHER isEqualToString:LOCAL_READ_SHUCHENG]) {
        UserDefaultSetObjectForKey([_sjWebView.webView.URL absoluteString], LOCAL_READ_READURL)
        UserDefaultSetObjectForKey(self.appImageUrlStr, LOCAL_READ_APPIMAGEURL)
        UserDefaultSetObjectForKey(self.superCode, LOCAL_READ_SUPERCODE)
        UserDefaultSetObjectForKey(self.appName, LOCAL_READ_APPNAME)
    }
}


// 程序退出到后台后的操作保存下次需要续读的链接
- (void)applicationWillResignActive:(UIApplication *)application{
    [self saveReadUrl];
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
