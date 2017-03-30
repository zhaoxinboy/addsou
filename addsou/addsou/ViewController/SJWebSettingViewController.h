//
//  SJWebSettingViewController.h
//  addsou
//
//  Created by 杨兆欣 on 2017/3/22.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SJWebSettingType) {
    SJWebSettingTypeAddBook = 30000,
    SJWebSettingTypeShare   = 30001,
    SJWebSettingTypeRefresh = 30002,
    SJWebSettingTypeForWard = 30003,
    SJWebSettingTypeBook    = 30004
};

@protocol SJWebSetDelegate <NSObject>

- (void)everyBtnClick:(UIButton *)sender;

@end

@interface SJWebSettingViewController : UIViewController



@property (nonatomic, assign) id<SJWebSetDelegate> setDelegate;      // 点击事件的代理

@end
