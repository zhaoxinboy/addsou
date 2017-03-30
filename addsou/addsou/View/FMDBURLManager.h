//
//  FMDBURLManager.h
//  addsou
//
//  Created by 杨兆欣 on 2017/3/28.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBURLManager : NSObject

@property (nonatomic, strong) SJUrlModel *model;

+ (instancetype)sharedFMDBUrlManager;


#pragma mark - Person
/**
 *  添加SJUrlModel
 *
 */
- (BOOL)addUrlModel:(SJUrlModel *)model;
/**
 *  删除SJUrlModel
 *
 */
- (BOOL)deleteUrlModel:(SJUrlModel *)model;
/**
 *  更新SJUrlModel
 *
 */
- (BOOL)updateUrlModel:(SJUrlModel *)model;

/**
 *  获取所有数据
 *
 */
- (NSMutableArray *)getAllUrlModel;


@end
