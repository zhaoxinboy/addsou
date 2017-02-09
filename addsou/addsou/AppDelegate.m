//
//  AppDelegate.m
//  addsou
//
//  Created by 杨兆欣 on 2016/12/30.
//  Copyright © 2016年 杨兆欣. All rights reserved.
//

#import "AppDelegate.h"
#import "SJHomePageViewController.h"
#import "SJBaseNavigationViewController.h"
#import "SJHomePageViewController.h"
#import "SJBaseNavigationViewController.h"
#import "SJGuidePageViewController.h"
#import "SJUserViewController.h"
#import "SJHistroyViewController.h"
#import "QDRUserFeedbackViewController.h"
#import "QDRLoginViewController.h"
#import "QDRAboutUsViewController.h"

@interface AppDelegate ()


@end



@implementation AppDelegate

@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 状态栏字体颜色为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // 微博注册
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WBAPPKEY];
    
    // 微信注册
    [WXApi registerApp:WXAPPKEY withDescription:@"Wechat"];

    // QQ登录
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:self];
    
    
    
    // 如果登录状态字段为空，那么证明是首次打开  记录为未登录
    if (![[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_ISLOGIN]) {
        [[NSUserDefaults standardUserDefaults] setObject:NOLOGIN forKey:LOCAL_READ_ISLOGIN];
    }
    
    /*--------------------存储UUID--------------------*/
    DLog(@"%@", LOCAL_READ_UUID)
    if (!LOCAL_READ_UUID) {
        [SSKeychain setPassword:APPUUID forService:BUNDLEID account:BUNDLEID];
    }
    DLog(@"%@", LOCAL_READ_UUID)
    /*--------------------end--------------------*/
    
    /*--------------------友盟统计初始化--------------------*/
    UMConfigInstance.appKey = UMAPPKEY;
    UMConfigInstance.channelId = @"App Store";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    /*--------------------end--------------------*/
    
//    id vc = nil;
//    if (![[NSString stringWithFormat:@"%@%@", APPVERSION, APPBUILDVERSION] isEqualToString:UserDefaultObjectForKey(LOCAL_READ_FIRSTOPEN)]){
//        vc = (SJGuidePageViewController *)[[SJGuidePageViewController alloc] init];
//        NSString *str = [NSString stringWithFormat:@"%@%@", APPVERSION, APPBUILDVERSION];
//        UserDefaultSetObjectForKey(str, LOCAL_READ_FIRSTOPEN)
//        UserDefaultSetObjectForKey(@"1", LOCAL_READ_FIRST)
//    }else{
//        vc = (SJHomePageViewController *)[[SJHomePageViewController alloc] init];
//    }
//    SJBaseNavigationViewController *navc = [[SJBaseNavigationViewController alloc] initWithRootViewController:vc];
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = navc;
//    [self.window makeKeyAndVisible];
    
    
    SJHomePageViewController *vc = [[SJHomePageViewController alloc] init];
    SJBaseNavigationViewController *navc = [[SJBaseNavigationViewController alloc] initWithRootViewController:vc];
    SJUserViewController *userVC = [[SJUserViewController alloc] init];
    
    self.sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navc leftMenuViewController:userVC rightMenuViewController:nil];
    self.sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    self.sideMenuViewController.delegate = self;
    self.sideMenuViewController.contentViewShadowColor = kRGBColor(47, 47, 47);
    self.sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    self.sideMenuViewController.contentViewShadowOpacity = 0.6;
    self.sideMenuViewController.contentViewShadowRadius = 12;
    self.sideMenuViewController.contentViewShadowEnabled = YES;
    self.sideMenuViewController.scaleMenuView = NO;
    self.sideMenuViewController.scaleContentView = NO;
    self.sideMenuViewController.contentViewInPortraitOffsetCenterX = (kWindowW / 2 - 40);
    // 引导页
    SJGuidePageViewController *pageVC = [[SJGuidePageViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (![[NSString stringWithFormat:@"%@%@", APPVERSION, APPBUILDVERSION] isEqualToString:UserDefaultObjectForKey(LOCAL_READ_FIRSTOPEN)]){
        self.window.rootViewController = pageVC;
    }else{
        self.window.rootViewController = self.sideMenuViewController;
    }
    [self.window makeKeyAndVisible];
    
    
    // 启动图片延时: 2秒
    [NSThread sleepForTimeInterval:2];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSString* strUrl = [url absoluteString];
    NSRange range;
    
    NSLog(@"application handleOpenURL, url=%@", strUrl);
    range = [strUrl rangeOfString:@"wechat"];
    if (range.location != NSNotFound) {
        NSLog(@"WEIXIN application handleOpenURL, url=%@", strUrl);
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    range = [strUrl rangeOfString:@"tencent"];
    if (range.location != NSNotFound) {
        NSLog(@"QQ application handleOpenURL, url=%@", strUrl);
        return  [TencentOAuth HandleOpenURL:url];
    }
    
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSString* strUrl = [url absoluteString];
    NSRange range;
    NSLog(@"application openURL, url=%@", strUrl);
    range = [strUrl rangeOfString:@"wechat"];
    NSRange rangeWX = [strUrl rangeOfString:@"wx"];
    if ((range.location != NSNotFound) || (rangeWX.location != NSNotFound)) {
        NSLog(@"WEIXIN application handleOpenURL, url=%@", strUrl);
        return [WXApi handleOpenURL:url delegate:self];
    }
    range = [strUrl rangeOfString:@"tencent"];
    if (range.location != NSNotFound) {
        NSLog(@"QQ application handleOpenURL, url=%@", strUrl);
        return  [TencentOAuth HandleOpenURL:url];
    }
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {// 分享回调
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        //        [alert show];
        
        if (response.statusCode == 0) {
            [self showSuccessMsg:@"分享成功"];
        }else{
            [self showErrorMsg:@"分享失败"];
        }
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = NSLocalizedString(@"认证结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        //        [alert show];
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        //        [alert show];
    }
    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
    {
        NSString *title = NSLocalizedString(@"邀请结果", nil);
        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        //        [alert show];
    }else if([response isKindOfClass:WBShareMessageToContactResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBShareMessageToContactResponse* shareMessageToContactResponse = (WBShareMessageToContactResponse*)response;
        NSString* accessToken = [shareMessageToContactResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [shareMessageToContactResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        //        [alert show];
    }
}



- (void)onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            if ([_wxDelegate respondsToSelector:@selector(loginSuccessByCode:)]) {
                SendAuthResp *resp2 = (SendAuthResp *)resp;
                [_wxDelegate loginSuccessByCode:resp2.code];
            }
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
            [self showErrorMsg:@"取消微信登录"];
        }
    }
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        if (resp.errCode == 0) {
            [self showSuccessMsg:@"分享成功"];
        }else{
            [self showErrorMsg:@"分享失败"];
        }
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
//    // 当浏览记录即将显示的时候  获取网络数据并刷新
//    QDRHistoryViewController *leftVC = (QDRHistoryViewController *)sideMenu.leftMenuViewController;
//    [leftVC getNetWorking];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SJUserViewController" object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];// 菜单栏字体颜色
    DLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];//菜单栏字体颜色
    SJUserViewController *userVC = (SJUserViewController *)menuViewController;
    SJBaseNavigationViewController *vc = (SJBaseNavigationViewController *)sideMenu.contentViewController;
    if (userVC.intBtn == 1) {//注册登录
        QDRLoginViewController *loginVC = [[QDRLoginViewController alloc] init];
        [vc pushViewController:loginVC animated:NO];
    }else if (userVC.indexPath.row == 0) {//浏览记录
        SJHistroyViewController *histroyVC = [[SJHistroyViewController alloc] init];
        [vc pushViewController:histroyVC animated:NO];
    }else if (userVC.indexPath.row == 1){
        QDRUserFeedbackViewController *feedVC = [[QDRUserFeedbackViewController alloc] init];
        [vc pushViewController:feedVC animated:NO];
    }else if (userVC.indexPath.row == 3){
        QDRAboutUsViewController *aboutVC = [[QDRAboutUsViewController alloc] init];
        [vc pushViewController:aboutVC animated:NO];
    }
    
    DLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}



@end
