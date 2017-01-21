//
//  SJDateView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/5.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJDateView.h"

@implementation SJDateView

- (UILabel *)monthLabel{
    if (!_monthLabel) {
        _monthLabel = [UILabel new];
        _monthLabel.font = [UIFont systemFontOfSize:10];
        _monthLabel.textColor = kRGBColor(51, 51, 51);
        _monthLabel.alpha = 0.8;
        _monthLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_monthLabel];
        [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.mas_centerY).mas_equalTo(-2);
        }];
    }
    return _monthLabel;
}


- (UILabel *)weekLabel{
    if (!_weekLabel) {
        _weekLabel = [UILabel new];
        _weekLabel.font = [UIFont systemFontOfSize:10];
        _weekLabel.textColor = kRGBColor(51, 51, 51);
        _weekLabel.alpha = 0.8;
        _weekLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_weekLabel];
        [_weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.mas_centerY).mas_equalTo(2);
        }];
    }
    return _weekLabel;
}

- (UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [UILabel new];
        _dayLabel.font = [UIFont systemFontOfSize:28];
        _dayLabel.textColor = kRGBColor(51, 51, 51);
        [self addSubview:_dayLabel];
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-40);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _dayLabel;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self dayLabel];
        [self weekLabel];
        [self monthLabel];
    }
    return self;
}


- (void)dateViewGetDate{
    NSDateComponents *comps = [NSString getDateInfo];
    NSArray * arrWeek = [NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    self.dayLabel.text = [NSString stringWithFormat:@"%ld", (long)comps.day];
    self.monthLabel.text = [NSString stringWithFormat:@"%ld月", (long)comps.month];
    self.weekLabel.text = [arrWeek objectAtIndex:(comps.weekday - 1)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
