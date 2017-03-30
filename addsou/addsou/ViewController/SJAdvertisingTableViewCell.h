//
//  SJAdvertisingTableViewCell.h
//  addsou
//
//  Created by 杨兆欣 on 2017/3/28.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAdvertisingTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *urlTitle;   /* 网站名称 */

@property (nonatomic, strong) UIButton *adSwitchBtn;   /* 广告开关 */

@property (nonatomic, strong) SJUrlModel *model;      // 模型储存


- (void)getModel:(SJUrlModel *)model;

- (void)getCellAlpha:(BOOL)boo;


- (void)UpdateCellWithSwitch:(BOOL)select;

@end
