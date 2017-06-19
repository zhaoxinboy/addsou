//
//  SJVoiceTuBeView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/5/10.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJVoiceTuBeView.h"


@interface SJVoiceTuBeView ()


/**
 *  线宽
 */
@property (nonatomic,assign) CGFloat lineWidth;
/**
 *  线的颜色
 */
@property (nonatomic,strong) UIColor * lineColor;
/**
 *  话筒颜色
 */
@property (nonatomic,strong) UIColor * colidColor;

@end

@implementation SJVoiceTuBeView


- (instancetype)initWithframe:(CGRect)frame VoiceColor:(UIColor *)voiceColor volumeColor:(UIColor *)vColor isColid:(BOOL)isColid lineWidth:(CGFloat)lineWidth;
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置线宽
        self.lineWidth = lineWidth;
        //设置颜色
        self.lineColor = voiceColor;
        self.colidColor = vColor;
        [self topView];
        [self bomView];
    }
    return self;
}

- (SJVoiceTopView *)topView {
    if (!_topView) {
        _topView = [[SJVoiceTopView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height * 0.7) lineWidth:self.lineWidth lineColor:self.lineColor colidColor:self.colidColor];
        [self addSubview:_topView];
    }
    return _topView;
}

- (SJVoiceBottomView *)bomView{
    if (!_bomView) {
        _bomView = [[SJVoiceBottomView alloc]initWithFrame:CGRectMake(0, self.height *0.7, self.width, self.height * 0.3) lineWidth:self.lineWidth lindeColor:self.lineColor ];
        [self addSubview:_bomView];
    }
    return _bomView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
