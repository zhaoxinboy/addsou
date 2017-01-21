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
        _imageView.layer.cornerRadius = 13;
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(26, 26));
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _imageView;
}

- (UIButton *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stateBtn setImage:[UIImage imageNamed:@"page_Focus_cover_nor"] forState:UIControlStateNormal];
        [_stateBtn setImage:[UIImage imageNamed:@"page_Focus_cover_sel"] forState:UIControlStateSelected];
        _stateBtn.layer.masksToBounds = YES;
        _stateBtn.layer.cornerRadius = 13;
        _stateBtn.hidden = YES;
        _stateBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_stateBtn];
        [_stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(26, 26));
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _stateBtn;
}



- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.left.mas_equalTo(2);
            make.right.mas_equalTo(-2);
        }];
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self imageView];
        [self titleLabel];
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
