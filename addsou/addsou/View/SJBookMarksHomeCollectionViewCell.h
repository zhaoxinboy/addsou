//
//  SJBookMarksHomeCollectionViewCell.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJBookMarksHomeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *titleContentView;

@property (nonatomic, strong) UIImageView *deleteImage;   /* 删除背景图 */

@property (nonatomic, strong) UIButton *deleteBtn;



@end
