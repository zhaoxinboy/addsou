//
//  QDRBookViewModel.h
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/15.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDRBookViewModel : NSObject

@property (nonatomic, strong) NSNumber *ID;

@property (nonatomic, strong) NSString *userUUID;

@property (nonatomic, strong) NSString *url;// 地址

@property (nonatomic, strong) NSString *titlestr;  // 标题

@property (nonatomic, strong) NSString *imageData;  // 截图data

@property (nonatomic, strong) NSString *titleData;   // logo地址

@property (nonatomic, strong) NSString *superCode;  //去广告JS代码

@property (nonatomic, strong) NSString *appName;      // 链接名称

@end
