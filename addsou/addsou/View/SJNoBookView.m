//
//  SJNoBookView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/16.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJNoBookView.h"

@implementation SJNoBookView

- (UIImageView *)noBookImageView{
    if (!_noBookImageView) {
        _noBookImageView = [[UIImageView alloc] init];
        _noBookImageView.contentMode = UIViewContentModeScaleAspectFill;
        _noBookImageView.image = [UIImage imageNamed:@"wu"];
        [self addSubview:_noBookImageView];
        [_noBookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(143), SJ_ADAPTER_WIDTH(143)));
        }];
    }
    return _noBookImageView;
}

- (UILabel *)noBookLabel{
    if (!_noBookLabel) {
        _noBookLabel = [UILabel new];
        _noBookLabel.textColor = [UIColor blackColor];
        _noBookLabel.text = @"快去添加标签吧!";
        _noBookLabel.textAlignment = NSTextAlignmentCenter;
        _noBookLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_noBookLabel];
        [_noBookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(_noBookImageView.mas_bottom).mas_equalTo(32);
        }];
    }
    return _noBookLabel;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, SJ_ADAPTER_HEIGHT(140), kWindowW, 215);
        [self noBookImageView];
        [self noBookLabel];
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
