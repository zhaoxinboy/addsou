//
//  SJKeywordsCollectionViewCell.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/19.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJKeywordsCollectionViewCell.h"

@implementation SJKeywordsCollectionViewCell

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = SJ_ADAPTER_WIDTH(24);
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(48), SJ_ADAPTER_WIDTH(48)));
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = kRGBColor(51, 51, 51);
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imageView.mas_bottom).mas_equalTo(6);
            make.centerX.mas_equalTo(0);
            make.left.mas_equalTo(2);
            make.right.mas_equalTo(-2);
        }];
    }
    return _titleLabel;
}

- (UIButton *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stateBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_stateBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_stateBtn setTitleColor:kRGBColor(153, 153, 153) forState:UIControlStateSelected];
        [_stateBtn setTitleColor:kRGBColor(102, 102, 102) forState:UIControlStateNormal];
        _stateBtn.layer.borderWidth = 0.5;
        _stateBtn.layer.borderColor = kRGBColor(102, 102, 102).CGColor;
        _stateBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        _stateBtn.layer.masksToBounds = YES;
        _stateBtn.layer.cornerRadius = 3;
        [self.contentView addSubview:_stateBtn];
        [_stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(48, 18));
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _stateBtn;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self imageView];
        [self titleLabel];
        [self stateBtn];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShake:) name:KeywordsEditStateChanged object:nil];
    }
    return self;
}



- (void)handleShake:(NSNotification*)sender
{
    if ([sender.object intValue] == YES) {
        self.stateBtn.hidden = NO;
    }else{
        self.stateBtn.hidden = YES;
    }
}

@end
