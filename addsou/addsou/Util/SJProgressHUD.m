//
//  SJProgressHUD.m
//  addsou
//
//  Created by 杨兆欣 on 2016/12/30.
//  Copyright © 2016年 杨兆欣. All rights reserved.
//

#import "SJProgressHUD.h"

@implementation SJProgressHUD

- (UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [UILabel new];
        _progressLabel.font = [UIFont systemFontOfSize:14];
        _progressLabel.textColor = [UIColor blueColor];
        [self addSubview:_progressLabel];
        [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(10);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _progressLabel;
}

+ (instancetype)shareProgressHUD{
    static SJProgressHUD *prohud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        prohud = [[SJProgressHUD alloc] init];
    });
    return prohud;
}

- (instancetype)init{
    if (self = [super init]) {
        UIWindow * window = [UIApplication sharedApplication].windows[0];
        [window addSubview:self];
        self.frame = CGRectMake(0, -68, kWindowW, 64);
        self.backgroundColor = [UIColor whiteColor];
        
        // 阴影
//        self.layer.shadowOffset =  CGSizeMake(1, 3);
//        self.layer.shadowOpacity = 0.8;
//        self.layer.shadowColor =  [UIColor whiteColor].CGColor;
        
        [self progressLabel];
    }
    return self;
}

- (void)setMessageType:(MessageType)messageType andMessage:(NSString *)message {
    // 用来设置背景颜色
    switch (messageType) {
        case MessageTypeError:
            // 错误
//            self.backgroundColor = kRGBColor(<#R#>, <#G#>, <#B#>);
            break;
        case MessageTypeSuccess:
            // 成功
            break;
        case MessageTypeWarning:
            // 警告
            break;
            
        default:
            break;
    }
    self.progressLabel.text = message;
}

- (SJProgressHUD *)showView{
    __weak __typeof(self) weakSelf = self;
    self.frame = CGRectMake(0, -68, kWindowW, 64);
    [self.layer removeAllAnimations];
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [weakSelf setFrame:CGRectMake(0, 0, kWindowW, 64)];
    } completion:^(BOOL finished) {
        [weakSelf hiddenView];
    }];
    
    return self;
    
}
- (void)hiddenView {
    [UIView animateWithDuration:.3 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setFrame:CGRectMake(0, -68, kWindowW, 64)];
    } completion:^(BOOL finished) {
        
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
