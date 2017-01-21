//
//  SJRecommendViewModel.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/7.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "BaseViewModel.h"

@interface SJRecommendViewModel : BaseViewModel

// 智能推荐
@property (nonatomic, strong) SJHomeAddressModel *recommendModel;
- (void)getAppRecommendByUserid:(NSString *)userID CompleteHandle:(CompletionHandle)completionHandle;




- (void)getshowDocByUserid:(NSString *)userID soupType:(NSString *)soupType CompleteHandle:(CompletionHandle)completionHandle;
@property (nonatomic, strong) NSString *contentStr;   /* 鸡汤内容 */

@end
