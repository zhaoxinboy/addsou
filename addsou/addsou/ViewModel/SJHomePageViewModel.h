//
//  SJHomePageViewModel.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/4.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "BaseViewModel.h"

@interface SJHomePageViewModel : BaseViewModel

// 主页相关
@property (nonatomic, strong) SJHomeDataModel *HomeDataModel;
- (void)getDataFromNetWithUserId:(NSInteger)userID CompleteHandle:(CompletionHandle)completionHandle;



// 主页网址数据
@property (nonatomic, strong) SJHomeAddressModel *homeAddressModel;
- (void)getAddressDataFromNetWithUserId:(NSInteger)userID CompleteHandle:(CompletionHandle)completionHandle;

@property(nonatomic) NSInteger rowNumber;
- (NSString *)titleForRow:(NSInteger)row;
- (NSURL *)imageURLForRow:(NSInteger)row;
- (NSURL *)addressURLForRow:(NSInteger)row;
- (NSInteger)urlIDForRow:(NSInteger)row;
- (NSString *)supercodeForRow:(NSInteger)row;

// 添加历史记录
- (void)postAddHistoryToUserFromNetWithUrlId:(NSInteger)urlID andUserID:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle;


// 地理位置
- (void)postAddLocationByUserid:(NSString *)userID itude:(NSString *)itude location:(NSString *)location CompleteHandle:(CompletionHandle)completionHandle;


// 获取文章链接
- (void)getArticleUrlCompleteHandle:(CompletionHandle)completionHandle;
@property (nonatomic, strong) SJArticleModel *articleModel;      // 文章模型
@property (nonatomic, strong) NSMutableArray *artArr;      // 文章数组



@end
