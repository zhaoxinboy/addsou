//
//  QDRLoginView.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/1.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRLoginView.h"
#import "AppDelegate.h"

@interface QDRLoginView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end


@implementation QDRLoginView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        // 隐藏cell分割线
        self.separatorStyle = NO;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QDRLoginView"];
        
        
    }
    return self;
}


#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDRLoginView" forIndexPath:indexPath];
    
    
    switch (indexPath.row) {
        case 0:
            if (!_gobackBtn) {
                _gobackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_gobackBtn setImage:[UIImage imageNamed:@"nav_icon_close"] forState:UIControlStateNormal];
                [_gobackBtn addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:_gobackBtn];
                [_gobackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(66, 44));
                    make.top.mas_equalTo(20);
                    make.left.mas_equalTo(0);
                }];
            }
            if (!_loginLabel) {
                _loginLabel = [UILabel new];
                _loginLabel.text = @"登录搜加";
                _loginLabel.font = [UIFont systemFontOfSize:24 weight:1.5];
                _loginLabel.textColor = kRGBColor(51, 51, 51);
                [cell.contentView addSubview:_loginLabel];
                [_loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(0);
                    make.top.mas_equalTo((kWindowW <= 320) ? SJ_ADAPTER_HEIGHT(60) : SJ_ADAPTER_HEIGHT(90));
                }];
            }
            if (!_smallLabel) {
                _smallLabel = [UILabel new];
                _smallLabel.text = @"搜加账号登录";
                _smallLabel.font = [UIFont systemFontOfSize:12];
                _smallLabel.textColor = kRGBColor(153, 153, 153);
                [cell.contentView addSubview:_smallLabel];
                [_smallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(0);
                    make.top.mas_equalTo(_loginLabel.mas_bottom).mas_equalTo((kWindowW <= 320) ? SJ_ADAPTER_HEIGHT(40) : SJ_ADAPTER_HEIGHT(70));
                }];
            }
            
            break;
        case 1:
            if (!_phoneTF) {
                _phoneTF = [UITextField new];
                _phoneTF.placeholder = @"请输入账号";
                _phoneTF.tintColor = [UIColor redColor];
                _phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                _phoneTF.layer.cornerRadius = 4;
                _phoneTF.layer.masksToBounds = YES;
                _phoneTF.backgroundColor = kRGBColor(245, 245, 245);
                [_phoneTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_MOBILE]) {
                    _phoneTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_MOBILE];
                }
//                _phoneTF.borderStyle = UITextBorderStyleRoundedRect;
                _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
                
                UIView *paddingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
                paddingView1.backgroundColor = [UIColor clearColor];
                _phoneTF.leftView = paddingView1;
                _phoneTF.leftViewMode = UITextFieldViewModeAlways;
                [cell.contentView addSubview:_phoneTF];
                [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(24);
                    make.height.mas_equalTo(40);
                    make.right.mas_equalTo(-24);
                    make.top.mas_equalTo(0);
                }];
            }
            break;
        case 2:
            if (!_passWordTF) {
                _passWordTF = [UITextField new];
                _passWordTF.placeholder = @"请输入密码";
                _passWordTF.tintColor = [UIColor redColor];
                _passWordTF.returnKeyType = UIReturnKeyGo;
                _passWordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [_passWordTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
//                _passWordTF.borderStyle = UITextBorderStyleRoundedRect;
                _passWordTF.layer.cornerRadius = 4;
                _passWordTF.layer.masksToBounds = YES;
                _passWordTF.backgroundColor = kRGBColor(245, 245, 245);
                _passWordTF.keyboardType = UIKeyboardTypeDefault;
                _passWordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
                _passWordTF.secureTextEntry = YES;
                _passWordTF.delegate = self;
                if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_PASSWORD] && ![[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_PASSWORD] isEqualToString:LOCAL_READ_UUID]) {
                    _passWordTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_PASSWORD];
                    DLog(@"_passWordTF.text   %@", _passWordTF.text);
                }
                UIView *paddingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
                paddingView1.backgroundColor = [UIColor clearColor];
                _passWordTF.leftView = paddingView1;
                _passWordTF.leftViewMode = UITextFieldViewModeAlways;
                [cell.contentView addSubview:_passWordTF];
                [_passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(24);
                    make.height.mas_equalTo(40);
                    make.right.mas_equalTo(-24);
                    make.top.mas_equalTo(0);
                }];
            }

            break;
        case 3:
            
            if (!_loginBtn) {
                _loginBtn = [UIButton new];
                [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
                _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_loginBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
                [_loginBtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
                _loginBtn.backgroundColor = kRGBColor(51, 51, 51);
                _loginBtn.layer.masksToBounds = YES;
                _loginBtn.layer.cornerRadius = 4;
                
                [cell.contentView addSubview:_loginBtn];
                [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(24);
                    make.height.mas_equalTo(40);
                    make.right.mas_equalTo(-24);
                    make.top.mas_equalTo(0);
                }];
            }
            break;
        case 4:
            if (!_forgotBtn) {
                _forgotBtn = [UIButton new];
                _forgotBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [_forgotBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
                [_forgotBtn setTitleColor:kRGBColor(51, 51, 51) forState:UIControlStateNormal];
                [_forgotBtn addTarget:self action:@selector(go2forgot) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:_forgotBtn];
                [_forgotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-35);
                    make.top.mas_equalTo(16);
                    make.size.mas_equalTo(CGSizeMake(60, 20));
                }];
            }
            if (!_registerBtn) {
                _registerBtn = [UIButton new];
                _registerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [_registerBtn setTitleColor:kRGBColor(51, 51, 51) forState:UIControlStateNormal];
                [_registerBtn setTitle:@"快速注册" forState:UIControlStateNormal];
                [_registerBtn addTarget:self action:@selector(go2register) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:_registerBtn];
                [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(35);
                    make.top.mas_equalTo(16);
                    make.size.mas_equalTo(CGSizeMake(60, 20));
                }];
            }
            if (!_fastView) {
                _fastView = [UIView new];
                [cell.contentView addSubview:_fastView];
                [_fastView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(160, 20));
                    make.bottom.mas_equalTo(-100);
                }];
                UIView *line1 = [UIView new];
                line1.backgroundColor = kRGBColor(236, 236, 236);
                [_fastView addSubview:line1];
                [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(36, 1));
                    make.centerY.mas_equalTo(0);
                    make.left.mas_equalTo(0);
                }];
                UIView *line2 = [UIView new];
                line2.backgroundColor = kRGBColor(236, 236, 236);
                [_fastView addSubview:line2];
                [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(36, 1));
                    make.centerY.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                }];
                UILabel *label = [UILabel new];
                label.text = @"第三方账号直接登录";
                label.textColor = kRGBColor(153, 153, 153);
                label.font = [UIFont systemFontOfSize:11];
                [_fastView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(0);
                }];
                
            }
            if ([WXApi isWXAppInstalled]) {
                if (!_qqLogin) {
                    _qqLogin = [UIButton new];
                    [_qqLogin setImage:[UIImage imageNamed:@"login_icon_qq"] forState:UIControlStateNormal];
                    [_qqLogin addTarget:self action:@selector(go2qqlogin) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:_qqLogin];
                    [_qqLogin mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(44, 44));
                        make.right.mas_equalTo(cell.contentView.mas_centerX).mas_equalTo(-40);
                        make.bottom.mas_equalTo(-40);
                    }];
                }
                if (!_wxLogin) {
                    _wxLogin = [UIButton new];
                    [_wxLogin setImage:[UIImage imageNamed:@"login_icon_weixin"] forState:UIControlStateNormal];
                    [_wxLogin addTarget:self action:@selector(go2wxlogin) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:_wxLogin];
                    [_wxLogin mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(48, 48));
                        make.left.mas_equalTo(cell.contentView.mas_centerX).mas_equalTo(40);
                        make.bottom.mas_equalTo(-40);
                    }];
                }
            }else{
                if (!_qqLogin) {
                    _qqLogin = [UIButton new];
                    [_qqLogin setImage:[UIImage imageNamed:@"login_icon_qq"] forState:UIControlStateNormal];
                    [_qqLogin addTarget:self action:@selector(go2qqlogin) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:_qqLogin];
                    [_qqLogin mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(44, 44));
                        make.centerX.mas_equalTo(0);
                        make.bottom.mas_equalTo(-40);
                    }];
                }
            }
            break;
        default:
            break;
    }
    
    // 被选中不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)go2Back{
    self.gobackKVO += 1;
    DLog(@"%ld", (long)self.gobackKVO);
    DLog(@"返回上一页");
}

- (void)go2qqlogin{
    self.qqKVO += 1;
    DLog(@"%ld", (long)self.qqKVO);
    DLog(@"qq登陆");
}

- (void)go2wxlogin{
    
    self.KVOweixin += 1;
    DLog(@"%ld", (long)self.KVOweixin);
    DLog(@"微信登录");
}

- (void)go2forgot{
    self.KVOForgotNum += 1;
    DLog(@"忘记密码");
}

- (void)go2register{
    // kvo通知跳转
    self.KVORegisterNum += 1;
    DLog(@"去注册");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 44;
    switch (indexPath.row) {
        case 0:
            rowHeight = SJ_ADAPTER_HEIGHT(220);
            break;
        case 1:
            rowHeight = (kWindowW <= 320) ? 54 : 64;
            break;
        case 2:
            rowHeight = (kWindowW <= 320) ? 54 : 64;
            break;
        case 3:
            rowHeight = (kWindowW <= 320) ? 54 : 64;
            break;
        case 4:
            rowHeight = (kWindowW <= 320) ? (kWindowH - SJ_ADAPTER_HEIGHT(220) - 54 * 3) : (kWindowH - SJ_ADAPTER_HEIGHT(220) - 64 * 3);
            break;
        default:
            break;
    }
    return rowHeight;
}


//  登录按钮普通状态下的背景色及点击事件
- (void)button1BackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = kRGBColor(51, 51, 51);
    if (![_phoneTF.text isMobilePhoneNumber]) {
        [self showErrorMsg:@"手机号不正确"];
        return;
    }
    
    // KVO通知登录
    self.KVOLoginNum += 1;
}

//  登录按钮高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = [UIColor grayColor];
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (![[touches anyObject].view isEqual:self.phoneTF]) {
        if ([self.phoneTF isFirstResponder]) {
            [self.phoneTF resignFirstResponder];
        }
    }
    if (![[touches anyObject].view isEqual:self.passWordTF]) {
        if ([self.passWordTF isFirstResponder]) {
            [self.passWordTF resignFirstResponder];
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (_passWordTF == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 16) { //如果输入框内容大于16则弹出警告
            textField.text = [toBeString substringToIndex:16];
            
            return NO;
        }
    }
    return YES;
}

// 复选
- (void)check:(UIButton *)sender
{
    sender.selected = !sender.selected;
}


// 键盘代理方法：右下角按钮点击方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![_phoneTF.text isMobilePhoneNumber]) {
        [self showErrorMsg:@"手机号不正确"];
    }else{
        // KVO通知登录
        self.KVOLoginNum += 1;
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
