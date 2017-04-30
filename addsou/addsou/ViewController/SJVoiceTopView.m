//
//  SJVoiceTopView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/4/21.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJVoiceTopView.h"

@implementation SJVoiceTopView

- (UIButton *)btn1{
    if (!_btn1) {
        _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn1 setTitle:@"搜加" forState:UIControlStateNormal];
        [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _btn1.tag = 100001;
        [_btn1 addTarget:self action:@selector(changeTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn1];
        [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
    }
    return _btn1;
}

- (UIButton *)btn2{
    if (!_btn2) {
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn2 setTitle:@"关注" forState:UIControlStateNormal];
        _btn2.alpha = 0.5;
        _btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _btn2.tag = 100002;
        [_btn2 addTarget:self action:@selector(changeTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn2];
        [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
    }
    return _btn2;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self btn1];
        [self btn2];
    }
    return self;
}

- (void)changeTopBtn:(UIButton *)sender{
    if ((sender.tag == 100001) && (sender.alpha == 0.5)) {
        sender.alpha = 1;
        _btn2.alpha = 0.5;
    }else if ((sender.tag == 100002) && (sender.alpha == 0.5)){
        sender.alpha = 1;
        _btn1.alpha = 0.5;
    }
    if (self.topDelegate && [self.topDelegate respondsToSelector:@selector(changeVoiceTop:)]) {
        [self.topDelegate changeVoiceTop:sender];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
