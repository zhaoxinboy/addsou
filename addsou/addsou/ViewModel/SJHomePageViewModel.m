//
//  SJHomePageViewModel.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/4.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJHomePageViewModel.h"

@implementation SJHomePageViewModel

// 主页相关
- (void)getDataFromNetWithUserId:(NSInteger)userID CompleteHandle:(CompletionHandle)completionHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@/getCompanyInfoByUserid?userid=%@", URLPATH, @(userID)];
    __weak typeof (self) wself = self;
    self.dataTask = [SJNetManager GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"主页相关 %@", dic)
            
            _HomeDataModel = [SJHomeDataModel mj_objectWithKeyValues:[dic objectForKey:@"data"]];
            // 保存底部信息
            [[NSUserDefaults standardUserDefaults] setObject:_HomeDataModel.record forKey:LOCAL_READ_RECORD];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@%@", URLPATH, _HomeDataModel.logo] forKey:LOCAL_READ_HEADERURL];
            [[NSUserDefaults standardUserDefaults] setObject:_HomeDataModel.legal forKey:LOCAL_READ_LEGAL];//法律条款
        }
        completionHandle(error);
    }];
}



// 主页网址信息
- (void)getAddressDataFromNetWithUserId:(NSInteger)userID CompleteHandle:(CompletionHandle)completionHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@/getAppInfoByUserid?userid=%@", URLPATH, @(userID)];
    __weak typeof (self) wself = self;
    self.dataTask = [SJNetManager GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"主页相关 %@", dic)
            
            _homeAddressModel = [SJHomeAddressModel mj_objectWithKeyValues:responseObj];
            [wself.dataArr removeAllObjects];
            [wself.dataArr addObjectsFromArray:_homeAddressModel.data];
        }
        completionHandle(error);
    }];
}
- (NSInteger)rowNumber{
    return self.dataArr.count;
}
- (SJHomeAddressDataModel *)videoListModelForRow:(NSInteger)row{
    return self.dataArr[row];
}

- (NSString *)titleForRow:(NSInteger)row{
    NSString *title = [NSString stringWithFormat:@"%@",[self videoListModelForRow:row].appname];
    return title;
}
- (NSURL *)imageURLForRow:(NSInteger)row{
    NSString *path = [NSString stringWithFormat:@"%@%@", URLPATH, [self videoListModelForRow:row].applogopath];
    return [NSURL URLWithString:path];
}
- (NSURL *)addressURLForRow:(NSInteger)row{
    NSString *path = [self videoListModelForRow:row].appurl;
    return [NSURL URLWithString:path];
}
- (NSInteger)urlIDForRow:(NSInteger)row{
    NSInteger urlid = [[self videoListModelForRow:row].qdrid integerValue];
    return urlid;
}

- (NSString *)supercodeForRow:(NSInteger)row{
    NSString *supercode = [self videoListModelForRow:row].supercode;
    return supercode;
}

// 添加历史记录，在点击之后调用
- (void)postAddHistoryToUserFromNetWithUrlId:(NSInteger)urlID andUserID:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/addHistoryToUser", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)urlID] forKey:@"appid"];
    [params setObject:userid forKey:@"userid"];
    __weak typeof (self) wself = self;
    self.dataTask = [SJNetManager POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"添加历史记录 %@", dic)
            
            NSString *str = [dic objectForKey:@"data"];
            if ([str isEqualToString:@"success"]) {
                //            [wself showSuccessMsg:@"历史记录添加成功"];
            }else{
//                [wself showErrorMsg:@"历史记录添加失败"];
            }
        }
        completionHandle(error);
    }];
}


// 地理位置
- (void)postAddLocationByUserid:(NSString *)userID itude:(NSString *)itude location:(NSString *)location CompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/addLocationByUserid", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userID forKey:@"userid"];
    [params setObject:itude forKey:@"itude"];
    [params setObject:location forKey:@"location"];
    __weak typeof (self) wself = self;
    self.dataTask = [SJNetManager POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        DLog(@"地理位置  %@", dic)
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            DLog(@"地理位置上传成功");
        }else{
            NSString *errorStr = [NSString promptStrWithStatus:[dic objectForKey:@"status"]];
        }
        completionHandle(error);
    }];
}



@end
