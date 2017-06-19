//
//  SJVoiceView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/4/20.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJVoiceView.h"
#import "SJCorrugatedView.h"

@implementation SJVoiceView

- (UIButton *)bookBtn{
    if (!_bookBtn) {
        _bookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bookBtn setImage:[UIImage imageNamed:@"page_Focus_label"] forState:UIControlStateNormal];
        _bookBtn.layer.masksToBounds = YES;
        _bookBtn.layer.cornerRadius = SJ_ADAPTER_HEIGHT(22);
        _bookBtn.tag = SJVoiceViewTagBookBtn;
        [_bookBtn tapWithEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            [self voiceViewBtnClick:sender];
        }];
        [self addSubview:_bookBtn];
        [_bookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SJ_ADAPTER_WIDTH(23));
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_HEIGHT(44), SJ_ADAPTER_HEIGHT(44)));
            make.bottom.mas_equalTo(-SJ_ADAPTER_HEIGHT(26));
        }];
        
    }
    return _bookBtn;
}

- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.layer.cornerRadius = SJ_ADAPTER_HEIGHT(22);
        _searchBtn.tag = SJVoiceViewTagSearchBtn;
        [_searchBtn tapWithEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            [self voiceViewBtnClick:sender];
        }];
        [self addSubview:_searchBtn];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SJ_ADAPTER_WIDTH(23));
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_HEIGHT(44), SJ_ADAPTER_HEIGHT(44)));
            make.bottom.mas_equalTo(-SJ_ADAPTER_HEIGHT(26));
        }];
        // 把要展示的按钮的位置传入，用于绘制贝塞尔曲线
        [SJManager sharedManager].searchFrame = CGRectMake(SJ_ADAPTER_WIDTH(23), kWindowH - SJ_ADAPTER_HEIGHT(26) - SJ_ADAPTER_HEIGHT(44), SJ_ADAPTER_HEIGHT(44), SJ_ADAPTER_HEIGHT(44));
    }
    return _searchBtn;
}

- (UILabel *)voiceLabel{
    if (!_voiceLabel) {
        _voiceLabel = [[UILabel alloc] init];
        _voiceLabel.font = [UIFont systemFontOfSize:28];
        _voiceLabel.textAlignment = NSTextAlignmentCenter;
        _voiceLabel.textColor = kRGBColor(51, 51, 51);
        _voiceLabel.hidden = YES;
        [self addSubview:_voiceLabel];
        [_voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(SJ_ADAPTER_HEIGHT(150));
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
    }
    return _voiceLabel;
}

- (UILabel *)label1{
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        _label1.text = @"嗨，您好!";
        _label1.font = [UIFont systemFontOfSize:36];
        _label1.textColor = kRGBColor(51, 51, 51);
        [self addSubview:_label1];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SJ_ADAPTER_WIDTH(48));
            make.top.mas_equalTo(SJ_ADAPTER_HEIGHT(80));
            make.right.mas_equalTo(-SJ_ADAPTER_WIDTH(48));
        }];
    }
    return _label1;
}

- (UILabel *)label2{
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"搜加语音为您服务";
        _label2.textColor = kRGBColor(51, 51, 51);
        _label2.font = [UIFont systemFontOfSize:28];
        [self addSubview:_label2];
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SJ_ADAPTER_WIDTH(48));
            make.top.mas_equalTo(self.label1.mas_bottom).mas_equalTo(32);
            make.right.mas_equalTo(-SJ_ADAPTER_WIDTH(48));
        }];
        
    }
    return _label2;
}

- (DVoiceTouchView *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [[DVoiceTouchView alloc] initWithFrame:CGRectMake((kWindowW / 2) - (SJ_ADAPTER_WIDTH(82) / 2), SJ_ADAPTER_HEIGHT(self.height - SJ_ADAPTER_HEIGHT(48) - SJ_ADAPTER_WIDTH(82)), SJ_ADAPTER_WIDTH(82), SJ_ADAPTER_WIDTH(82))];
        
        [self addSubview:_voiceBtn];
        
        [_voiceBtn pgq_reateVoiceTopViewWithVoiceColor:kRGBColor(232, 88, 54) volumeColor:kRGBColor(232, 88, 54) isColid:YES lineWidth:2];
        
        
//        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(SJ_ADAPTER_WIDTH(82) / 2,SJ_ADAPTER_WIDTH(82) / 2)radius:SJ_ADAPTER_WIDTH(82) / 2 startAngle:0 endAngle:M_PI * 2 clockwise:NO];
//        CAShapeLayer *layer = [CAShapeLayer layer];
//        layer.frame = _voiceBtn.bounds;
//        layer.strokeColor = [UIColor greenColor].CGColor; //边缘线的颜色
//        layer.fillColor = [UIColor clearColor].CGColor;   //闭环填充的颜色
//        layer.lineCap =kCALineCapSquare;                  //边缘线的类型
//        layer.path = path.CGPath;                         //从bezier曲线获取到的形状
//        layer.lineWidth =4.0f;                            //线条宽度
//        layer.strokeStart =0.0f;
//        layer.strokeEnd =0.0f;
//        //将layer添加进图层
//        [_voiceBtn.layer addSublayer:layer];
//        //3s后执行动画操作（直接赋值就能产生动画效果）
//        [self performSelector:@selector(changeStatus:) withObject:layer afterDelay:3.0];
    }
    return _voiceBtn;
}

- (void)changeStatus:(CAShapeLayer *)layer{
    
    layer.speed = 0.1;
    layer.strokeStart = 0.0;
    layer.strokeEnd = 1.0f;
    layer.lineWidth = 4.0f;
    
}



- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor whiteColor];
        _shadowView.layer.cornerRadius = SJ_ADAPTER_WIDTH(82) / 2;
        _shadowView.layer.shadowColor = kRGBColor(232, 88, 52).CGColor;//shadowColor阴影颜色
        _shadowView.layer.shadowOffset = CGSizeMake(0, 0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _shadowView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        _shadowView.layer.shadowRadius = 4;//阴影半径，默认
        
        _shadowView.clipsToBounds = NO;
        [self addSubview:_shadowView];
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(SJ_ADAPTER_HEIGHT(self.height - SJ_ADAPTER_HEIGHT(48) - SJ_ADAPTER_WIDTH(82)));
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(82), SJ_ADAPTER_WIDTH(82)));
        }];
    }
    return _shadowView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 64, kWindowW, kWindowH - 64);
        self.backgroundColor = [UIColor whiteColor];
        [self label1];
        [self label2];
        [self voiceLabel];
        [self shadowView];
        [self voiceBtn];
        [self searchBtn];
        [self bookBtn];

    }
    return self;
}


- (void)voiceViewBtnClick:(UIButton *)sender{
    if (self.voiceDelegate && [self.voiceDelegate respondsToSelector:@selector(voiceViewDelegateBtnClick:)]) {
        [self.voiceDelegate voiceViewDelegateBtnClick:sender];
    }
}

- (void)isHiddenLabel:(BOOL)twoLabel and:(BOOL)oneLabel{
    self.label1.hidden = twoLabel;
    self.label2.hidden = twoLabel;
    self.voiceLabel.hidden = oneLabel;
}

- (void)changeTimerWithBool:(BOOL)isTimer {
    
    if (!isTimer && !_timer) {
        return;
    }
    
    if (!_timer || isTimer) {
        if (!_timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(clickAnimation) userInfo:nil repeats:YES];
        }else if (isTimer) {
            [self.timer setFireDate:[NSDate date]];
        }
    } else if (!isTimer && _timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

-(void)clickAnimation{
    
    __block SJCorrugatedView *andome=[[SJCorrugatedView alloc] initWithFrame:CGRectMake((kWindowW / 2) - (SJ_ADAPTER_WIDTH(82) / 2), SJ_ADAPTER_HEIGHT(self.height - SJ_ADAPTER_HEIGHT(48) - SJ_ADAPTER_WIDTH(82)), SJ_ADAPTER_WIDTH(82), SJ_ADAPTER_WIDTH(82))];
    andome.backgroundColor=[UIColor clearColor];
    [self addSubview:andome];
    [self insertSubview:andome atIndex:1];
    
    [UIView animateWithDuration:2 animations:^{
        andome.transform = CGAffineTransformScale(andome.transform, 2, 2);
        andome.alpha = 0;
    } completion:^(BOOL finished) {
        [andome removeFromSuperview];
        NSLog(@"结束动画");
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
