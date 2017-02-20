//
//  SJBookMarksHomeView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/2/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJBookMarksHomeView.h"

@implementation SJBookMarksHomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = true;
        self.backgroundColor = [UIColor whiteColor];
        
        [self title];
        [self titleLabel];
        [self titleContentView];
        [self deleteBtn];
    }
    return self;
}


- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.layer.cornerRadius = SJ_ADAPTER_WIDTH(18);
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.borderWidth = 2;
        _headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:_headerImageView];
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(36), SJ_ADAPTER_WIDTH(36)));
            make.top.mas_equalTo(-SJ_ADAPTER_WIDTH(18));
        }];
    }
    return _headerImageView;
}

- (UILabel *)title{
    if (!_title) {
        _title = [UILabel new];
        _title.textColor = kRGBColor(153, 153, 153);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:10];
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(SJ_ADAPTER_HEIGHT(30));
        }];
        UIView *view1 = [[UIView alloc] init];
        view1.backgroundColor = kRGBColor(153, 153, 153);
        [self addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_title.mas_centerY).mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(16), 1));
            make.right.mas_equalTo(_title.mas_left).mas_equalTo(SJ_ADAPTER_WIDTH(-5));
        }];
        UIView *view2 = [[UIView alloc] init];
        view2.backgroundColor = kRGBColor(153, 153, 153);
        [self addSubview:view2];
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_title.mas_centerY).mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(16), 1));
            make.left.mas_equalTo(_title.mas_right).mas_equalTo(SJ_ADAPTER_WIDTH(5));
        }];
        
    }
    return _title;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:21];
        _titleLabel.textColor = kRGBColor(51, 51, 51);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(_title.mas_bottom).mas_equalTo(SJ_ADAPTER_HEIGHT(25));
            make.left.right.mas_equalTo(0);
        }];
    }
    return _titleLabel;
}

- (UIImageView *)titleContentView{
    if (!_titleContentView) {
        _titleContentView = [UIImageView new];
        _titleContentView.contentMode = UIViewContentModeScaleAspectFill;
        _titleContentView.clipsToBounds = YES;
        _titleContentView.userInteractionEnabled = YES;
        [self addSubview:_titleContentView];
        [_titleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.bottom.mas_equalTo(0);
            //            make.centerX.mas_equalTo(0);
            //            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(300), SJ_ADAPTER_HEIGHT(450)));
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(SJ_ADAPTER_HEIGHT(108));
        }];
    }
    return _titleContentView;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return _deleteBtn;
}

- (void)deleteCell:(UIButton *)sender{
    if (self.deledeDelegate && [self.deledeDelegate respondsToSelector:@selector(deleteCellWithButton:)]) {
        [self.deledeDelegate deleteCellWithButton:sender];
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
