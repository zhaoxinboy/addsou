//
//  SJPhoneViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/12.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJPhoneViewController.h"
#import "QDRRegisteredViewController.h"

@interface SJPhoneViewController ()


@property (nonatomic, strong) NSString *titleStr;   /* 提示语 */

@property (nonatomic, strong) NSString *tStr;   /* 提示语 */

@property (nonatomic, strong) SJNavcView *navcView;   // 自定义导航

@property (nonatomic, strong) UILabel *titleLb;   /* 提示语 */

@property (nonatomic, strong) UITextField *phoneText;   /* 手机号输入框 */

@end

@implementation SJPhoneViewController

- (instancetype)initWithTitleStr:(NSString *)titleStr titleStr:(NSString *)tStr
{
    self = [super init];
    if (self) {
        self.titleStr = titleStr;
        self.tStr = tStr;
    }
    return self;
}

- (SJNavcView *)navcView{
    if (!_navcView) {
        _navcView = [[SJNavcView alloc] init];
        [self.view addSubview:_navcView];
        [_navcView.goBackBtn setImage:[UIImage imageNamed:@"nav_icon_close"] forState:UIControlStateNormal];
        [_navcView.goBackBtn addTarget:self action:@selector(go2back) forControlEvents:UIControlEventTouchUpInside];
        _navcView.rightBtn.alpha = 1;
        _navcView.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_navcView.rightBtn setTitleColor:kRGBColor(102, 102, 102) forState:UIControlStateNormal];
        [_navcView.rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_navcView.rightBtn addTarget:self action:@selector(go2next) forControlEvents:UIControlEventTouchUpInside];
        _navcView.titleLabel.text = self.titleStr;
        
    }
    return _navcView;
}

- (void)go2back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)go2next{
    if ([self.phoneText.text isMobilePhoneNumber]) {
        QDRRegisteredViewController *vc = [[QDRRegisteredViewController alloc] initWithPhone:self.phoneText.text titleText:self.titleStr];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self showErrorMsg:@"请输入正确的手机号"];
    }
    DLog(@"下一个页面")
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb =  [UILabel new];
        _titleLb.text = self.tStr;
        _titleLb.font = [UIFont systemFontOfSize:16];
        _titleLb.textColor = kRGBColor(51, 51, 51);
        [self.view addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(101);
        }];
    }
    return _titleLb;
}

- (UITextField *)phoneText{
    if (!_phoneText) {
        
        _phoneText = [UITextField new];
        _phoneText.tintColor = [UIColor redColor];
        _phoneText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneText.layer.cornerRadius = 4;
        _phoneText.layer.masksToBounds = YES;
        _phoneText.backgroundColor = kRGBColor(245, 245, 245);
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;
        _phoneText.font = [UIFont systemFontOfSize:16];
        
        UIView *paddingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        paddingView1.backgroundColor = [UIColor clearColor];
        UILabel *label = [UILabel new];
        label.textColor = kRGBColor(51, 51, 51);
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"+86";
        [paddingView1 addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        _phoneText.leftView = paddingView1;
        _phoneText.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:_phoneText];
        [_phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.height.mas_equalTo(40);
            make.right.mas_equalTo(-24);
            make.top.mas_equalTo(155);
        }];

        
    }
    return _phoneText;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![[touches anyObject].view isEqual:self.phoneText]) {
        if ([self.phoneText isFirstResponder]) {
            [self.phoneText resignFirstResponder];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self navcView];
    
    [self titleLb];
    [self phoneText];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
