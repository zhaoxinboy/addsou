//
//  SJNavigationBar.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/5.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJDateView.h"

@interface SJNavigationBar : UIView

@property (nonatomic, strong) UIButton *leftBtn;   /* 左侧按钮 */

@property (nonatomic, strong) UILabel *centerLabel;   /* 中间label */

@property (nonatomic, strong) SJDateView *dateView;   /* 日期view */

@property (nonatomic, strong) UIView *bottomView;   /* 高44的视图，仿bar */



@end
