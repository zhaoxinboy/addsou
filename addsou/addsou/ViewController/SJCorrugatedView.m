//
//  SJCorrugatedView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/5/12.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJCorrugatedView.h"

@implementation SJCorrugatedView

- (void)drawRect:(CGRect)rect {
    //半径
    CGFloat redbius = SJ_ADAPTER_WIDTH(82) / 2;
    //开始角度
    CGFloat startAngle = 0;
    //中心点
    CGRect CGFrome = CGRectMake(0, 0, SJ_ADAPTER_WIDTH(82), SJ_ADAPTER_WIDTH(82));
    
    CGFloat CGfrom_x = CGFrome.size.width;
    
    CGPoint point = CGPointMake(CGfrom_x / 2, CGfrom_x / 2);
    //结束角
    CGFloat endAngle = 2 * M_PI;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:redbius startAngle:startAngle endAngle:endAngle clockwise:YES];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path=path.CGPath;   //添加路径
    layer.strokeColor = kRGBAColor(232, 88, 54, 1).CGColor;
    layer.fillColor = kRGBAColor(232, 88, 54, 1).CGColor;
    [self.layer addSublayer:layer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
