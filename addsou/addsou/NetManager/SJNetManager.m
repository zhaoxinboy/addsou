//
//  SJNetManager.m
//  addsou
//
//  Created by 杨兆欣 on 2016/12/30.
//  Copyright © 2016年 杨兆欣. All rights reserved.
//

#import "SJNetManager.h"
#import "SJLoginViewModel.h"

const NSInteger kGGErrorNotNetCode = -501;
const NSInteger kGGErrorLoingByKeyCode = -502;
static NSString *const kGGErrorNetNetDiscription = @"无法链接到网络";
static NSString *const kGGErrorLoingByKeyDiscription = @"服务器异常";

static AFHTTPSessionManager *manager = nil;

@implementation SJNetManager

+ (AFHTTPSessionManager *)sharedAFManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"addsou" ofType:@".cer"];
//        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//        NSSet *cerSet = [NSSet setWithObjects:cerData, nil];
        
//        // https适配
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        // allowInvalidCertificates  是否允许无效证书（也就是自建的证书）,默认为NO
//        // 如果是需要验证自建证书，需要设置为YES
//        securityPolicy.allowInvalidCertificates = YES;
//        // validatesDominName 是否需要验证域名，默认为yes
//        securityPolicy.validatesDomainName = YES;
//        // 添加证书
//        [securityPolicy setPinnedCertificates:cerSet];
        
        manager = [AFHTTPSessionManager manager];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"charset=UTF-8", @"text/plain", @"text/javascript",@"application/text",@"application/html", nil];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        manager.securityPolicy = securityPolicy;
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    });
    return manager;
}

+ (id)GET:(NSString *)path parameters:(NSDictionary *)params completionHandle:(void(^)(id responseObj, NSError *error))completionHandle{
    NSString *token = (NSString *)UserDefaultObjectForKey(LOCAL_READ_TOKEN);
    if (token && ![path isEqualToString:URLACTICLE]) {
        DLog(@"token:   %@", token)
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    __weak typeof(self) weakSelf = self;
    //打印网络请求
    DLog(@"Request Path: %@, params %@", path, params)
    return [[self sharedAFManager] GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObject;
        NSString *status = [dic objectForKey:@"status"];
        DLog(@"请求路径 %@\n服务器返回内容 %@", path, dic)
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"] || [[dic objectForKey:@"code"] isEqualToString:@"0"]) { // 服务器返回status字段为0表示成功获取数据
            completionHandle(responseObject, nil);
        }else if ([status isEqualToString:@"3001"]||
            [status isEqualToString:@"3002"]||
            [status isEqualToString:@"3003"]||
            [status isEqualToString:@"3005"]||
            [status isEqualToString:@"3006"]||
            [status isEqualToString:@"3007"]||
            [status isEqualToString:@"3008"]) {
            DLog(@"token失效或者为空或者一系列错误")
            __block NSString *oldUserid = [NSString stringWithFormat:@"userid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]];
            [[SJLoginViewModel new] postDataFromWithUserName:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERNAME] passWord:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_PASSWORD] NetCompleteHandle:^(NSError *error) {
                NSString *token = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_TOKEN];
                DLog(@" token   %@", token)
                if (token) {
                    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
                }
                NSString *pathStr = nil;
                NSString *newUserid = [NSString stringWithFormat:@"userid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]];
                if (!([path rangeOfString:@"userid="].location == NSNotFound)) {
                    pathStr = [path stringByReplacingOccurrencesOfString:oldUserid withString:newUserid];
                }
                [weakSelf GET:pathStr parameters:nil completionHandle:^(id responseObj, NSError *error) {
                    completionHandle(responseObj, nil);
                }];
            }];
        }else if ([status isEqualToString:@"2004"] ||
                  [status isEqualToString:@"2015"]){
            [[NSUserDefaults standardUserDefaults] setObject:NOLOGIN forKey:LOCAL_READ_ISLOGIN];// 此时用户登录失效，设置登录字段不为1
            __block NSString *oldUserid = [NSString stringWithFormat:@"userid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]];
            SJLoginViewModel *loginVM = [SJLoginViewModel new];
            [loginVM postFirstRegistWithSign:LOCAL_READ_UUID andSerialnumber:LOCAL_READ_UUID companyid:LOCAL_READ_COMPANYID NetCompleteHandle:^(NSError *error) {
                NSString *pathStr = nil;
                NSString *newUserid = [NSString stringWithFormat:@"userid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]];
                if (!([path rangeOfString:@"userid="].location == NSNotFound)) {
                    pathStr = [path stringByReplacingOccurrencesOfString:oldUserid withString:newUserid];
                }
                [weakSelf GET:pathStr parameters:nil completionHandle:^(id responseObj, NSError *error) {
                    completionHandle(responseObj, nil);
                }];
            }];
        }else{
            completionHandle(nil, nil);
        }
        //        complete(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleText:@"网络错误"];
        DLog(@"错误信息  %@", error)
        completionHandle(nil, error);
    }];
}

+ (id)POST:(NSString *)path parameters:(NSMutableDictionary *)params completionHandle:(void(^)(id responseObj, NSError *error))completionHandle{
    NSString *token = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_TOKEN];
    if (token) {
        DLog(@" token   %@", token)
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    __weak typeof(self) weakSelf = self;
    return [[self sharedAFManager] POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObject;
        NSString *status = [dic objectForKey:@"status"];
        NSLog(@"请求路径 %@\n服务器返回内容 %@", path, dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) { // 服务器返回status字段为0表示成功获取数据
            completionHandle(responseObject, nil);
        }else if ([status isEqualToString:@"3001"]||
                  [status isEqualToString:@"3002"]||
                  [status isEqualToString:@"3003"]||
                  [status isEqualToString:@"3005"]||
                  [status isEqualToString:@"3006"]||
                  [status isEqualToString:@"3007"]||
                  [status isEqualToString:@"3008"]) {
            DLog(@"token失效或者为空或者一系列错误")
            [[SJLoginViewModel new] postDataFromWithUserName:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERNAME] passWord:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_PASSWORD] NetCompleteHandle:^(NSError *error) {
                NSString *token = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_TOKEN];
                DLog(@" token   %@", token)
                if (token) {
                    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
                }
                NSMutableDictionary *newParams = params;
                if ([newParams objectForKey:@"userid"]) {
                    [newParams setObject:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] forKey:@"userid"];
                }
                [weakSelf POST:path parameters:newParams completionHandle:^(id responseObj, NSError *error) {
                    completionHandle(responseObj, nil);
                }];
            }];
        }else if ([status isEqualToString:@"2004"] ||
                  [status isEqualToString:@"2015"]){
            [[NSUserDefaults standardUserDefaults] setObject:NOLOGIN forKey:LOCAL_READ_ISLOGIN];// 此时用户登录失效，设置登录字段不为1
            SJLoginViewModel *loginVM = [SJLoginViewModel new];
            NSLog(@"%@", path);
            [loginVM postFirstRegistWithSign:LOCAL_READ_UUID andSerialnumber:LOCAL_READ_UUID companyid:LOCAL_READ_COMPANYID NetCompleteHandle:^(NSError *error) {
                NSMutableDictionary *newParams = params;
                if ([newParams objectForKey:@"userid"]) {
                    [newParams setObject:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] forKey:@"userid"];
                }
                [weakSelf POST:path parameters:newParams completionHandle:^(id responseObj, NSError *error) {
                    completionHandle(responseObj, nil);
                }];
            }];
        }else{
            completionHandle(nil, nil);
        }
        //        complete(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleText:@"网络错误"];
        DLog(@"错误信息  %@", error)
        completionHandle(nil, error);
    }];
}

+ (NSString *)percentPathWithPath:(NSString *)path params:(NSDictionary *)params{
    NSMutableString *percentPath =[NSMutableString stringWithString:path];
    NSArray *keys = params.allKeys;
    NSInteger count = keys.count;
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            [percentPath appendFormat:@"?%@=%@", keys[i], params[keys[i]]];
        }else{
            [percentPath appendFormat:@"&%@=%@", keys[i], params[keys[i]]];
        }
    }
    return [percentPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (void)handleError:(NSError *)error{
//    [[self new] showErrorMsg:error]; // 弹出错误信息
}

+ (void)handleText:(NSString *)text{
//    [[self new] showSuccessMsg:text]; //弹出信息
}

//+(BOOL)isNetStatusWiFi{
//    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
//}
//+(BOOL)isNetStatusWWAN{
//    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
//}
//+(BOOL)isNetStatusEnable{
//    return [self isNetStatusWiFi] || [self isNetStatusWWAN];
//}


@end
