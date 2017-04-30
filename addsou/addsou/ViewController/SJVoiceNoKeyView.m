//
//  SJVoiceNoKeyView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/4/24.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJVoiceNoKeyView.h"

@implementation SJVoiceNoKeyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [self imageView];
    [self label];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhexian"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW - 80, 80));
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(SJ_ADAPTER_HEIGHT(100));
        }];
    }
    return _imageView;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:14];
        _label.text = @"您还没有浏览过哦";
        _label.textColor = kRGBColor(153, 153, 153);
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-100);
        }];
    }
    return _label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
