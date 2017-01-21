//
//  SJSearchViewModel.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/4.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJSearchViewModel.h"

@implementation SJSearchViewModel

// 添加用户APP
- (void)postAddAppInfoToUserFromNetWithUrlId:(NSInteger)urlID andUserID:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/addAppInfoToUser", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)urlID] forKey:@"appid"];
    [params setObject:userid forKey:@"userid"];
    __weak typeof (self) wself = self;
    self.dataTask = [SJNetManager POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"添加链接 %@", dic)
            
            self.successStr = [dic objectForKey:@"data"];
            if ([self.successStr isEqualToString:@"success"]) {
                [wself showSuccessMsg:@"添加成功"];
            }else{
                [wself showErrorMsg:@"添加失败"];
            }
        }
        completionHandle(error);
    }];
}


// 搜索结果
- (void)getSearchResultFromNetWithStr:(NSString *)str CompleteHandle:(CompletionHandle)completionHandle{
    __weak typeof (self) wself = self;
    NSString *path = [NSString stringWithFormat:@"%@/getSearchResult?key=%@", URLPATH, str];
    self.dataTask = [SJNetManager GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"搜索结果 %@", dic)
            _SearchResultModel = [SJHomeAddressModel mj_objectWithKeyValues:responseObj];
            [wself.dataArr removeAllObjects];
            [wself.dataArr addObjectsFromArray:_SearchResultModel.data];
            DLog(@"%@", wself.dataArr)
        }
        completionHandle(error);
    }];
}


// 删除APP
- (void)postDeleteCollectAppByUserid:(NSString *)userid appid:(NSString *)appid CompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/deleteCollectAppByUserid", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:appid forKey:@"appid"];
    [params setObject:userid forKey:@"userid"];
    __weak typeof (self) wself = self;
    self.dataTask = [SJNetManager POST:path parameters:params completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"删除链接 %@", dic)
            self.deleStr = [dic objectForKey:@"data"];
            if ([self.deleStr isEqualToString:@"success"]) {
                [wself showSuccessMsg:@"删除成功"];
            }else{
                [wself showErrorMsg:@"删除失败"];
            }
        }
        completionHandle(error);
    }];
}


@end
