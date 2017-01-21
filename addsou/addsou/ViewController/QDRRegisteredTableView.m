//
//  QDRRegisteredTableView.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/1.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRRegisteredTableView.h"
#import "SJLoginViewModel.h"


@interface QDRRegisteredTableView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) SJLoginViewModel *loginVM;   /* wangluo */

@end

@implementation QDRRegisteredTableView

- (SJLoginViewModel *)loginVM{
    if (!_loginVM) {
        _loginVM = [SJLoginViewModel new];
    }
    return _loginVM;
}

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.font = [UIFont systemFontOfSize:20 weight:1.3];
        _phoneLabel.textColor = kRGBColor(51, 51, 51);
        
    }
    return _phoneLabel;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style phoneText:(NSString *)phone titleText:(NSString *)titleText
{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        [self phoneLabel];
        self.phoneLabel.text = phone;
        self.titleText = titleText;
        // 隐藏cell分割线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 去掉多余cell
        self.tableFooterView = [UIView new];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QDRRegisteredTableView"];
    }
    return self;
}


#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDRRegisteredTableView" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    switch (indexPath.row) {
        case 0:
            if (!_tLabel) {
                _tLabel = [UILabel new];
                if ([self.titleText isEqualToString:@"手机注册"]) {
                    _tLabel.text = @"验证你的手机号码并注册";
                }else{
                    _tLabel.text = @"验证你的手机号并创建新密码";
                }
                _tLabel.textColor = kRGBColor(102, 102, 102);
                _tLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:_tLabel];
                [_tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(0);
                    make.top.mas_equalTo(12);
                }];
                
                [cell.contentView addSubview:_phoneLabel];
                [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(0);
                    make.top.mas_equalTo(66);
                }];
            }
            break;
        case 1:
            if (!_verificationCodeTF) {
                _verificationCodeTF = [UITextField new];
                _verificationCodeTF.tintColor = [UIColor redColor];
                _verificationCodeTF.placeholder = @"验证码";
                _verificationCodeTF.backgroundColor = kRGBColor(245, 245, 245);
                _verificationCodeTF.returnKeyType = UIReturnKeyNext;
                [_verificationCodeTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
                _verificationCodeTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                _verificationCodeTF.layer.cornerRadius = 4;
                _verificationCodeTF.layer.masksToBounds = YES;
                _verificationCodeTF.borderStyle = UITextBorderStyleNone;
                _verificationCodeTF.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:_verificationCodeTF];
                [_verificationCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(25);
                    make.centerY.mas_equalTo(0);
                    make.right.mas_equalTo(-160);
                    make.height.mas_equalTo(40);
                }];
                
                UIView *paddingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
                paddingView1.backgroundColor = [UIColor clearColor];
                _verificationCodeTF.leftView = paddingView1;
                _verificationCodeTF.leftViewMode = UITextFieldViewModeAlways;
                
            }
            if (!_verificationCodeBtn) {
                _verificationCodeBtn = [[JKCountDownButton alloc] init];
                [_verificationCodeBtn addTarget:self action:@selector(yanzhengma) forControlEvents: UIControlEventTouchUpInside];
                [_verificationCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                [_verificationCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_verificationCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [_verificationCodeBtn.layer setMasksToBounds:YES];
                [_verificationCodeBtn.layer setCornerRadius:4];
                _verificationCodeBtn.backgroundColor = kRGBColor(51, 51, 51);
                
                _verificationCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                [cell.contentView addSubview:_verificationCodeBtn];
                [_verificationCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-25);
                    make.centerY.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(105, 40));
                }];
            }
            break;
        case 2:
            if (!_passWordTF) {
                _passWordTF = [UITextField new];
                _passWordTF.tintColor = [UIColor redColor];
                _passWordTF.backgroundColor = kRGBColor(245, 245, 245);
                _passWordTF.placeholder = @"密码(大于6位的字母和数字)";
                _passWordTF.returnKeyType = UIReturnKeyNext;
                [_passWordTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
                _passWordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                _passWordTF.borderStyle = UITextBorderStyleNone;
                _passWordTF.keyboardType = UIKeyboardTypeDefault;
                _passWordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
                _passWordTF.secureTextEntry = YES;
                _passWordTF.delegate = self;
                _passWordTF.layer.cornerRadius = 4;
                _passWordTF.layer.masksToBounds = YES;
                [cell.contentView addSubview:_passWordTF];
                [_passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(25);
                    make.centerY.mas_equalTo(0);
                    make.right.mas_equalTo(-25);
                    make.height.mas_equalTo(40);
                }];
                UIView *paddingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
                paddingView1.backgroundColor = [UIColor clearColor];
                _passWordTF.leftView = paddingView1;
                _passWordTF.leftViewMode = UITextFieldViewModeAlways;
            }
            break;
        case 3:
            if (!_confirmPWTF) {
                _confirmPWTF = [UITextField new];
                _confirmPWTF.tintColor = [UIColor redColor];
                _confirmPWTF.backgroundColor = kRGBColor(245, 245, 245);
                _confirmPWTF.placeholder = @"请再次输入密码";
                [_confirmPWTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
                _confirmPWTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                _confirmPWTF.clearButtonMode = UITextFieldViewModeWhileEditing;
                _confirmPWTF.borderStyle = UITextBorderStyleNone;
                _confirmPWTF.keyboardType = UIKeyboardTypeDefault;
                _confirmPWTF.returnKeyType = UIReturnKeyGo;
                _confirmPWTF.secureTextEntry = YES;
                _confirmPWTF.delegate = self;
                _confirmPWTF.layer.cornerRadius = 4;
                _confirmPWTF.layer.masksToBounds = YES;
                [cell.contentView addSubview:_confirmPWTF];
                [_confirmPWTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(25);
                    make.centerY.mas_equalTo(0);
                    make.right.mas_equalTo(-25);
                    make.height.mas_equalTo(40);
                }];
                UIView *paddingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
                paddingView1.backgroundColor = [UIColor clearColor];
                _confirmPWTF.leftView = paddingView1;
                _confirmPWTF.leftViewMode = UITextFieldViewModeAlways;
            }
            break;
        case 4:
            if (!_loginBtn) {
                _loginBtn = [UIButton new];
                if ([self.titleText isEqualToString:@"手机注册"]) {
                    [_loginBtn setTitle:@"完成" forState:UIControlStateNormal];
                }else{
                    [_loginBtn setTitle:@"提交" forState:UIControlStateNormal];
                }
                _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_loginBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
                [_loginBtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
                _loginBtn.backgroundColor = kRGBColor(51, 51, 51);
                _loginBtn.layer.masksToBounds = YES;
                _loginBtn.layer.cornerRadius = 4;
                
                [cell.contentView addSubview:_loginBtn];
                [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(25);
                    make.right.mas_equalTo(-25);
                    make.height.mas_equalTo(40);
                    make.centerY.mas_equalTo(0);
                }];
            }

            break;
            
        default:
            break;
    }
    
    // 被选中不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)jump2web
{
    NSLog(@"跳转到web页面");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat i = 0.0;
    switch (indexPath.row) {
        case 0:
            i = 104;
            break;
        case 1:
            i = 64;
            break;
        case 2:
            i = 64;
            break;
        case 3:
            i = 64;
            break;
        case 4:
            i = 64;
            break;
        default:
            break;
    }
    return i;
}

// 表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}

- (void)check:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

// 验证码
- (void)yanzhengma
{
    NSString *phoneStr = self.phoneLabel.text;
    if ([phoneStr isMobilePhoneNumber]) {// 如果手机号正确
        __weak QDRRegisteredTableView *wself = self;
        NSString *type = [[NSString alloc] init];
        if ([self.titleText isEqualToString:@"手机注册"]) {
            type = @"1";
        }else{
            type = @"2";
        }
        [self.loginVM getVerfyCodeWithUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] andMobile:phoneStr  andType:type NetCompleteHandle:^(NSError *error) {
            if (wself.loginVM.codeid) {//获取验证码成功
                // 获取验证码成功后试验证码输入框为第一响应者
                if ([wself.passWordTF isFirstResponder]) {
                    [wself.passWordTF resignFirstResponder];
                }else if ([wself.confirmPWTF isFirstResponder]) {
                    [wself.confirmPWTF resignFirstResponder];
                }
                [wself.verificationCodeTF becomeFirstResponder];
                
                wself.verificationCodeStr = wself.loginVM.codeid;// 保存验证码
                
                _verificationCodeBtn.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
                _verificationCodeBtn.enabled = NO;
                [_verificationCodeBtn startWithSecond:60];
                [_verificationCodeBtn didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
                    NSString *title = [NSString stringWithFormat:@"%d秒", second];
                    return title;
                }];
                [_verificationCodeBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                    countDownButton.enabled = YES;
                    countDownButton.backgroundColor = kRGBColor(51, 51, 51);
                    return @"重新获取";
                }];
            }else{// 获取验证码失败
                [self showErrorMsg:@"获取失败，请重试"];
            }
            
        }];
        
        
    }else{
        // 手机号不正确
        [self showErrorMsg:@"请输入正确的手机号"];
    };
    
}
//  登录按钮普通状态下的背景色及点击事件
- (void)button1BackGroundNormal:(UIButton *)sender
{
    _loginBtn.backgroundColor = kRGBColor(51, 51, 51);
    if (![_passWordTF.text isEqualToString:_confirmPWTF.text]) {
        [self showErrorMsg:@"两次输入密码不一致，请重新输入"];
    }else if (_passWordTF.text.length < 8 || _confirmPWTF.text.length < 8) {
        [self showErrorMsg:@"密码长度不够，请重新输入"];
    }else if (!_readBtn.selected) {
        [self showErrorMsg:@"阅读并接受条款"];
    }else{
        self.KVOlogin += 1;
    }
}
//  登录按钮高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = [UIColor grayColor];
}

//阅读条款
- (void)readterms
{
    // KVO监听
    self.KVOreadNum += 1;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![[touches anyObject].view isEqual:self.passWordTF]) {
        if ([self.passWordTF isFirstResponder]) {
            [self.passWordTF resignFirstResponder];
        }
    }
    if (![[touches anyObject].view isEqual:self.confirmPWTF]) {
        if ([self.confirmPWTF isFirstResponder]) {
            [self.confirmPWTF resignFirstResponder];
        }
    }
    if (![[touches anyObject].view isEqual:self.verificationCodeTF]) {
        if ([self.verificationCodeTF isFirstResponder]) {
            [self.verificationCodeTF resignFirstResponder];
        }
    }
    
}

// 键盘代理方法：右下角按钮点击方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_passWordTF == textField) {  //密码输入框
        if ([self.passWordTF isFirstResponder]) {
            [self.passWordTF resignFirstResponder];
            [self.confirmPWTF becomeFirstResponder];
        }
    }else{ // 确认密码输入框
        if (![_passWordTF.text isEqualToString:_confirmPWTF.text]) {
            [self showErrorMsg:@"两次输入密码不一致，请重新输入"];
        }else if (_passWordTF.text.length < 8 || _confirmPWTF.text.length < 8) {
            [self showErrorMsg:@"密码长度不够，请重新输入"];
        }else if (!_readBtn.selected) {
            [self showErrorMsg:@"阅读并接受条款"];
        }else{
            self.KVOlogin += 1;
        }
    }
    
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
