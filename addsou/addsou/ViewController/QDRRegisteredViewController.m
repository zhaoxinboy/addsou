//
//  QDRRegisteredViewController.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/1.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRRegisteredViewController.h"
#import "QDRRegisteredTableView.h"
#import "QDRUserFeedbackViewController.h"

@interface QDRRegisteredViewController ()

@property (nonatomic, strong) QDRRegisteredTableView *registeredTableView;

@property (nonatomic, strong) SJNavcView *navcView;   /* 自定义导航 */

@property (nonatomic, strong) NSString *phoneText;   /* 手机号 */

@property (nonatomic, strong) NSString *titleText;   /* 标题 */

@end

@implementation QDRRegisteredViewController

- (SJNavcView *)navcView{
    if (!_navcView) {
        _navcView = [[SJNavcView alloc] init];
        [self.view addSubview:_navcView];
        [_navcView.goBackBtn addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
        _navcView.titleLabel.text = self.titleText;
    }
    return _navcView;
}

- (instancetype)initWithPhone:(NSString *)phoneText titleText:(NSString *)titleText
{
    self = [super init];
    if (self) {
        self.phoneText = phoneText;
        self.titleText = titleText;
    }
    return self;
}

- (QDRRegisteredTableView *)registeredTableView
{
    if (!_registeredTableView) {
        _registeredTableView = [[QDRRegisteredTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain phoneText:self.phoneText titleText:self.titleText];
        [self.view addSubview:_registeredTableView];
        [_registeredTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(64);
        }];
    }
    return _registeredTableView;
}

- (void)dealloc
{
    /* 移除KVO */
    [self.registeredTableView removeObserver:self forKeyPath:@"KVOreadNum" context:nil];
    [self.registeredTableView removeObserver:self forKeyPath:@"KVOlogin" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // 注册KVO监听  注册页面  用户反馈
    [self.registeredTableView addObserver:self forKeyPath:@"KVOreadNum" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.registeredTableView addObserver:self forKeyPath:@"KVOlogin" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    
    [self registeredTableView];
    
    [self navcView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews
{
    
}

- (void)go2Back
{
    [self.navigationController popViewControllerAnimated:YES];
}

/* KVO调用方法 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    __weak QDRRegisteredViewController* wself = self;
    if (object == self.registeredTableView) {
        if([keyPath isEqualToString:@"KVOreadNum"])
        {
            
            // 响应变化处理  条款
            
            
            //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
            NSLog(@"\noldKVOnum:%@ newKVOnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
        }else if([keyPath isEqualToString:@"KVOlogin"]){ //相应登录
            
            
            if ([self.titleText isEqualToString:@"手机注册"]) {
                [self.loginVM postDataFromWithUserName:self.registeredTableView.phoneLabel.text passWord:self.registeredTableView.passWordTF.text mobile:self.registeredTableView.phoneLabel.text verfycode:self.registeredTableView.verificationCodeTF.text serialnumber:LOCAL_READ_UUID codeid:wself.registeredTableView.verificationCodeStr NetCompleteHandle:^(NSError *error) {
                    if ([wself.loginVM.status isEqualToString:@"0"]) {
                        [wself showSuccessMsg:@"注册成功"];
                        [wself.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            }else if([self.titleText isEqualToString:@"重置密码"]){
                [self.loginVM postResetPasswordWithPassWord:self.registeredTableView.passWordTF.text mobile:self.registeredTableView.phoneLabel.text verfycode:self.registeredTableView.verificationCodeTF.text codeid:self.registeredTableView.verificationCodeStr NetCompleteHandle:^(NSError *error) {
                    if ([wself.loginVM.status isEqualToString:@"0"]) {
                        [wself showSuccessMsg:@"密码修改成功"];
                        [wself.navigationController popViewControllerAnimated:YES];
                    }else{
                        [wself showErrorMsg:@"密码修改失败"];
                    }
                }];
            }
            
            
            
            
            //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
            NSLog(@"\noldKVOnum:%@ newKVOnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
        }
    }
    
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
