//
//  QDRRegisteredTableView.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/1.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"


@interface QDRRegisteredTableView : UITableView

@property (nonatomic, strong) NSString *titleText;   /* 标题 */

@property (nonatomic, strong) UILabel *tLabel;   /* 标题 */

@property (nonatomic, strong) UILabel *phoneLabel;                 // 手机号

@property (nonatomic, strong) UITextField *verificationCodeTF;      //验证码输入框

@property (nonatomic, strong) NSString *verificationCodeStr;        //保存验证码

@property (nonatomic, strong) JKCountDownButton *verificationCodeBtn;   // 倒计时按钮

@property (nonatomic, strong) UITextField *passWordTF;              // 密码输入框

@property (nonatomic, strong) UITextField *confirmPWTF;         // 确认密码输入框

@property (nonatomic, strong) UIButton *loginBtn;                   // 登录按钮

@property (nonatomic, assign) NSInteger KVOlogin;                   // KVO登录监听


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style phoneText:(NSString *)phone titleText:(NSString *)titleText;

@end
