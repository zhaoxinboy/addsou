//
//  SJManager.m
//  addsou
//
//  Created by 杨兆欣 on 2017/2/7.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJManager.h"

@implementation SJManager

+ (SJManager *)sharedManager {
    static SJManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}




@end
