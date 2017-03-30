//
//  SJTabView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/3/21.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SJTabViewDelegate <NSObject>

- (void)clickOnTheBtnWithTag:(NSInteger)tag;

@end

typedef NS_ENUM(NSUInteger, SJTabViewType) {
    SJTabViewGoBack = 20000,
    SJTabViewHomePage = 20001,
    SJTabViewSetting = 20002
};

@interface SJTabView : UIView

@property (nonatomic, assign) id<SJTabViewDelegate> tabDelegate;      // 点击按钮的代理

@property (nonatomic, strong) UIButton *barGoBack;       // 返回

@property (nonatomic, strong) UIButton *homePage;        // 主页

@property (nonatomic, strong) UIButton *setting;         // 设置


@end
