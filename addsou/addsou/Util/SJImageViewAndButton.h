//
//  SJImageViewAndButton.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/6.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJImageViewAndButton : UIImageView

@property (nonatomic, strong) UIButton *clickBtn;   /* 点击按钮 */

@property (nonatomic, strong) UIButton *addBtn;   /* 添加按钮 */

@property (nonatomic, strong) SJHomeAddressDataModel *model;   /* 当前模型 */

@end
