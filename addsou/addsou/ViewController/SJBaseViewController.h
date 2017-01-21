//
//  SJBaseViewController.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/4.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJLoginViewModel.h"
#import "SJSearchViewModel.h"
#import "SJHomePageViewModel.h"
#import "SJHistoryViewModel.h"
#import "SJRecommendViewModel.h"

@interface SJBaseViewController : UIViewController

@property (nonatomic, strong) SJLoginViewModel *loginVM;   /* 登录模型 */

@property (nonatomic, strong) SJSearchViewModel *searchVM;   /* 搜索模型*/

@property (nonatomic, strong) SJHomePageViewModel *homeVM;   /* 主页模型 */

@property (nonatomic, strong) SJHistoryViewModel *historyVM;   /* 搜索模型 */

@property (nonatomic, strong) SJRecommendViewModel *recommendVM;   /* 智能推荐模型 */

@end
