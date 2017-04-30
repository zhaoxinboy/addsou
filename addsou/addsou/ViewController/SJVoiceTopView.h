//
//  SJVoiceTopView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/4/21.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SJVoiceTopViewDelegate <NSObject>

- (void)changeVoiceTop:(UIButton *)sender;

@end

@interface SJVoiceTopView : UIView

@property (nonatomic, weak) id<SJVoiceTopViewDelegate> topDelegate;

@property (nonatomic, strong) UIButton *btn1;      // 第一个按钮

@property (nonatomic, strong) UIButton *btn2;      // 第二个按钮

- (void)changeTopBtn:(UIButton *)sender;

@end
