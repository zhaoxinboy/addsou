//
//  SJUserTableHeaderFooterView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/12.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJUserTableHeaderFooterView.h"

@implementation SJUserTableHeaderFooterView

- (UIImageView *)bottomImageView{
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_bg_pic"]];
        _bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bottomImageView.clipsToBounds = YES;
        [self addSubview:_bottomImageView];
        [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _bottomImageView;
}

- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.masksToBounds = YES;
        if (VERSIONS == 2) {
            _headerImageView.layer.cornerRadius = 34;
        }else if (VERSIONS == 1){
            _headerImageView.layer.cornerRadius = 24;
        }
        _headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headerImageView.layer.borderWidth = 2;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_headerImageView];
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([LOCAL_READ_ISOTHER isEqualToString:LOCAL_READ_SOUJIA] && (VERSIONS == 1)) {
                make.left.mas_equalTo(SJ_ADAPTER_WIDTH(20));
                make.top.mas_equalTo(SJ_ADAPTER_WIDTH(85));
                make.size.mas_equalTo(CGSizeMake(48, 48));
            }else if (VERSIONS == 2){
                make.left.mas_equalTo(kWindowW / 2 - 20 - 34);
                make.centerY.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(68, 68));
            }
        }];
    }
    return _headerImageView;
}

- (UIButton *)headerBtn{
    if (!_headerBtn) {
        _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerBtn.layer.masksToBounds = YES;
        _headerBtn.layer.cornerRadius = 24;
        [self addSubview:_headerBtn];
        [_headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SJ_ADAPTER_WIDTH(20));
            make.top.mas_equalTo(SJ_ADAPTER_WIDTH(85));
            make.size.mas_equalTo(CGSizeMake(48, 48));
        }];
    }
    return _headerBtn;
}

- (UIButton *)logBtn{
    if (!_logBtn) {
        _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logBtn setTitle:@"注册/登录" forState:UIControlStateNormal];
        _logBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_logBtn];
        [_logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerImageView.mas_right).mas_equalTo(SJ_ADAPTER_WIDTH(16));
            make.centerY.mas_equalTo(_headerImageView.mas_centerY).mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(70, 40));
        }];
    }
    return _logBtn;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerImageView.mas_right).mas_equalTo(SJ_ADAPTER_WIDTH(16));
            make.right.mas_equalTo(-60);
            make.centerY.mas_equalTo(_headerImageView.mas_centerY).mas_equalTo(0);
        }];
    }
    return _nameLabel;
}

- (instancetype)init{
    if (self = [super init]) {
        [self bottomImageView];
        [self headerImageView];
        if ([LOCAL_READ_ISOTHER isEqualToString:LOCAL_READ_SOUJIA] && (VERSIONS == 1)) {
            [self headerBtn];
            [self logBtn];
            [self nameLabel];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
