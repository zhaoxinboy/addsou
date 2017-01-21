//
//  AppDelegate.h
//  addsou
//
//  Created by 杨兆欣 on 2016/12/30.
//  Copyright © 2016年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@protocol WXDelegate <NSObject>

-(void)loginSuccessByCode:(NSString *)code;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate, WXApiDelegate, WeiboSDKDelegate, TencentSessionDelegate, QQApiInterfaceDelegate>
{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RESideMenu *sideMenuViewController;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

@property (nonatomic, strong) id<WXDelegate> wxDelegate;   //微信代理方法


@property (nonatomic, strong)TencentOAuth *tencentOAuth;


@end

