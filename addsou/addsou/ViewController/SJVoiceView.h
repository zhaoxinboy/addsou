//
//  SJVoiceView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/4/20.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVoiceTouchView.h"

@protocol SJVoiceViewDelegate <NSObject>

- (void)voiceViewDelegateBtnClick:(UIButton *)sender;

@end

@interface SJVoiceView : UIView

typedef NS_ENUM(NSInteger, SJVoiceViewTag) {
    SJVoiceViewTagSearchBtn             = 2000,
    SJVoiceViewTagBookBtn               = 2001,
};


@property (nonatomic, weak) id<SJVoiceViewDelegate> voiceDelegate;      // 按钮点击方法代理

@property (nonatomic, strong) UIView *shadowView;      //按钮的阴影，由于未知原因添加不到DVoiceTouchVie中，所以加在这

@property (nonatomic, strong) UILabel *label1;      // 嗨你好

@property (nonatomic, strong) UILabel *label2;      // 搜加语音为您服务

@property (nonatomic, strong) UIButton *searchBtn;   /* 搜索按钮 */

@property (nonatomic, strong) UIButton *bookBtn;   /* 书签按钮 */

@property (nonatomic, strong) UILabel *voiceLabel;      // 语音文字显示

@property (nonatomic, strong) DVoiceTouchView *voiceBtn;      // 语音按钮

@property (nonatomic, strong) NSTimer *timer;      // 时间

// 是否隐藏提示语
- (void)isHiddenLabel:(BOOL)twoLabel and:(BOOL)oneLabel;

- (void)changeTimerWithBool:(BOOL)isTimer;

@end
