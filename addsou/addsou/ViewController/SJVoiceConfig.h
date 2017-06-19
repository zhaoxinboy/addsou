//
//  SJVoiceConfig.h
//  addsou
//
//  Created by 杨兆欣 on 2017/5/10.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iflyMSC/IFlyMSC.h"


@interface SJVoiceConfig : NSObject

+(SJVoiceConfig *)sharedInstance;


+(NSString *)mandarin;  // 普通话
+(NSString *)cantonese; // 广东话
+(NSString *)henanese;  // 河南话
+(NSString *)chinese;   // 中文
+(NSString *)english;   // 英文
+(NSString *)lowSampleRate; // 低采样率
+(NSString *)highSampleRate;    // 高采样率
+(NSString *)isDot;
+(NSString *)noDot;


/**
 以下参数，需要通过
 iFlySpeechRecgonizer
 进行设置
 ****/
@property (nonatomic, strong) NSString *speechTimeout;
@property (nonatomic, strong) NSString *vadEos;
@property (nonatomic, strong) NSString *vadBos;

@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *accent;

@property (nonatomic, strong) NSString *dot;
@property (nonatomic, strong) NSString *sampleRate;


/**
 以下参数无需设置
 不必关
 ****/
@property (nonatomic, assign) BOOL haveView;
@property (nonatomic, strong) NSArray *accentIdentifer;
@property (nonatomic, strong) NSArray *accentNickName;


@end
