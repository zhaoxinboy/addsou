//
//  SJGuideViewController.h
//  addsou
//
//  Created by 杨兆欣 on 2017/2/7.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJBaseViewController.h"

typedef NS_ENUM(NSUInteger, GuideViewStyle) {
    GuideViewStyle1 = 11001, // 第一页
    GuideViewStyle2 = 11002, // 第二页
    GuideViewStyle3 = 11003, // 第三页
    GuideViewStyle4 = 11004  // 第四页
};

@interface SJGuideViewController : SJBaseViewController

@property (nonatomic, assign) CGRect changeFrame;  // 换一换的位置

@property (nonatomic, assign) CGRect searchFrame;  // 搜索按钮的位置

@property (nonatomic, assign) CGRect bookFrame;    // 书签按钮的位置

@property (nonatomic, assign) CGRect voiceFrame;      // 语音按钮位置

@end
