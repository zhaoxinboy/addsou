//
//  SJHistoryViewModel.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/3.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJHistoryViewModel.h"

@implementation SJHistoryViewModel

- (void)getHistoryByUseridWithUserid:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle{
    __weak typeof (self) wself = self;
    NSString *path = [NSString stringWithFormat:@"%@/soil/getHistoryByUserid?userid=%@", URLPATH, userid];
    self.dataTask = [SJNetManager GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSString *status = [dic objectForKey:@"status"];
        DLog(@"历史记录:  %@\n历史记录网络请求返回码:  %@", dic, status)
        if ([status isEqualToString:@"0"]) {
            _historyModel = [SJHistoryModel mj_objectWithKeyValues:responseObj];
            DLog(@"%@", _historyModel.data)
            [wself.dataArr removeAllObjects];
            if (_historyModel.data){
                [wself.dataArr addObjectsFromArray:_historyModel.data];
            }
        }else{
            NSString *errorStr = [NSString promptStrWithStatus:status];
            
        }
        completionHandle(error);
    }];
}

-(NSInteger)rowNumber{
    return self.dataArr.count;
}
- (SJHistoryArrModel *)videoListModelForRow:(NSInteger)row{
    DLog(@"%@", self.dataArr[row]);
    SJHistoryArrModel *model = (SJHistoryArrModel *)self.dataArr[row];
    return model;
}
- (NSURL *)imageURLForRow:(NSInteger)row{
    NSString *path = [NSString stringWithFormat:@"%@%@", URLPATH, (NSString *)[self videoListModelForRow:row].applogopath];
    DLog(@"%@", path)
    if ([path includeChinese]) {
        return [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return [NSURL URLWithString:path];
}
- (NSString *)addressURLForRow:(NSInteger)row{
    NSString *path = [self videoListModelForRow:row].appurl;
    DLog(@"地址链接 %@", path)
    return path;
}
- (NSString *)appNameForRow:(NSInteger)row{
    NSString *appname = [self videoListModelForRow:row].appname;
    DLog(@"应用名称 %@", appname)
    return appname;
}
- (NSInteger)appIdForRow:(NSInteger)row{
    NSInteger appID = [[self videoListModelForRow:row].appID integerValue];
    DLog(@"%ld", (long)appID)
    return appID;
}
- (NSString *)superCodeForRow:(NSInteger)row{
    NSString *superCode = [self videoListModelForRow:row].supercode;
    DLog(@"%ld", (long)superCode)
    return superCode;
}


- (void)postDeleteHistoryAppByUserid:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/deleteHistoryAppByUserid", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setObject:userid forKey:@"userid"];
    __weak typeof (self)wself = self;
    self.dataTask = [SJNetManager POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSString *status = [dic objectForKey:@"status"];
        DLog(@"历史记录:  %@\n清空历史记录网络请求返回码:  %@", dic, status)
        if ([status isEqualToString:@"0"]) {
            [wself showSuccessMsg:@"清除成功"];
            wself.clearStatus = status;
        }else{
            [wself showErrorMsg:@"清除失败，请检查网络后重试!"];
        }
        completionHandle(error);
    }];
}

@end
