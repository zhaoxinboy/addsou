//
//  SJVoiceTuBeView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/5/10.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJVoiceTopView.h"
#import "SJVoiceBottomView.h"

@interface SJVoiceTuBeView : UIView

/**
 *  话筒顶部
 */
@property (nonatomic,strong) SJVoiceTopView * topView;
/**
 *  话筒底部
 */
@property (nonatomic,strong) SJVoiceBottomView * bomView;

- (instancetype)initWithframe:(CGRect)frame VoiceColor:(UIColor *)voiceColor volumeColor:(UIColor *)vColor isColid:(BOOL)isColid lineWidth:(CGFloat)lineWidth;

@end
