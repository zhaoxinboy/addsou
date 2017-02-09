//
//  SJBookMarksHomeCollectionViewCell.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJBookMarksHomeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *headerImageView;      // 链接头像

@property (nonatomic, strong) UILabel *title;      // 链接名称

@property (nonatomic, strong) UILabel *titleLabel;  // 链接题目

@property (nonatomic, strong) UIImageView *titleContentView;  // 链接截图

@property (nonatomic, strong) UIButton *deleteBtn;   // 删除按钮

-(void)setBlur:(CGFloat)ratio; //设置毛玻璃效果

@end
