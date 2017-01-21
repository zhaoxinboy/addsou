//
//  SJImageViewAndButton.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/6.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJImageViewAndButton.h"

@implementation SJImageViewAndButton

- (UIButton *)clickBtn{
    if (!_clickBtn) {
        _clickBtn = [UIButton new];
        _clickBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_clickBtn];
        [_clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _clickBtn;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton new];
        [_addBtn setImage:[UIImage imageNamed:@"page_Focus_nor"] forState:UIControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"page_Focus_sel"] forState:UIControlStateSelected];
        _addBtn.layer.cornerRadius = 12;
        [self addSubview:_addBtn];
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 24));
            make.right.bottom.mas_equalTo(-8);
        }];
    }
    return _addBtn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        [self clickBtn];
        [self addBtn];
        [self model];
    }
    return self;
}

- (SJHomeAddressDataModel *)model{
    if (!_model) {
        _model = [SJHomeAddressDataModel new];
    }
    return _model;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
