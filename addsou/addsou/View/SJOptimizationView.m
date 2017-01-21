//
//  SJOptimizationView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/5.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJOptimizationView.h"

@implementation SJOptimizationView

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        if (kWindowW <= 320.0) {
            _titleLabel.font = [UIFont systemFontOfSize:22];
        }else{
            _titleLabel.font = [UIFont systemFontOfSize:24];
        }
        _titleLabel.textColor = kRGBColor(51, 51, 51);
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SJ_ADAPTER_WIDTH(13));
            make.top.mas_equalTo((kWindowW <= 320) ? SJ_ADAPTER_HEIGHT(20) : SJ_ADAPTER_HEIGHT(36));
        }];
    }
    return _titleLabel;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        if (kWindowW <= 320.0) {
            _textLabel.font = [UIFont systemFontOfSize:16];
        }else{
            _textLabel.font = [UIFont systemFontOfSize:18];
        }
        _textLabel.textColor = kRGBColor(102, 102, 102);
        [self addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SJ_ADAPTER_WIDTH(13));
            make.top.mas_equalTo(_titleLabel.mas_bottom).mas_equalTo(SJ_ADAPTER_HEIGHT(16));
        }];
    }
    return _textLabel;
}

- (UIImageView *)logoIamgeView{
    if (!_logoIamgeView) {
        _logoIamgeView = [[UIImageView alloc] init];
        _logoIamgeView.contentMode = UIViewContentModeScaleAspectFill;
        _logoIamgeView.layer.masksToBounds = YES;
        _logoIamgeView.layer.cornerRadius = SJ_ADAPTER_WIDTH(58) / 2;
        [self addSubview:_logoIamgeView];
        [_logoIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(58), SJ_ADAPTER_WIDTH(58)));
            make.right.mas_equalTo(-SJ_ADAPTER_WIDTH(13));
            make.top.mas_equalTo(SJ_ADAPTER_HEIGHT(36));
        }];
    }
    return _logoIamgeView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kRGBColor(245, 245, 245);
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SJ_ADAPTER_WIDTH(13));
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(_textLabel.mas_bottom).mas_equalTo((kWindowW <= 320) ? SJ_ADAPTER_HEIGHT(20) : SJ_ADAPTER_HEIGHT(40));
            make.right.mas_equalTo(-SJ_ADAPTER_WIDTH(13));
        }];
    }
    return _lineView;
}

- (UILabel *)guessLabel{
    if (!_guessLabel) {
        _guessLabel = [UILabel new];
        _guessLabel.text = @"猜你喜欢";
        _guessLabel.font = [UIFont systemFontOfSize:16];
        _guessLabel.textColor = kRGBColor(51, 51, 51);
        [self addSubview:_guessLabel];
        [_guessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SJ_ADAPTER_WIDTH(13));
            make.top.mas_equalTo(_lineView.mas_bottom).mas_equalTo(SJ_ADAPTER_HEIGHT(15));
        }];
    }
    return _guessLabel;
}

- (UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_changeBtn setTitle:@"换一换" forState:UIControlStateNormal];
        [_changeBtn setTitle:@"换一换" forState:UIControlStateHighlighted];
        [_changeBtn setTitleColor:kRGBColor(102, 102, 102) forState:UIControlStateNormal];
        [_changeBtn setTitleColor:kRGBColor(202, 202, 202) forState:UIControlStateHighlighted];
        [self addSubview:_changeBtn];
        [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_guessLabel.mas_centerY).mas_equalTo(0);
            make.right.mas_equalTo(-SJ_ADAPTER_WIDTH(13));
            make.size.mas_equalTo(CGSizeMake(50, 40));
        }];
    }
    return _changeBtn;
}

- (JiKeScrollView *)myJikeScrollView{
    
    if (!_myJikeScrollView) {
        _myJikeScrollView = [[JiKeScrollView alloc] init];
        [self addSubview:_myJikeScrollView];
        [_myJikeScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(_guessLabel.mas_bottom).mas_equalTo(SJ_ADAPTER_HEIGHT(20));
        }];
    }
    return _myJikeScrollView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kWindowW - 20, kWindowH - 167);
        
        [self titleLabel];
        [self textLabel];
        [self logoIamgeView];
        [self lineView];
        [self guessLabel];
        [self changeBtn];
        [self myJikeScrollView];
    }
    return self;
}


- (NSArray *)tempDataArray
{
    if (!_tempDataArray) {
        _tempDataArray = [[NSArray alloc] init];
    }
    return _tempDataArray;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
