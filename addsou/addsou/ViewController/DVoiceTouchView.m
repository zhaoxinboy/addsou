//
//  DVoiceTouchView.m
//  DVoiceSend
//
//  Created by DUCHENGWEN on 2016/10/26.
//  Copyright © 2016年 DCW. All rights reserved.
//

#import "DVoiceTouchView.h"
#import "SJVoiceTuBeView.h"


@interface DVoiceTouchView ()

@property (nonatomic, strong) SJVoiceTuBeView *voiceView;      // 放话筒的视图
/**
 *  线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;
/**
 *  线的颜色
 */
@property (nonatomic, strong) UIColor * lineColor;
/**
 *  话筒颜色
 */
@property (nonatomic, strong) UIColor * colidColor;

@property (nonatomic, assign) BOOL     isBegan;
@property (nonatomic, strong) NSTimer  *timer;

@end


@implementation DVoiceTouchView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.isBegan = NO;
        self.areaY=-40;
        self.clickTime = 0.5;
        
        
        UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:voiceButton];
        voiceButton.titleLabel.font = [UIFont systemFontOfSize:14];
        voiceButton.userInteractionEnabled = NO;
        self.voiceButton = voiceButton;
        
        self.voiceButton.layer.masksToBounds = NO;
        self.voiceButton.layer.cornerRadius = self.width / 2;
        [voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event{
    if (self.voiceButton.selected) {
        return YES;
    }else{
        return  [super pointInside:point withEvent:event];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.clickTime target:self selector:@selector(timeAction) userInfo:nil repeats:NO];
    DLog(@"++++++++++++++++++开始");
    
    self.timer = timer;
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_voiceButton.isSelected) {
        UITouch *anchTouch = [touches anyObject];
        CGPoint point =  [anchTouch locationInView:self];
        if (point.y > self.areaY) {
            if (self.down) {
                self.down();
            }
            
            NSLog(@"下滑");
        }else{
            if (self.upglide) {
                self.upglide();
            }
            
            NSLog(@"上滑");
        }
        DLog(@"%@",NSStringFromCGPoint([anchTouch locationInView:self]));
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    if (self.voiceButton.selected) {
        if (self.touchEnd) {
            self.touchEnd();
        }
    }
    self.voiceButton.selected = NO;
    [self.timer invalidate];
    self.timer = nil;
    DLog(@"+++++++++++++++++取消");
}

-(void)timeAction{
    if (self.touchBegan) {
        self.touchBegan();
    }
    DLog(@"++++++++++++执行");
    self.voiceButton.selected = YES;
    [self.timer invalidate];
    DLog(@"++++++++++++执行");
    
}


- (void)pgq_reateVoiceTopViewWithVoiceColor:(UIColor *)fColor volumeColor:(UIColor *)vColor isColid:(BOOL)isColid lineWidth:(CGFloat)lineWidth {
    //设置线宽
    self.lineWidth = lineWidth;
    //设置颜色
    self.lineColor = fColor;
    self.colidColor = vColor;
    
    self.voiceView = [[SJVoiceTuBeView alloc] initWithframe:CGRectMake(self.width / 4, self.height / 4, self.width / 2, self.height / 2) VoiceColor:self.lineColor volumeColor:self.colidColor isColid:isColid lineWidth:self.lineWidth];
    [self.voiceButton addSubview:self.voiceView];
}


- (void)updateVoiceViewWithVolume:(float)volume{
    [self.voiceView.topView updateVoiceViewWithVolume:volume];
}


@end
