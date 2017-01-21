//
//  SJBookMarksHomeCollectionViewCell.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJBookMarksHomeCollectionViewCell.h"

@implementation SJBookMarksHomeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self titleLabel];
        [self titleContentView];
        [self deleteImage];
        [self deleteBtn];
    }
    return self;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = kRGBColor(255, 255, 255);
        _titleLabel.alpha = 0.8;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    return _titleLabel;
}

- (UIImageView *)titleContentView{
    if (!_titleContentView) {
        _titleContentView = [UIImageView new];
        _titleContentView.contentMode = UIViewContentModeScaleAspectFill;
        _titleContentView.clipsToBounds = YES;
        _titleContentView.userInteractionEnabled = YES;
        [self.contentView addSubview:_titleContentView];
        [_titleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(300), SJ_ADAPTER_HEIGHT(450)));
        }];
    }
    return _titleContentView;
}

- (UIImageView *)deleteImage{
    if (!_deleteImage) {
        _deleteImage = [[UIImageView alloc] init];
        _deleteImage.contentMode = UIViewContentModeScaleAspectFill;
        [_titleContentView addSubview:_deleteImage];
        [_deleteImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return _deleteImage;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleContentView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return _deleteBtn;
}



@end
