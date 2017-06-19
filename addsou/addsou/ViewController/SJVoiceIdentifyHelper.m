//
//  SJVoiceIdentifyHelper.m
//  addsou
//
//  Created by 杨兆欣 on 2017/5/10.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJVoiceIdentifyHelper.h"
#import "SJVoiceConfig.h"
#import "SJVoiceDataHelper.h"

@implementation SJVoiceIdentifyHelper

static SJVoiceIdentifyHelper *isrIdentifydObj = nil;

+ (SJVoiceIdentifyHelper *)sharedInstance {
    @synchronized (self) {
        if (isrIdentifydObj == nil) {
            isrIdentifydObj = [[self alloc] init];
        }
    }
    return isrIdentifydObj;
}


-(void)detectionStart{
    if ([SJVoiceConfig sharedInstance].haveView == NO) {//无界面
        [_iFlySpeechRecognizer cancel]; //取消识别
        [_iFlySpeechRecognizer setDelegate:nil];
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    }
    else
    {
        [_iflyRecognizerView cancel]; //取消识别
        [_iflyRecognizerView setDelegate:nil];
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    }
}


/**
 启动听写
 *****/
- (void)startBtnHandler {
    
    
    if ([SJVoiceConfig sharedInstance].haveView == NO) {//无界面
        
        [_iFlySpeechRecognizer cancel];
        
        //设置音频来源为麦克风
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        _iFlySpeechRecognizer.delegate=self;
        [_iFlySpeechRecognizer setDelegate:self];
        
        BOOL ret = [_iFlySpeechRecognizer startListening];
        
        if (ret) {
            
        }else{
            NSLog(@"启动识别服务失败，请稍后重试");
        }
    }else {
        
        
        //设置音频来源为麦克风
        [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        [_iflyRecognizerView start];
    }
    
}


/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged:(int)volume
{
    CGFloat m = (CGFloat)volume / 30.0;
    NSString *str = [NSString stringWithFormat:@"%.1f", m];
    CGFloat i = str.floatValue;
    NSLog(@"%f", i);
    if (self.delegate && [self.delegate respondsToSelector:@selector(onImageChangeWith:)]) {
        [self.delegate onImageChangeWith:i];
    }
    
    
    //    NSLog(@"声音==%d",volume);
//    if (volume>5&&volume<=10){
//        [self.delegate onVolumeChangedImgisrIdentifyDelegate:[UIImage imageNamed:@"语音 2"]];
//        return;
//    }else if (volume>10&&volume<=15){
//        [self.delegate onVolumeChangedImgisrIdentifyDelegate:[UIImage imageNamed:@"语音 3"]];
//        return;
//    }else if (volume>15&&volume<=20){
//        [self.delegate onVolumeChangedImgisrIdentifyDelegate:[UIImage imageNamed:@"语音 4"]];
//        return;
//    }else if (volume>20&&volume<=25){
//        [self.delegate onVolumeChangedImgisrIdentifyDelegate:[UIImage imageNamed:@"语音 5"]];
//        return;
//    }else if (volume>25&&volume<=30){
//        [self.delegate onVolumeChangedImgisrIdentifyDelegate:[UIImage imageNamed:@"语音 6"]];
//        return;
//    }else{
//        [self.delegate onVolumeChangedImgisrIdentifyDelegate:[UIImage imageNamed:@"语音 1"]];
//        return;
//    }
    
}
/**
 设置识别参数
 ****/
-(void)initRecognizer {
    if ([SJVoiceConfig sharedInstance].haveView == NO) {//无界面
        
        //单例模式，无UI的实例
        if (_iFlySpeechRecognizer == nil) {
            _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
            
            [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            
            //设置听写模式
            [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        }
        _iFlySpeechRecognizer.delegate = self;
        
        if (_iFlySpeechRecognizer != nil) {
            SJVoiceConfig *instance = [SJVoiceConfig sharedInstance];
            
            //设置最长录音时间
            [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //设置后端点
            [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //设置前端点
            [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //网络等待时间
            [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //设置采样率，推荐使用16K
            [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            
            if ([instance.language isEqualToString:[SJVoiceConfig chinese]]) {
                //设置语言
                [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
                //设置方言
                [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            }else if ([instance.language isEqualToString:[SJVoiceConfig english]]) {
                [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            }
            //设置是否返回标点符号
            [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
    }else  {//有界面
        
        //单例模式，UI的实例
        if (_iflyRecognizerView == nil) {
            //UI显示剧中
            //            _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.center];
            
            [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            
            //设置听写模式
            [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
            
        }
        _iflyRecognizerView.delegate = self;
        
        if (_iflyRecognizerView != nil) {
            SJVoiceConfig *instance = [SJVoiceConfig sharedInstance];
            //设置最长录音时间
            [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //设置后端点
            [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //设置前端点
            [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //网络等待时间
            [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //设置采样率，推荐使用16K
            [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            if ([instance.language isEqualToString:[SJVoiceConfig chinese]]) {
                //设置语言
                [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
                //设置方言
                [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            }else if ([instance.language isEqualToString:[SJVoiceConfig english]]) {
                //设置语言
                [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            }
            //设置是否返回标点符号
            [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
    }
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onErrorString:)]) {
        [self.delegate onErrorString:error];
    }
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *)results isLast:(BOOL)isLast {
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  [SJVoiceDataHelper stringFromJson:resultString];
    DLog(@"语音语音===%@",resultFromJson);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onResultsString:isLast:)]) {
        [self.delegate onResultsString:[NSString stringWithFormat:@"%@", resultFromJson] isLast:isLast];
    }
}



/**
 有界面，听写结果回调
 resultArray：听写结果
 isLast：表示最后一次
 ****/
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
}

-(void)stopListening{
    [_iFlySpeechRecognizer stopListening];
}


@end
