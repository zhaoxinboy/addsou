//
//  SJVoiceHistroyTableViewCell.h
//  addsou
//
//  Created by 杨兆欣 on 2017/4/24.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJVoiceHistroyTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;      // 链接名称

@property (nonatomic, strong) SJHistoryArrModel *model;      // 数据模型


- (void)getModelWithModel:(SJHistoryArrModel *)model;

@end
