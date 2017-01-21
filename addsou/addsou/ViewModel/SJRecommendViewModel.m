//
//  SJRecommendViewModel.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/7.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJRecommendViewModel.h"

@implementation SJRecommendViewModel

// 智能推荐
- (void)getAppRecommendByUserid:(NSString *)userID CompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/getAppRecommendByUserid?userid=%@", URLPATH, userID];
    __weak typeof (self) wself = self;
    self.dataTask = [SJNetManager GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"智能推荐 %@", dic)
            
            _recommendModel = [SJHomeAddressModel mj_objectWithKeyValues:responseObj];
            [wself.dataArr removeAllObjects];
            [wself.dataArr addObjectsFromArray:_recommendModel.data];
        }
        completionHandle(error);
    }];
}


// 毒鸡汤
- (void)getshowDocByUserid:(NSString *)userID soupType:(NSString *)soupType CompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/soil/getSoulSoupByUserid?userid=%@&souptype=%@", URLPATH, userID, soupType];
    __weak typeof (self) wself = self;
    self.dataTask = [SJNetManager GET:path parameters:nil completionHandle:^(id responseObj, NSError *error) {
        if (responseObj) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
            DLog(@"智能推荐 %@", dic)
            self.contentStr = [[dic objectForKey:@"data"] objectForKey:@"content"];
        }
        completionHandle(error);
    }];
}

@end
