//
//  SJVoiceView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/4/20.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJVoiceView.h"

@implementation SJVoiceView

- (UIButton *)bookBtn{
    if (!_bookBtn) {
        _bookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bookBtn setImage:[UIImage imageNamed:@"page_Focus_label"] forState:UIControlStateNormal];
        _bookBtn.layer.masksToBounds = YES;
        _bookBtn.layer.cornerRadius = SJ_ADAPTER_HEIGHT(22);
        _bookBtn.tag = SJVoiceViewTagBookBtn;
        [_bookBtn tapWithEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            [self voiceViewBtnClick:sender];
        }];
        [self addSubview:_bookBtn];
        [_bookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SJ_ADAPTER_WIDTH(23));
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_HEIGHT(44), SJ_ADAPTER_HEIGHT(44)));
            make.bottom.mas_equalTo(-SJ_ADAPTER_HEIGHT(26));
        }];
        
    }
    return _bookBtn;
}

- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateNormal];
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.layer.cornerRadius = SJ_ADAPTER_HEIGHT(22);
        _searchBtn.tag = SJVoiceViewTagSearchBtn;
        [_searchBtn tapWithEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            [self voiceViewBtnClick:sender];
        }];
        [self addSubview:_searchBtn];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SJ_ADAPTER_WIDTH(23));
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_HEIGHT(44), SJ_ADAPTER_HEIGHT(44)));
            make.bottom.mas_equalTo(-SJ_ADAPTER_HEIGHT(26));
        }];
        // 把要展示的按钮的位置传入，用于绘制贝塞尔曲线
        [SJManager sharedManager].searchFrame = CGRectMake(SJ_ADAPTER_WIDTH(23), kWindowH - SJ_ADAPTER_HEIGHT(26) - SJ_ADAPTER_HEIGHT(44), SJ_ADAPTER_HEIGHT(44), SJ_ADAPTER_HEIGHT(44));
    }
    return _searchBtn;
}

- (UILabel *)voiceLabel{
    if (!_voiceLabel) {
        _voiceLabel = [[UILabel alloc] init];
        _voiceLabel.text = @"点击说话";
        _voiceLabel.font = [UIFont systemFontOfSize:16];
        _voiceLabel.textColor = [UIColor blackColor];
        [self addSubview:_voiceLabel];
        [_voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(15);
        }];
    }
    return _voiceLabel;
}

- (DVoiceTouchView *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [[DVoiceTouchView alloc] initWithFrame:CGRectMake((kWindowW / 2) - (SJ_ADAPTER_WIDTH(82) / 2), SJ_ADAPTER_HEIGHT(self.height - SJ_ADAPTER_HEIGHT(48) - SJ_ADAPTER_WIDTH(82)), SJ_ADAPTER_WIDTH(82), SJ_ADAPTER_WIDTH(82))];
        _voiceBtn.layer.masksToBounds = YES;
        _voiceBtn.layer.cornerRadius = SJ_ADAPTER_WIDTH(82 / 2);
        [self addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kWindowH - SJ_ADAPTER_HEIGHT(210), kWindowW, SJ_ADAPTER_HEIGHT(210));
        self.backgroundColor = [UIColor whiteColor];
        [self voiceLabel];
        [self voiceBtn];
        [self searchBtn];
        [self bookBtn];
    }
    return self;
}


- (void)voiceViewBtnClick:(UIButton *)sender{
    if (self.voiceDelegate && [self.voiceDelegate respondsToSelector:@selector(voiceViewDelegateBtnClick:)]) {
        [self.voiceDelegate voiceViewDelegateBtnClick:sender];
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
