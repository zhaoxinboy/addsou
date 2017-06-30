//
//  SJUserTableHeaderFooterView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/12.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJUserTableHeaderFooterView : UIView

@property (nonatomic, strong) UIImageView *bottomImageView;   /* 背景图 */

@property (nonatomic, strong) UIImageView *headerImageView;   /* 头像 */

@property (nonatomic, strong) UIButton  *headerBtn;   /* 头像上层按钮 */

@property (nonatomic, strong) UIButton *logBtn;   /* 登录按钮 */

@property (nonatomic, strong) UILabel *nameLabel;   /* 名称属性  */

@property (nonatomic, strong) UIButton *qiandaoBtn;      // 签到

@end
