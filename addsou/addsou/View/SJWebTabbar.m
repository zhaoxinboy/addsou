//
//  SJWebTabbar.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJWebTabbar.h"

@implementation SJWebTabbar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self barGoBack];
        [self barGoForward];
        [self homePage];
        [self share];
        [self bookmarks];
        
        [self.barGoForward setUserInteractionEnabled:NO];
        self.barGoForward.alpha = 0.2;
        self.goForwardLabel.alpha = 0.2;
    }
    return self;
}

- (UIButton *)barGoBack{
    if (!_barGoBack) {
        _barGoBack = [UIButton new];
        _barGoBack.tag = SJWebTabbarGoBack;
        _barGoBack.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
        [_barGoBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_barGoBack setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_barGoBack setTitle:@"\U0000e64a" forState:UIControlStateNormal];
        [_barGoBack setTitle:@"\U0000e64a" forState:UIControlStateHighlighted];
        _barGoBack.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [self addSubview:_barGoBack];
        [self.barGoBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW / 5, 40));
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
        }];
        self.gobackLabel = [UILabel new];
        self.gobackLabel.text = @"返回";
        self.gobackLabel.textColor = [UIColor blackColor];
        self.gobackLabel.font = [UIFont systemFontOfSize:8];
        [self addSubview:self.gobackLabel];
        [self.gobackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_barGoBack.mas_centerX).mas_equalTo(0);
            make.bottom.mas_equalTo(-3);
        }];
    }
    return _barGoBack;
}

- (UIButton *)barGoForward{
    if (!_barGoForward) {
        _barGoForward = [UIButton new];
        _barGoForward.tag = SJWebTabbarGoForward;
        _barGoForward.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
        [_barGoForward setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_barGoForward setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_barGoForward setTitle:@"\U0000e64d" forState:UIControlStateNormal];
        [_barGoForward setTitle:@"\U0000e64d" forState:UIControlStateHighlighted];
        _barGoForward.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [self addSubview:_barGoForward];
        [self.barGoForward mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW / 5, 40));
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(kWindowW / 5);
        }];
        self.goForwardLabel = [UILabel new];
        self.goForwardLabel.text = @"上一页";
        self.goForwardLabel.textColor = [UIColor blackColor];
        self.goForwardLabel.font = [UIFont systemFontOfSize:8];
        [self addSubview:self.goForwardLabel];
        [self.goForwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_barGoForward.mas_centerX).mas_equalTo(0);
            make.bottom.mas_equalTo(-3);
        }];
    }
    return _barGoForward;
}

- (UIButton *)homePage{
    if (!_homePage) {
        _homePage = [UIButton new];
        _homePage.tag = SJWebTabbarHomePage;
        _homePage.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
        [_homePage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_homePage setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_homePage setTitle:@"\U0000e655" forState:UIControlStateNormal];
        [_homePage setTitle:@"\U0000e655" forState:UIControlStateHighlighted];
        _homePage.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [self addSubview:_homePage];
        [self.homePage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW / 5, 40));
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo((kWindowW / 5) * 2);
        }];
        self.homeLabel = [UILabel new];
        self.homeLabel.text = @"主页";
        self.homeLabel.textColor = [UIColor blackColor];
        self.homeLabel.font = [UIFont systemFontOfSize:8];
        [self addSubview:self.homeLabel];
        [self.homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_homePage.mas_centerX).mas_equalTo(0);
            make.bottom.mas_equalTo(-3);
        }];

    }
    return _homePage;
}

- (UIButton *)share{
    if (!_share) {
        _share = [UIButton new];
        _share.tag = SJWebTabbarShare;
        _share.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
        [_share setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_share setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_share setTitle:@"\U0000e735" forState:UIControlStateNormal];
        [_share setTitle:@"\U0000e735" forState:UIControlStateHighlighted];
        _share.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [self addSubview:_share];
        [_share mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW / 5, 40));
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo((kWindowW / 5) * 3);
        }];
        self.shareBtnLabel = [UILabel new];
        self.shareBtnLabel.text = @"分享";
        self.shareBtnLabel.textColor = [UIColor blackColor];
        self.shareBtnLabel.font = [UIFont systemFontOfSize:8];
        [self addSubview:self.shareBtnLabel];
        [self.shareBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_share.mas_centerX).mas_equalTo(0);
            make.bottom.mas_equalTo(-3);
        }];

    }
    return _share;
}

- (UIButton *)bookmarks{
    if (!_bookmarks) {
        _bookmarks = [UIButton new];
        _bookmarks.tag = SJWebTabbarBookMarks;
        _bookmarks.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
        [_bookmarks setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bookmarks setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_bookmarks setTitle:@"\U0000e60f" forState:UIControlStateNormal];
        [_bookmarks setTitle:@"\U0000e60f" forState:UIControlStateHighlighted];
        _bookmarks.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [self addSubview:_bookmarks];
        [_bookmarks mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW / 5, 40));
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo((kWindowW / 5) * 4);
        }];
        self.bookMarksLabel = [UILabel new];
        self.bookMarksLabel.text = @"书签";
        self.bookMarksLabel.textColor = [UIColor blackColor];
        self.bookMarksLabel.font = [UIFont systemFontOfSize:8];
        [self addSubview:self.bookMarksLabel];
        [self.bookMarksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bookmarks.mas_centerX).mas_equalTo(0);
            make.bottom.mas_equalTo(-3);
        }];

    }
    return _bookmarks;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
