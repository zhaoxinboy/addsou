//
//  SJSearchTextField.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJSearchTextField.h"

@implementation SJSearchTextField

// 设置Placeholder
- (void)customWithPlaceholder: (NSString *)placeholder color: (UIColor *)color font: (UIFont *)font{
    self.placeholder = placeholder;
    [self setValue:color forKeyPath:@"_placeholderLabel.color"];
    [self setValue:font forKeyPath:@"_placeholderLabel.font"];
}

// 重写这个方法是为了使Placeholder居中，如果不写会出现类似于下图中的效果，文字稍微偏上了一些
- (void)drawPlaceholderInRect:(CGRect)rect {
    [super drawPlaceholderInRect:CGRectMake(0, self.frame.size.height * 0.5 - 1, 0, 0)];
}
//控制placeHolder的位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y - 8, bounds.size.width -10, bounds.size.height);
    return inset;
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y - 8, bounds.size.width -10, bounds.size.height);
    return inset;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
