//
//  SJDateView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/5.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJDateView : UIView

@property (nonatomic, strong) UILabel *dayLabel;   /* 日 */

@property (nonatomic, strong) UILabel *monthLabel;   /* 月 */

@property (nonatomic, strong) UILabel *weekLabel;   /* 星期 */

// 刷新日期
- (void)dateViewGetDate;

@end
