//
//  SJSearchViewModel.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/4.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "BaseViewModel.h"

@interface SJSearchViewModel : BaseViewModel

// 添加APP
- (void)postAddAppInfoToUserFromNetWithUrlId:(NSInteger)urlID andUserID:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle;
@property (nonatomic, strong) NSString *successStr;   /* 成功 */

// 删除APP
- (void)postDeleteCollectAppByUserid:(NSString *)userid appid:(NSString *)appid CompleteHandle:(CompletionHandle)completionHandle;
@property (nonatomic, strong) NSString *deleStr;
@property (nonatomic, strong) NSString *errorStr;


// 主页网址数据
@property (nonatomic, strong) SJHomeAddressModel *SearchResultModel;
//获取搜索结果
- (void)getSearchResultFromNetWithStr:(NSString *)str CompleteHandle:(CompletionHandle)completionHandle;

@end
