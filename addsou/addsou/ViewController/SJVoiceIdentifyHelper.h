//
//  SJVoiceIdentifyHelper.h
//  addsou
//
//  Created by 杨兆欣 on 2017/5/10.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iflyMSC/iflyMSC.h"

@protocol SJVoiceIdentifyHelperDelegate <NSObject>

/**
 ** 识别语音后的回调
 参数1：返回的字符串
 参数2：是否是最后一个结果
 **/
- (void)onResultsString:(NSString *)resultStr isLast:(BOOL)isLast;

/**
 ** 识别错误的回调
 参数为讯飞的错误类
 **/
- (void)onErrorString:(IFlySpeechError *)error;


/**
 ** 改变显示图片
 **/
- (void)onImageChangeWith:(CGFloat)i;


@end

@interface SJVoiceIdentifyHelper : NSObject<IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate>
@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
@property (nonatomic, strong) IFlyDataUploader *uploader;//数据上传对象

@property(nonatomic)BOOL isrIdentifyImg; // 是否有识别图片

@property (nonatomic, weak) id <SJVoiceIdentifyHelperDelegate> delegate;// 代理

// 单例
+ (SJVoiceIdentifyHelper *) sharedInstance;

/**
 设置识别参数
 ****/
-(void)initRecognizer;

/**
 启动听写
 *****/
- (void)startBtnHandler;

/**
 取消
 ****/
-(void)detectionStart;
/**
 完成
 ****/
-(void)stopListening;

@end
