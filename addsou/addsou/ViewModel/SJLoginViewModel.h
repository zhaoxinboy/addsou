//
//  SJLoginViewModel.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/4.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "BaseViewModel.h"

@interface SJLoginViewModel : BaseViewModel

@property (nonatomic, strong) SJFirstModel *firstModel;


// 第一次打开APP
- (void)postFirstRegistWithSign:(NSString *)sign andSerialnumber:(NSString *)serialnumber companyid:(NSString *)companyid NetCompleteHandle:(CompletionHandle)completionHandle;

// 第一次登陆登录
@property (nonatomic, strong) SJLoginDataModel *LoginDataModel;

- (void)postDataFromWithUserName:(NSString *)userName passWord:(NSString *)passWord NetCompleteHandle:(CompletionHandle)completionHandle;


//已登录
@property (nonatomic, strong) SJIsLoginModel *isLoginModel;
- (void)getUserInfoByUserid:(NSInteger)userID NetCompleteHandle:(CompletionHandle)completionHandle;


// 登陆
- (void)postAppLoginWithMobile:(NSString *)mobile passWord:(NSString *)passWord NetCompleteHandle:(CompletionHandle)completionHandle;
@property (nonatomic, strong) NSString *successApp;




// 第三方登录登录
- (void)postOutherLoginWithOnlyid:(NSString *)onlyid serialnumber:(NSString *)serialnumber userid:(NSString *)userid type:(NSString *)type outerinfo:(NSString *)outerinfo nickname:(NSString *)nickname NetCompleteHandle:(CompletionHandle)completionHandle;

@property (nonatomic, strong) NSString *successOuther;


@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) SJLoginModel *loginModel;
// 忘记密码
- (void)postResetPasswordWithPassWord:(NSString *)password mobile:(NSString *)mobile verfycode:(NSString *)verfycode codeid:(NSString *)codeid NetCompleteHandle:(CompletionHandle)completionHandle;


@property (nonatomic ,strong) NSString *isSuccess;  //是否成功保存字符串

- (void)postResetPasswordWithUserID:(NSString *)userid content:(NSString *)content NetCompleteHandle:(CompletionHandle)completionHandle;

@property (nonatomic, strong) SJLoginDataModel *registModel;
@property (nonatomic, strong) NSString *registStatus;
// 注册
- (void)postDataFromWithUserName:(NSString *)userName passWord:(NSString *)password mobile:(NSString *)mobile verfycode:(NSString *)verfycode serialnumber:(NSString *)serialnumber codeid:(NSString *)codeid NetCompleteHandle:(CompletionHandle)completionHandle;


// 获取验证码
- (void)getVerfyCodeWithUserID:(NSString *)userid andMobile:(NSString *)mobile andType:(NSString *)type NetCompleteHandle:(CompletionHandle)completionHandle;
@property (nonatomic, strong) NSString *codeid;

@end
