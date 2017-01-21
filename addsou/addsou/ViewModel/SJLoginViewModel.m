//
//  SJLoginViewModel.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/4.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJLoginViewModel.h"

@implementation SJLoginViewModel

// 首次打开APP
- (void)postFirstRegistWithSign:(NSString *)sign andSerialnumber:(NSString *)serialnumber companyid:(NSString *)companyid NetCompleteHandle:(CompletionHandle)completionHandle{
    __weak typeof (self) wself = self;
    NSString *path = [NSString stringWithFormat:@"%@/soil/firstRegist", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *mdStr = [NSString stringWithFormat:@"%@%@", sign, LOCAL_READ_MD5];
    NSString *md = [mdStr encryptWithMD5];
    [params setObject:md forKey:@"sign"];
    [params setObject:serialnumber forKey:@"serialnumber"];
    [params setObject:companyid forKey:@"companyid"];
    DLog(@"params %@", params)
    self.dataTask = [SJNetManager POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"首次打开  %@", dic)
            
            _firstModel = [SJFirstModel mj_objectWithKeyValues:[dic objectForKey:@"data"]];
            // 保存用户已经打开第一次
            UserDefaultSetObjectForKey(@"1", LOCAL_READ_FIRST)
            DLog(@"LOCAL_READ_USERID  %@", [NSString stringWithFormat:@"%@", _firstModel.userid])
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _firstModel.userid] forKey:LOCAL_READ_USERID];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _firstModel.token] forKey:LOCAL_READ_TOKEN];
        }
        completionHandle(error);
    }];
}


// 登录页面相关
- (void)postDataFromWithUserName:(NSString *)userName passWord:(NSString *)passWord NetCompleteHandle:(CompletionHandle)completionHandle{
    __weak typeof (self) wself = self;
    NSString *path = [NSString stringWithFormat:@"%@/userlogin", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:LOCAL_READ_UUID forKey:@"serialnumber"];
    
    self.dataTask = [SJNetManager POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"uuid登录 %@", dic)
            
            _LoginDataModel = [SJLoginDataModel mj_objectWithKeyValues:[dic objectForKey:@"data"]];
            // 保存用户token权限
            [[NSUserDefaults standardUserDefaults] setObject:_LoginDataModel.token forKey:LOCAL_READ_TOKEN];
            NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_TOKEN]);
            // 保存用户ID
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _LoginDataModel.userid] forKey:LOCAL_READ_USERID];
        }
        completionHandle(error);
    }];
}


- (void)getUserInfoByUserid:(NSInteger)userID NetCompleteHandle:(CompletionHandle)completionHandle
{
    NSString *path = [NSString stringWithFormat:@"%@/soil/getUserInfoByUserid?userid=%@", URLPATH, @(userID)];
    self.dataTask = [SJNetManager GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"%@", dic)
            
            _isLoginModel = [SJIsLoginModel mj_objectWithKeyValues:[dic objectForKey:@"data"]];
            // 把头像地址拼接起来
            _isLoginModel.avatar = [NSString stringWithFormat:@"%@%@", URLPATH, _isLoginModel.avatar];
        }
        completionHandle(error);
    }];
}

//登陆
- (void)postAppLoginWithMobile:(NSString *)mobile passWord:(NSString *)passWord NetCompleteHandle:(CompletionHandle)completionHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@/appLogin", URLPATH];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:passWord forKey:@"password"];
    DLog(@"登录 %@", params)
    self.dataTask = [SJNetManager POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"登录 %@", dic)
            if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                self.successApp = [dic objectForKey:@"status"];
            }
        }
        
        completionHandle(error);
    }];
    
    
}


// 第三方登录
- (void)postOutherLoginWithOnlyid:(NSString *)onlyid serialnumber:(NSString *)serialnumber userid:(NSString *)userid type:(NSString *)type outerinfo:(NSString *)outerinfo nickname:(NSString *)nickname NetCompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/soil/outerLogin", URLPATH];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:onlyid forKey:@"onlyid"];
    [params setObject:serialnumber forKey:@"serialnumber"];
    [params setObject:userid forKey:@"userid"];
    [params setObject:type forKey:@"type"];
    [params setObject:outerinfo forKey:@"outerinfo"];
    [params setObject:nickname forKey:@"nickname"];
    DLog(@"第三方登录 %@", params)
    self.dataTask = [SJNetManager POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"第三方登录 %@", dic)
            if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                self.successOuther = [dic objectForKey:@"status"];
            }
        }
        completionHandle(error);
    }];
}

- (void)postResetPasswordWithPassWord:(NSString *)password mobile:(NSString *)mobile verfycode:(NSString *)verfycode codeid:(NSString *)codeid NetCompleteHandle:(CompletionHandle)completionHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@/resetPassword", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:password forKey:@"password"];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:verfycode forKey:@"verfycode"];
    [params setObject:codeid forKey:@"codeid"];
    __weak typeof (self) wself = self;
    self.dataTask = [SJNetManager POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        _status = [dic objectForKey:@"status"];
        DLog(@"忘记密码:  %@\n忘记密码网络请求返回码:  %@", dic, _status)
        if ([_status isEqualToString:@"0"]) {
            _loginModel = [SJLoginModel mj_objectWithKeyValues:responseObj];
            DLog(@"%@", _loginModel.data)
            [wself.dataArr removeAllObjects];
            if (_loginModel.data){
                [wself.dataDic setValuesForKeysWithDictionary:_loginModel.data];
            }
        }else{
            NSString *errorStr = [NSString promptStrWithStatus:_status];
            
        }
        completionHandle(error);
    }];
}

- (void)postResetPasswordWithUserID:(NSString *)userid content:(NSString *)content NetCompleteHandle:(CompletionHandle)completionHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@/addFeedBackByUserid", URLPATH];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userid forKey:@"userid"];
    [params setObject:content forKey:@"content"];
    __weak typeof (self) wself = self;
    self.dataTask = [SJNetManager POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSString *status = [dic objectForKey:@"status"];
        DLog(@"用户反馈:  %@\n用户反馈网络请求返回码:  %@", dic, status)
        if ([status isEqualToString:@"0"]) {
            wself.isSuccess = [dic objectForKey:@"data"];
        }else{
            NSString *errorStr = [NSString promptStrWithStatus:status];
        }
        completionHandle(error);
    }];
}

// 注册
- (void)postDataFromWithUserName:(NSString *)userName passWord:(NSString *)password mobile:(NSString *)mobile verfycode:(NSString *)verfycode serialnumber:(NSString *)serialnumber codeid:(NSString *)codeid NetCompleteHandle:(CompletionHandle)completionHandle
{
    NSString *path = [NSString stringWithFormat:@"%@/userregist", URLPATH];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userName forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:verfycode forKey:@"verfycode"];
    [params setObject:serialnumber forKey:@"serialnumber"];
    [params setObject:codeid forKey:@"codeid"];
    
    __weak typeof (self) wself = self;
    self.dataTask = [SJNetManager POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        _registStatus = [dic objectForKey:@"status"];
        DLog(@"注册:  %@\n注册网络请求返回码:  %@", dic, _registStatus)
        if ([_status isEqualToString:@"0"]) {
            _registModel = [SJLoginDataModel mj_objectWithKeyValues:responseObj];
            DLog(@"%@", _loginModel)
            if (_loginModel){
                // 保存用户ID
                [[NSUserDefaults standardUserDefaults] setObject:_registModel.userid forKey:LOCAL_READ_USERID];
                [[NSUserDefaults standardUserDefaults] setObject:_registModel.username forKey:LOCAL_READ_USERNAME];
                [[NSUserDefaults standardUserDefaults] setObject:_registModel.mobile forKey:LOCAL_READ_MOBILE];
                [[NSUserDefaults standardUserDefaults] setObject:password forKey:LOCAL_READ_PASSWORD];
            }
        }else{
            NSString *errorStr = [NSString promptStrWithStatus:_registStatus];
            
        }
        completionHandle(error);
    }];
}


// 验证码
- (void)getVerfyCodeWithUserID:(NSString *)userid andMobile:(NSString *)mobile andType:(NSString *)type NetCompleteHandle:(CompletionHandle)completionHandle{
    __weak typeof (self) wself = self;
    NSString *path = [NSString stringWithFormat:@"%@/getVerfyCode?userid=%@&mobile=%@&type=%@", URLPATH, userid, mobile, type];
    self.dataTask = [SJNetManager GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"验证码 %@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            wself.codeid = [dic objectForKey:@"data"];
            DLog(@"%@", wself.codeid);
            [wself showSuccessMsg:@"验证码已发送"];
        }else{
            NSString *errorStr = [NSString promptStrWithStatus:[dic objectForKey:@"status"]];
            //            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        completionHandle(error);
    }];
}


@end
