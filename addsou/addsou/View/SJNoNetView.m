//
//  SJNoNetView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/19.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJNoNetView.h"

@implementation SJNoNetView

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(_label1.mas_top).mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_HEIGHT(240), SJ_ADAPTER_HEIGHT(240)));
        }];
    }
    return _imageView;
}

- (UILabel *)label1{
    if (!_label1) {
        _label1 = [UILabel new];
        _label1.text = @"无法连接到网络";
        _label1.font = [UIFont systemFontOfSize:18];
        _label1.textColor = kRGBColor(102, 102, 102);
        [self addSubview:_label1];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(_label2.mas_top).mas_equalTo(SJ_ADAPTER_HEIGHT(-20));
        }];
    }
    return _label1;
}

- (UILabel *)label2{
    if (!_label2) {
        _label2 = [UILabel new];
        _label2.textColor = kRGBColor(153, 153, 153);
        _label2.text = @"点击加载，或检查网络设置后重试";
        _label2.font = [UIFont systemFontOfSize:15];
        [self addSubview:_label2];
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-5);
        }];
    }
    return _label2;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kWindowH - SJ_ADAPTER_HEIGHT(340) - 100, kWindowW, SJ_ADAPTER_HEIGHT(340));
        [self label2];
        [self label1];
        [self imageView];
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
