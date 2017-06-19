//
//  SJVoiceHelper.h
//  addsou
//
//  Created by 杨兆欣 on 2017/5/10.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJVoiceIdentifyHelper.h"
#import "SJVoiceTuBeView.h"

typedef void(^ResultBlock)(NSString *resultStr, BOOL isLast); // 获取的结果
typedef void(^ErrorBlock)(IFlySpeechError *error); // 获取的结果
typedef void(^ImageChangeBlock)(CGFloat i); // 获取的结果

@interface SJVoiceHelper : NSObject<SJVoiceIdentifyHelperDelegate>

@property (nonatomic, strong) SJVoiceIdentifyHelper *identifyHelper;


@property (nonatomic, strong) SJVoiceTuBeView *voiceTuBeView;

@property (nonatomic, strong) UIImageView     *voiceIconImage;
@property (nonatomic, strong) UILabel         *voiceIocnTitleLable;
@property (nonatomic, strong) UIView          *voiceImageSuperView;
@property (nonatomic, assign) BOOL            voiceIsCancel;
@property (nonatomic, assign) BOOL            voiceRecognitionIsEnd;
@property (nonatomic, assign) BOOL            touchIsEnd;

@property (nonatomic, strong) UIImage         *normalImage;
@property (nonatomic, strong) UIImage         *selectedImage;
@property (nonatomic, copy)   NSString        *voiceString;



@property (nonatomic, copy) ResultBlock resultBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;
@property (nonatomic, copy) ImageChangeBlock imageChangeBlock;


+ (SJVoiceHelper *)sharedInstance;

@end
