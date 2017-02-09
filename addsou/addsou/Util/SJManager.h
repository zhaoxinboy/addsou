//
//  SJManager.h
//  addsou
//
//  Created by 杨兆欣 on 2017/2/7.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJManager : NSObject

@property (nonatomic, assign) CGRect changeFrame;      // 换一换按钮的位置，用于绘制贝塞尔曲线

@property (nonatomic, assign) CGRect searchFrame;      // 搜索按钮的位置，用于绘制贝塞尔曲线

@property (nonatomic, assign) CGRect bookFrame;      // 书签按钮的位置，用于绘制贝塞尔曲线


+ (SJManager *)sharedManager;

@end
