//
//  SJNavigationBar.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/5.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJNavigationBar.h"

@implementation SJNavigationBar

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(20);
        }];
    }
    return _bottomView;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:@"page_icon_me"] forState:UIControlStateNormal];
        [self.bottomView addSubview:_leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kNavigationBarH + 6, kNavigationBarH));
        }];
    }
    return _leftBtn;
}

- (UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [UILabel new];
        _centerLabel.font = [UIFont systemFontOfSize:18];
        _centerLabel.textColor = kRGBColor(51, 51, 51);
        [self.bottomView addSubview:_centerLabel];
        [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return _centerLabel;
}

- (SJDateView *)dateView{
    if (!_dateView) {
        _dateView = [[SJDateView alloc] init];
        [self.bottomView addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(80);
        }];
    }
    return _dateView;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kWindowW, 64);
        self.backgroundColor = [UIColor clearColor];
        [self bottomView];
        
        [self leftBtn];
        [self centerLabel];
        [self dateView];
        
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
