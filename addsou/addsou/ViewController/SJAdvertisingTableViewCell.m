//
//  SJAdvertisingTableViewCell.m
//  addsou
//
//  Created by 杨兆欣 on 2017/3/28.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJAdvertisingTableViewCell.h"

@implementation SJAdvertisingTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self urlTitle];
        [self adSwitchBtn];
    }
    return self;
}


- (UILabel *)urlTitle{
    if (!_urlTitle) {
        _urlTitle = [[UILabel alloc] init];
        _urlTitle.tintColor = kRGBColor(111, 111, 111);
        _urlTitle.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_urlTitle];
        [_urlTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-90);
        }];
    }
    return _urlTitle;
}

- (UIButton *)adSwitchBtn{
    if (!_adSwitchBtn) {
        _adSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _adSwitchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_adSwitchBtn setTitle:@"删除标识" forState:UIControlStateNormal];
        [_adSwitchBtn setTitleColor:kRGBColor(78, 129, 231) forState:UIControlStateNormal];
        [_adSwitchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_adSwitchBtn];
        [_adSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
    }
    return _adSwitchBtn;
}

- (void)switchAction:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAdCell" object:self];
}

- (void)getCellAlpha:(BOOL)boo{
    if (!boo) {
        _urlTitle.alpha = 0.3;
        _adSwitchBtn.userInteractionEnabled = NO;
        _adSwitchBtn.alpha = 0.3;
    }else if(boo){
        _urlTitle.alpha = 1;
        _adSwitchBtn.userInteractionEnabled = YES;
        _adSwitchBtn.alpha = 1;
    }
}

- (void)getModel:(SJUrlModel *)model{
    self.model = model;
    self.urlTitle.text = model.url;
    [self adSwitchBtn];
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
