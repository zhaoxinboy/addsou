//
//  SJOptimizationView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/5.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiKeScrollView.h"

@interface SJOptimizationView : UIView

@property (nonatomic, strong) UILabel *titleLabel;   /* 标题 */

@property (nonatomic, strong) UILabel *textLabel;   /* 一段话 */

@property (nonatomic, strong) UIImageView *logoIamgeView;   /* logo */

@property (nonatomic, strong) UIView *lineView;   /* 虚线 */

@property (nonatomic, strong) UILabel *guessLabel;   /* 猜你喜欢 */

@property (nonatomic, strong) UIButton *changeBtn;   /* 换一换按钮 */

//模拟数据
@property (nonatomic,strong) NSArray *tempDataArray;


@property (nonatomic,strong) JiKeScrollView *myJikeScrollView;

@property (nonatomic, assign) NSInteger dataShowIndex;   /* 刷新 */

@end
