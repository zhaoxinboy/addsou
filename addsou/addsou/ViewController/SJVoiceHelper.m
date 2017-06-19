//
//  SJVoiceHelper.m
//  addsou
//
//  Created by 杨兆欣 on 2017/5/10.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJVoiceHelper.h"

@implementation SJVoiceHelper

- (SJVoiceIdentifyHelper *)identifyHelper {
    if (!_identifyHelper) {
        _identifyHelper = [SJVoiceIdentifyHelper sharedInstance];
        [_identifyHelper initRecognizer];
        _identifyHelper.delegate = self;
    }
    return _identifyHelper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self identifyHelper];
    }
    return self;
}

+ (SJVoiceHelper *)sharedInstance {
    static SJVoiceHelper  *instance = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        instance = [[SJVoiceHelper alloc] init];
    });
    return instance;
}


// 结果
- (void)onResultsString:(NSString *)resultStr isLast:(BOOL)isLast {
    self.voiceRecognitionIsEnd = isLast;
    if (self.resultBlock) {
        self.resultBlock(resultStr, isLast);
    }
}

// 错误信息
- (void)onErrorString:(IFlySpeechError *)error{
    if (self.errorBlock) {
        self.errorBlock(error);
    }
}


// 改变图片
- (void)onImageChangeWith:(CGFloat)i{
    if (!self.voiceIsCancel) {
        if (self.imageChangeBlock) {
            self.imageChangeBlock(i);
        }
    }
}

@end
