//
//  SJVoiceTubeView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/5/10.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJVoiceTopView : UIView


- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lColor colidColor:(UIColor *)cColor;

/**
 *  设置音量的大小 输入 0.0 ~ 1.0
 *
 *  @param volume 输入 0 ~ 1
 */
- (void)updateVoiceViewWithVolume:(float)volume;

@end
