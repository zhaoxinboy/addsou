//
//  NSObject+Common.h
//  addsou
//
//  Created by 杨兆欣 on 2016/12/30.
//  Copyright © 2016年 杨兆欣. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SearchWebUrlStyle) {
    SearchWebUrlStyleBaiDu = 0, // 百度
    SearchWebUrlStyleBiYing = 1, // 必应
    SearchWebUrlStyleSouGou = 2, // 搜狗
    SearchWebUrlStyle360 = 3 // 360
};

@interface NSObject (Common)
//显示失败提示
- (void)showErrorMsg:(NSObject *)msg;

//显示成功提示
- (void)showSuccessMsg:(NSObject *)msg;

//显示忙
- (void)showProgress;

//隐藏提示
- (void)hideProgress;

- (NSString *)promptStrWithStatus:(NSString *)status;   // 网络提示信息

//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image;

// 字符串转图片
-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr;

// 截图成为image
- (UIImage *)screenView:(UIView *)view;

// 限制图片大小在32K以内
- (NSData *)dataWithShareImage:(NSURL *)url;

// sd缓存计算
- (CGFloat)sdFolderSize;

// sd清理缓存
- (void)sdCleanCache;

// 搜索引擎字符串链接
+ (NSString *)keywordWithSearchWebUrl:(NSString *)keyword searchWebUrlStyle:(SearchWebUrlStyle)searchWebUrlStyle;

// cookie获取
+ (NSString *)loadRequestWithUrlString:(NSString *)urlString;

// 保存搜索的关键字
+ (void)saveKeyWordWithText:(NSString *)text;

// 提取关键字
+ (NSMutableArray *)extractKeyWord;

@end
