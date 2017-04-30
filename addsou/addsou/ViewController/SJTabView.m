//
//  SJTabView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/3/21.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJTabView.h"
#import "UIButton+runtime.h"


@implementation SJTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shadowOpacity = 0.5;// 阴影透明度
        self.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
        self.layer.shadowRadius = 3;// 阴影扩散的范围控制
        self.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews{
    [self barGoBack];
    [self homePage];
    [self setting];
}

- (UIButton *)barGoBack{
    if (!_barGoBack) {
        _barGoBack = [UIButton buttonWithType:UIButtonTypeCustom];
        _barGoBack.tag = SJTabViewGoBack;
        [_barGoBack setImage:[UIImage imageNamed:@"icon_tab_back"] forState:UIControlStateNormal];
        [_barGoBack tapWithEvent:UIControlEventAllEvents withBlock:^(UIButton *sender) {
            [self clickOn:sender];
        }];
        
//        [_barGoBack addTarget:self action:@selector(clickOn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_barGoBack];
        [_barGoBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kWindowW / 3, self.height));
        }];
    }
    return _barGoBack;
}

- (UIButton *)homePage{
    if (!_homePage) {
        _homePage = [UIButton buttonWithType:UIButtonTypeCustom];
        _homePage.tag = SJTabViewHomePage;
        [_homePage setImage:[UIImage imageNamed:@"icon_tab_page"] forState:UIControlStateNormal];
        [_homePage addTarget:self action:@selector(clickOn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_homePage];
        [_homePage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kWindowW / 3, self.height));
        }];
    }
    return _homePage;
}

- (UIButton *)setting{
    if (!_setting) {
        _setting = [UIButton buttonWithType:UIButtonTypeCustom];
        _setting.tag = SJTabViewSetting;
        [_setting setImage:[UIImage imageNamed:@"icon_tab_menu"] forState:UIControlStateNormal];
        [_setting addTarget:self action:@selector(clickOn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_setting];
        [_setting mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kWindowW / 3, self.height));
        }];
    }
    return _setting;
}

- (void)clickOn:(UIButton *)sender{
    if (self.tabDelegate && [self.tabDelegate respondsToSelector:@selector(clickOnTheBtnWithTag:)]) {
        [self.tabDelegate clickOnTheBtnWithTag:sender.tag];
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
