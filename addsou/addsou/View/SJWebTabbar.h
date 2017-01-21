//
//  SJWebTabbar.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, SJWebTabbarType) {
    SJWebTabbarGoBack = 0,
    SJWebTabbarGoForward,
    SJWebTabbarHomePage,
    SJWebTabbarShare,
    SJWebTabbarBookMarks
};

@interface SJWebTabbar : UIView

@property (nonatomic, strong) UIButton *barGoBack;       // 返回

@property (nonatomic, strong) UIButton *barGoForward;    // 返回上一级

@property (nonatomic, strong) UIButton *homePage;        // 主页

@property (nonatomic, strong) UIButton *share;           // 分享

@property (nonatomic, strong) UIButton *bookmarks;       // 书签


@property (nonatomic, strong) UILabel *gobackLabel;  //返回文字
@property (nonatomic, strong) UILabel *goForwardLabel;  //返回上一页文字
@property (nonatomic, strong) UILabel *homeLabel;
@property (nonatomic, strong) UILabel *shareBtnLabel;
@property (nonatomic, strong) UILabel *bookMarksLabel;


@end
