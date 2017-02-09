//
//  SJHistoryViewModel.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/3.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "BaseViewModel.h"

@interface SJHistoryViewModel : BaseViewModel

@property (nonatomic, strong)SJHistoryModel *historyModel;
- (void)getHistoryByUseridWithUserid:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle;

@property(nonatomic, assign) NSInteger rowNumber;
- (NSURL *)imageURLForRow:(NSInteger)row;
- (NSString *)addressURLForRow:(NSInteger)row;
- (NSString *)appNameForRow:(NSInteger)row;
- (NSInteger)appIdForRow:(NSInteger)row;
- (NSString *)superCodeForRow:(NSInteger)row;


// 删除历史记录
- (void)postDeleteHistoryAppByUserid:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle;
@property (nonatomic, strong) NSString *clearStatus;

@end
