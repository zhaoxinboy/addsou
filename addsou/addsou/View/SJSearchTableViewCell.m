//
//  SJSearchTableViewCell.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJSearchTableViewCell.h"

@implementation SJSearchTableViewCell

- (UIImageView *)searchImageView{
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] init];
        _searchImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_searchImageView];
        [_searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SJ_ADAPTER_WIDTH(15));
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.mas_equalTo(0);
        }];
    }
    return _searchImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(_searchImageView.mas_right).mas_equalTo(10);
        }];
    }
    return _titleLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.textColor = kRGBColor(153, 153, 153);
        _rightLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(SJ_ADAPTER_WIDTH(-15));
            make.centerY.mas_equalTo(0);
        }];
    }
    return _rightLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self searchImageView];
        [self titleLabel];
        [self rightLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
