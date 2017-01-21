//
//  SJProgressHUD.h
//  addsou
//
//  Created by 杨兆欣 on 2016/12/30.
//  Copyright © 2016年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeError,   // 错误
    MessageTypeSuccess, // 成功
    MessageTypeWarning  // 警告
};

@interface SJProgressHUD : UIView

@property (nonatomic, strong) UILabel *progressLabel;   /* 提示文字 */

+ (instancetype)shareProgressHUD;
- (SJProgressHUD *)showView;


/**
 设置提醒框的类型及提醒内容
 
 @param messageType 消息类型
 @param message 消息内容
 */
- (void)setMessageType:(MessageType)messageType andMessage:(NSString *)message;

@end
